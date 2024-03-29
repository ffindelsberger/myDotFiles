
# Florians .files 

Welcome to my dot files repository! This repository contains configuration files and settings for various tools and applications to customize my Desktop/development environment. Below, you'll find links to the specific configuration files for Neovim, Tmux, Terminal, and i3, along with some general information about how to use these dot files.

The Target Plattforms for my .files are Linux Distros as Well as MacOS.
The .files are grouped into two main Areas, Development and Desktop Environment. If you are on MacOS then you are probably Interested in the Development-Environment Section as the Desktop Section won't work for you anyway.

## Table of Contents

1. [General Information](#general-information)
2. [Development](#Development)
    1. [Terminal](#terminal)
    2. [Neovim](#neovim)
    3. [Tmux](#tmux)
3. [i3](#i3)

## General Information

## Theme (Colors/Fonts) 

#### Theme
The color Palette for my Configuration is similiar to the Gruvbox Color palette. 

![theme image](theme.png "picture")

#### Font

The Main Font is Inconsolata, it is used in the Terminal and Nvim config, make sure a Nerd Font version of Inconsolata is installed.
[Nerd Font](https://github.com/ryanoasis/nerd-fonts)

Make sure the following Fonts are installed: 
- Inconsolata Nerd Font Version
- Noto Sans Mono (used in polybar) 
- Noto Color Emoji (used in polybar) 
- SourceHansSans (used in polybar)


# Development

## Terminal (Alacritty)

So you want to be one of the Hip Kids and use a new fancy OpenGL Terminal written in Rust ?
Because Alacritty is a relative "new" Terminal there is a chance that some Systems do not contain the needed Terminfo file.
Check the $TERM env var while being inside Alacritty to see if you have it on your System. 
''' echo $TERM '''
As a Neovim master, I'm here to save thousands of folks who want to use beautiful true color Alacritty with tmux. 

Check out the Alacritty repo over here (link einfügen)


//TODO: put in extra block
sudo tic -xe alacritty,alacritty-direct extra/alacritty.info

- [Terminal Configuration](terminal/README.md)
  - Information on customizing your terminal emulator settings and appearance.

## Neovim

- [Neovim Configuration](neovim/README.md)
  - Description and instructions for setting up and customizing Neovim.

## Tmux

- [Tmux Configuration](tmux/README.md)
  - Description and instructions for configuring Tmux for a productive terminal workflow.

## i3

- [i3 Window Manager Configuration](i3/README.md)
  - Instructions and configurations for i3, a tiling window manager, to enhance your desktop environment.

Feel free to explore each subtopic for detailed instructions and customization options. If you have any questions or suggestions, please don't hesitate to open an issue or submit a pull request. Happy coding!
