{ nixosConfig, pkgs, lib, ...}:
let 
  bg = nixosConfig.theme.colours.bg;
  font-size = if nixosConfig.setup.screen == "big" then "20" else "14";
in
{
  home.file."wofi-conf".target = ".config/wofi/style.css";
  home.file."wofi-conf".text = ''
#window {
margin: 0px;
border: none;
background-color: transparent;
}

#input {
font: Hack Nerd Font;
font-size: ${font-size}px;
margin: 0px;
border: none;
background-color: transparent;
color: #ffffff;
} 

#inner-box {
margin: 0px;
border: none;
background-color: ${bg};
}

#outer-box {
margin: 0px;
border: 2px solid #e06c75;
background-color: ${bg};
}

#scroll {
margin: 0px;
border: none;
background-color: transparent;
}

#text {
font: Hack Nerd Font;
font-size: ${font-size}px;
color: #ffffff;
margin: 5px;
border: none;
}

#entry:selected {
background-color: transparent;
color: transparent;
border: none;
}

#text:selected {
font: Hack Nerd Font;
font-size: ${font-size}px;
color: #61afef;
background-color: transparent;
border: none;
}
  '';
}
