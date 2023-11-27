# iMaaNor's Dotfiles

This is my dot files that include bspwm and xmonad and Hyprland and other stuff configs  

And yes i use stow for managing my Dotfiles  

Use configs at your own risk i'm not responsible for any possible issues!    
  
  
## Screenshots  
Hyprland  
![hyprland-screenshot](https://github.com/iMaaNor/dotfiles/blob/master/hyprland-screenshot.png)  
Xmonad  
![xmonad-screenshot](https://github.com/iMaaNor/dotfiles/blob/master/xmonad-screenshot.png)  
Bspwm  
![bspwm-screenshot](https://github.com/iMaaNor/dotfiles/blob/master/bspwm-screenshot.jpg)  
  

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
