{ nixosConfig, config, pkgs, lib, ...}:
let 
  size = if nixosConfig.setup.screen == "small" then "10" else "14";
in  
{
  home.file."config.rasi".text = ''
configuration {
 font: "hack ${size}";
 }
@theme "nord"
  '';
  home.file."config.rasi".target = ".config/rofi/config.rasi";

  home.file."nord.rasi".target = ".config/rofi/themes/nord.rasi";
  home.file."nord.rasi".text = ''
/*******************************************************************************
 * ROFI VERTICAL THEME USING THE NORD COLOR PALETTE 
 * User                 : LR-Tech               
 * Theme Repo           : https://github.com/lr-tech/rofi-themes-collection
 * Nord Project Repo    : https://github.com/arcticicestudio/nord
 *******************************************************************************/

* {
    nord0:     #202335;
    nord1:     #3b4252;
    nord2:     #434c5e;
    nord3:     #4c566a;

    nord4:     #d8dee9;
    nord5:     #e5e9f0;
    nord6:     #eceff4;

    nord7:     #8fbcbb;
    nord8:     #c678dd;
    nord9:     #81a1c1;
    nord10:    #5e81ac;
    nord11:    #bf616a;

    nord12:    #d08770;
    nord13:    #ebcb8b;
    nord14:    #a3be8c;
    nord15:    #b48ead;

    background-color:   transparent;
    text-color:         @nord4;
    accent-color:       @nord8;

    margin:     0px;
    padding:    0px;
    spacing:    0px;
}

window {
    background-color:   @nord0;
    border-color:       @accent-color;

    location:   center;
    width:      600px;
    y-offset:   0px;
    border:     2px;
}

inputbar {
    padding:    8px 12px;
    spacing:    12px;
    children:   [ prompt, entry ];
}

prompt, entry, element-text, element-icon {
    vertical-align: 0.5;
}

prompt {
    text-color: @accent-color;
}

listview {
    lines:      8;
    columns:    1;

    fixed-height:   false;
}

element {
    padding:    8px;
    spacing:    8px;
}

element normal urgent {
    text-color: @nord13;
}

element normal active {
    text-color: @accent-color;
}

element selected {
    text-color: @nord0;
}

element selected normal {
    background-color:   @accent-color;
}

element selected urgent {
    background-color:   @nord13;
}

element selected active {
    background-color:   @nord8;
}

element-icon {
    size:   0.75em;
}

element-text {
    text-color: inherit;
}

  '';
}
