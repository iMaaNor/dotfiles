# iMaaNor's Dotfiles

This is my dot files that include bspwm and xmonad configs  

And yes i use stow for managing my Dotfiles  
  
  
## Screenshots  
Xmonad  
![xmonad-screenshot](https://github.com/iMaaNor/dotfiles/blob/master/xmonad-screenshot.png)  
Bspwm  
![xmonad-screenshot](https://github.com/iMaaNor/dotfiles/blob/master/bspwm-screenshot.png)  
  

## Installation  
For installation first clone this repo *to your home directory*

```bash
git clone https://github.com/iMaaNor/dotfiles.git ~/dotfiles
```  

Then enter the folder

```bash
cd ~/dotfiles
```  
And use stow to symlink all configs

```bash
stow *
```

Or you can use this one-line code

```bash
git clone https://github.com/iMaaNor/dotfiles.git ~/dotfiles && cd ~/dotfiles && stow * 
```  
