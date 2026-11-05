---
name: go-http-services
description: Use when writing, extending, refactoring, or reviewing HTTP services in Go, including net/http handlers, routing, middleware, request validation, server lifecycle, and API tests. Applies Mat Ryer's explicit-dependency and testable-service patterns. Do not use for unrelated Go code or HTTP client-only work.
---

# Go HTTP services

Build readable, maintainable HTTP services with explicit dependencies and tests that exercise how callers actually use the API.

Adapted from [How I write HTTP services in Go after 13 years](https://grafana.com/blog/how-i-write-http-services-in-go-after-13-years/) by Mat Ryer, published February 10, 2024. The guidance below paraphrases the article; the final section identifies implementation corrections and safeguards rather than attributing them to the author.

## Workflow

1. Inspect the Go version, project instructions, router, service entry point, dependency wiring, and existing tests.
2. Identify the endpoint contract and the smallest change needed. For a new service, establish the lifecycle and dependency wiring before adding endpoints.
3. Apply the relevant patterns below. Respect established project conventions; these are defaults, not grounds for a wholesale rewrite or framework migration.
4. Test observable behavior at the appropriate boundary, including routing and middleware when they affect the change.
5. Format changed Go files and run relevant tests. Check concurrency-sensitive changes with the race detector when feasible. Report what was verified and any remaining gaps.

## 1. Construct the HTTP surface explicitly

- Use a `NewServer` constructor that receives its dependencies as arguments and returns `http.Handler` where practical.
- Create the mux, register routes, and apply service-wide middleware in this constructor. Leave listening and process lifecycle management to `run`.
- Prefer explicit dependency arguments over a shared server struct that gives every handler access to everything. Each handler should ask for exactly what it uses.
- Accept a longer argument list when it makes dependencies visible. Format it vertically instead of introducing a dependency container solely to shorten the signature.
- Prefer standard-library HTTP interfaces so handlers, middleware, and test tools compose naturally. Retain an existing router when appropriate.
- In tests, use `nil` for an unused dependency only when construction and the exercised request path genuinely do not access it.

## 2. Keep the API map in routes.go

- Make `routes.go` the discoverable map of the service's endpoints.
- Use an `addRoutes` function to register handler instances and route-specific middleware.
- Make authorization and other per-route wrappers visible at registration sites.
- Register values implementing `http.Handler` with `mux.Handle`. Reserve `mux.HandleFunc` for functions with the HTTP handler function signature.
- Keep route registration simple and flat. Perform fallible setup in `run` before constructing handlers where practical; return errors from construction when genuinely needed.
- Apply global middleware in `NewServer` and endpoint-specific middleware at the route. Be deliberate about wrapper order: the last outer wrapper executes first on incoming requests.

## 3. Keep main small and run testable

- Let `main` provide real OS dependencies, call `run`, report its error, and choose the process exit status.
- Put program setup and execution in a `run` function that takes a context and returns an error.
- Inject only the OS facilities the program uses: arguments, an environment lookup function, input/output streams, or a working-directory function.
- Use a local `flag.NewFlagSet` for flag parsing instead of global flag state.
- Inject environment lookup rather than mutating the real environment in tests. This keeps independent instances compatible with parallel tests.
- Avoid package-level mutable configuration and dependencies.
- Own signal notification and deferred cancellation inside `run` or another scope that returns before `main` calls `os.Exit`, so cleanup actually executes.

## 4. Make shutdown part of the lifecycle

- Propagate context to dependencies and long-running work. Check cancellation in loops and background goroutines.
- Configure an `http.Server` with the constructed handler and configured address; use `net.JoinHostPort` when combining a host and port.
- On cancellation, call `Shutdown` with a bounded context derived from a fresh, uncanceled context.
- Wait for shutdown and owned background work before returning from `run`.
- Treat `http.ErrServerClosed` as the expected result of a normal shutdown.
- Make each test's service instance stoppable through cancellation.

## 5. Use handler factories and closures

- Write a factory for each endpoint that accepts its dependencies and returns `http.Handler`, usually by wrapping a closure in `http.HandlerFunc`.
- Prepare handler-specific shared resources in the factory and allocate request-specific state inside the request closure.
- Treat captured shared data as immutable where possible. Synchronize mutations because requests execute concurrently.
- Store durable application state in a database or another suitable external store. A handler closure is not durable storage and is not shared between service instances.
- Keep endpoint-only request and response types local to the factory when they do not need methods or wider reuse.
- Move types to package scope when they need methods, such as `Valid`, or when sharing them has a concrete benefit.

## 6. Centralize encoding and decoding

- Use small shared helpers for response encoding and request decoding so transport policy changes have one implementation point.
- For JSON responses, set the content type before committing the response status, encode the body, and handle encoding errors.
- Wrap errors with useful operation context and preserve their cause with `%w`.
- Generic helpers are a reasonable fit: encoding can infer its type from the supplied value, while decoding needs an explicit result type.
- Keep helpers focused on transport concerns. Do not turn them into a framework or hide business operations inside them.

## 7. Separate validation from business checks

- For reusable payload validation, use a small `Validator` interface with a `Valid(context.Context) map[string]string` method. Here the return value is just a map but in some cases the project already uses some other Form of Error Descriptite Type then use that.
- Key validation problems by field name and return human-readable descriptions. An empty or nil map means the value is valid.
- Validate required fields, formats, and ranges here.
- Keep database lookups and consequential business checks in the explicit handler or service flow, rather than hiding them inside `Valid`.
- When useful, combine decoding and validation in a generic `decodeValid` helper constrained to `Validator`. Preserve field problems separately from decoding errors so the handler can produce the intended API response.
- Follow the project's response and status-code contract for malformed or invalid input.

## 8. Compose middleware as adapters

- Give simple middleware the shape `func(http.Handler) http.Handler`.
- Run pre-processing, call `next.ServeHTTP(w, r)`, and optionally perform post-processing.
- When rejecting a request, write the response and return without invoking the next handler.
- If several routes use middleware with the same dependencies, construct it once with those dependencies and return the wrapping function.
- Prefer a directly readable function signature over an extra named function type unless the project already benefits from that type.

## 9. Defer expensive setup only deliberately

- Consider `sync.Once` for expensive handler initialization that can reasonably wait until the first request.
- Keep the initialized value and its error in the factory closure. Check the stored error after `Once.Do` on every request.
- Understand the tradeoff: startup becomes cheaper, but the first request pays the cost and concurrent first requests wait.
- Remember that an initialization error is cached too; `sync.Once` does not provide retries.
- Prefer startup initialization when fail-fast behavior or predictable request latency matters more.

## 10. Test the service as callers use it

- Prefer meaningful API-level tests that exercise routing, middleware, serialization, and important dependency interactions together.
- When practical, call `run` with controlled dependencies and configuration so tests cover real startup behavior, including database setup where relevant.
- Give each test an isolated instance and context; use `t.Cleanup` to cancel it. Run tests in parallel only when ports, storage, and other resources are isolated.
- Wait for a successful HTTP response from a readiness endpoint such as `/readyz` or `/healthz` rather than sleeping for an assumed startup duration.
- Use focused handler tests when they help cover specific complexity: construct the handler, call `ServeHTTP` with a request and `httptest.ResponseRecorder`, then assert status, important headers, and decoded response data.
- Use small inline request/response structs in tests to emphasize the wire fields that matter instead of coupling every assertion to production types.
- Keep unit tests for business logic and cases that integration tests do not cover well. Avoid repeating the same behavioral assertions at every layer solely for coverage.
- Preserve useful existing tests; consolidation should follow demonstrated redundancy and the task's scope.

## Implementation corrections and safeguards

The article's snippets illustrate patterns rather than form a complete production template. Apply these correctness checks when implementing them:

- An `http.Handler` is an interface, not a callable function. Use `ServeHTTP`; do not copy the article's `h(w, r)` invocation.
- Propagate unexpected listening/serving failures back to `run`. Logging a bind error while waiting indefinitely for context cancellation leaves a failed service hanging.
- Readiness polling must check cancellation and deadlines, and wait between retries, including after connection errors. Use context-bounded requests and close every received response body. Do not copy a retry loop whose error branch bypasses all timeout checks.
- In tests, capture the result of background `run` calls and wait for their termination during cleanup. Cancellation alone does not prove shutdown finished.
- Once a response status or body has been written, a second error response cannot replace it. Handle late encoding failures without appending an unrelated response; consider encoding before committing headers when atomic encoding success is required.
- Choose payload limits, unknown-field handling, and trailing-JSON policy deliberately for the API. A single successful JSON decode does not establish that the entire body contains exactly one value.
- Match routing syntax and helper APIs to the project's Go version. Correct illustrative syntax rather than copying snippets verbatim.

## Completion checklist

- Dependencies are explicit and each handler receives only what it needs.
- Routes and middleware order are easy to locate and inspect.
- Request-local state is separate from concurrent shared state.
- Transport decoding, payload validation, and business checks have clear boundaries.
- Startup failures reach the caller, and cancellation leads to bounded, awaited shutdown.
- Tests cover the changed HTTP behavior and release their resources.
- Changes follow the repository's conventions and stay within the requested scope.




## API Design Patterns

while these examples are in typescript the concepts also apply to go code.

### RESTful API Structure

```typescript
// PASS: Resource-based URLs
GET    /api/markets                 # List resources
GET    /api/markets/:id             # Get single resource
POST   /api/markets                 # Create resource
PUT    /api/markets/:id             # Replace resource
PATCH  /api/markets/:id             # Update resource
DELETE /api/markets/:id             # Delete resource

// PASS: Query parameters for filtering, sorting, pagination
GET /api/markets?status=active&sort=volume&limit=20&offset=0
```

### Repository Pattern

```typescript
class MarketRepository  {
  async findAll(filters?: MarketFilters): Promise<Market[]> {
    let query = supabase.from('markets').select('*')

    if (filters?.status) {
      query = query.eq('status', filters.status)
    }

    if (filters?.limit) {
      query = query.limit(filters.limit)
    }

    const { data, error } = await query

    if (error) throw new Error(error.message)
    return data
  }

  // Other methods...
}
```

### Service Layer Pattern

```typescript
// Business logic separated from data access
class MarketService {
  constructor(private marketRepo: MarketRepository) {}

  async searchMarkets(query: string, limit: number = 10): Promise<Market[]> {
    // Business logic
    const embedding = await generateEmbedding(query)
    const results = await this.vectorSearch(embedding, limit)

    // Fetch full data
    const markets = await this.marketRepo.findByIds(results.map(r => r.id))

    // Sort by similarity
    return markets.sort((a, b) => {
      const scoreA = results.find(r => r.id === a.id)?.score || 0
      const scoreB = results.find(r => r.id === b.id)?.score || 0
      return scoreA - scoreB
    })
  }

  private async vectorSearch(embedding: number[], limit: number) {
    // Vector search implementation
  }
}
```


