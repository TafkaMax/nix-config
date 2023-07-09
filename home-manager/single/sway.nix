{ nixosConfig, config, pkgs, lib, ...}:
let
  output = if nixosConfig.setup.screen == "big" then ''
output HDMI-A-1 pos 0 0 res 3840x2160
output DP1 pos 3840 0 res 3840x2160
  '' else ''
output eDP-1 mode 1920x1080 position 0,0 scale 1 
  '';  
  mpc = if nixosConfig.setup.screen == "big" then ''
bindsym --locked XF86AudioPlay exec mpc toggle
bindsym --locked XF86AudioNext exec mpc next
bindsym --locked XF86AudioPrev exec mpc prev
  '' else ''
bindsym $mod+Shift+p exec mpc toggle 
  '';
  alacritty-font-size = if nixosConfig.setup.screen == "big" then ''
    -o font.size=14
  '' else "";
  secondLayout = if nixosConfig.setup.keyboard == "us" then "de" else "us";
in
{
  home.file."config-sway".target = ".config/sway/config";
  home.file."config-sway".text = ''
### monitor setup - Output configuration 
${output}    
default_border pixel 2 
gaps inner 0 
xwayland enable 

# Hintergrund brauch swaybg - sway selber kann das nicht 
output * bg ${nixosConfig.theme.colours.bg} solid_color 

### Variables # # Logo key. Use Mod1 for Alt. 
set $mod Mod4 
# Home row direction keys, like vim 
set $left h 
set $down j 
set $up k 
set $right l 
# Your preferred terminal emulator 
set $term alacritty 
# Your preferred application launcher 
# Note: pass the final command to swaymsg so that the resulting window can be opened 
# on the original workspace that the command was run on. 
# set $menu wofi --show=drun --lines=5 --prompt="" 

### Input configuration 
input * { 
    xkb_layout ${nixosConfig.setup.keyboard},${secondLayout}
    xkb_options grp:rctrl_toggle
} 

### Key bindings 
# Wie kann ich die Keysyms herausfinden ? 
# mit wev (yay -S wev) 
# die key Bezeichnungen die in sway/config stehen müssen sind nach sym: 

# 
# SwayNotificationCenter 
# 

bindsym $mod+Shift+n exec swaync-client -t -sw 

# 
# Swaylock 
# 

bindsym $mod+Escape exec swaylock -F -i /home/snd/.config/swaylock/green_forrest.jpg 

# 
# Screenshot 
# 

bindsym Print+w exec grimshot save window 
bindsym Print+c exec grimshot save area 
bindsym Print+a exec grimshot save screen 

#
# browser 
#

bindsym $mod+u exec librewolf

# 
# Display Helligkeit 
# 

# Helligkeit erhöhen 
bindsym XF86MonBrightnessDown exec light -U 5 
# Helligkeit senken 
bindsym XF86MonBrightnessUp exec light -A 5 

# 
# Audio mit PulseAudio 
# 

# Lautstärke erhöhen 
bindsym XF86AudioRaiseVolume exec pactl set-sink-volume @DEFAULT_SINK@ +5% 
# Lautsträrke senken 
bindsym XF86AudioLowerVolume exec pactl set-sink-volume @DEFAULT_SINK@ -5% 
# Lautstärke ist 0 
bindsym XF86AudioMute exec pactl set-sink-mute @DEFAULT_SINK@ toggle 

# 
# Mediaplayer 
# 

# mpd kontrollieren mit mpc 
${mpc}

# 
# Basics: 
# 

# Start a terminal 
bindsym $mod+i exec $term ${alacritty-font-size} 
# Kill focused window 
bindsym $mod+Shift+q kill 
# Start your launcher 
bindsym $mod+p exec wofi --show=run --prompt="" --height=15% --width=25% --term=alacritty 

# Drag floating windows by holding down $mod and left mouse button. 
# Resize them with right mouse button + $mod. 
# Despite the name, also works for non-floating windows. 
# Change normal to inverse to use left mouse button for resizing and right 
# mouse button for dragging. floating_modifier $mod normal 

# Reload the configuration file 
bindsym $mod+Shift+c reload 

# Exit sway (logs you out of your Wayland session) 
bindsym $mod+Shift+e exec swaynag -t warning -m 'You pressed the exit shortcut. Do you really want to exit sway? This will end your Wayland session.' -B 'Yes, exit sway' 'swaymsg exit' 

# 
# Moving around: 
# 

# Move your focus around 
bindsym $mod+$left focus left 
bindsym $mod+$down focus down 
bindsym $mod+$up focus up 
bindsym $mod+$right focus right 

# Or use $mod+[up|down|left|right] 
bindsym $mod+Left focus left 
bindsym $mod+Down focus down 
bindsym $mod+Up focus up 
bindsym $mod+Right focus right 

# Move the focused window with the same, but add Shift 
bindsym $mod+Shift+$left move left 
bindsym $mod+Shift+$down move down 
bindsym $mod+Shift+$up move up 
bindsym $mod+Shift+$right move right 

# Ditto, with arrow keys 
bindsym $mod+Shift+Left move left 
bindsym $mod+Shift+Down move down 
bindsym $mod+Shift+Up move up 
bindsym $mod+Shift+Right move right 

# 
# Workspaces: 
# 

# Switch to workspace 
bindsym $mod+1 workspace number 1 
bindsym $mod+2 workspace number 2 
bindsym $mod+3 workspace number 3 
bindsym $mod+4 workspace number 4 
bindsym $mod+5 workspace number 5 
bindsym $mod+6 workspace number 6 
bindsym $mod+7 workspace number 7 
bindsym $mod+8 workspace number 8 
bindsym $mod+9 workspace number 9 
bindsym $mod+0 workspace number 10 

# Move focused container to workspace 
bindsym $mod+Shift+1 move container to workspace number 1 
bindsym $mod+Shift+2 move container to workspace number 2 
bindsym $mod+Shift+3 move container to workspace number 3 
bindsym $mod+Shift+4 move container to workspace number 4 
bindsym $mod+Shift+5 move container to workspace number 5 
bindsym $mod+Shift+6 move container to workspace number 6 
bindsym $mod+Shift+7 move container to workspace number 7 
bindsym $mod+Shift+8 move container to workspace number 8 
bindsym $mod+Shift+9 move container to workspace number 9 
bindsym $mod+Shift+0 move container to workspace number 10 

# Note: workspaces can have any name you want, not just numbers. 
# We just use 1-10 as the default. 

# 
# Layout stuff: 
# 

# You can "split" the current object of your focus with 
# $mod+b or $mod+v, for horizontal and vertical splits 
# respectively. 
bindsym $mod+b splith 
bindsym $mod+v splitv 

# Switch the current container between different layout styles 
bindsym $mod+s layout stacking 
bindsym $mod+w layout tabbed 
bindsym $mod+e layout toggle split 

# Make the current focus fullscreen 
bindsym $mod+f fullscreen 

# Toggle the current focus between tiling and floating mode 
bindsym $mod+Shift+space floating toggle 

# Swap focus between the tiling area and the floating area 
bindsym $mod+space focus mode_toggle 

# Move focus to the parent container 
bindsym $mod+a focus parent 

# 
# Scratchpad: 
# 

# Sway has a "scratchpad", which is a bag of holding for windows. 
# You can send windows there and get them back later. 
# Move the currently focused window to the scratchpad 
bindsym $mod+Shift+minus move scratchpad 

# Show the next scratchpad window or hide the focused scratchpad window. 
# If there are multiple scratchpad windows, this command cycles through them. 
bindsym $mod+minus scratchpad show 

# 
# Resizing containers: 
# 

mode "resize" { 
  # left will shrink the containers width 
  # right will grow the containers width 
  # up will shrink the containers height 
  # down will grow the containers height 
  bindsym $left resize shrink width 10px 
  bindsym $down resize grow height 10px 
  bindsym $up resize shrink height 10px 
  bindsym $right resize grow width 10px 

  # Ditto, with arrow keys 
  bindsym Left resize shrink width 10px 
  bindsym Down resize grow height 10px 
  bindsym Up resize shrink height 10px 
  bindsym Right resize grow width 10px 

  # Return to default mode 
  bindsym Return mode "default" 
  bindsym Escape mode "default" 
  } 
bindsym $mod+r mode "resize" 

# 
# Status Bar: 
# 

# Read `man 5 sway-bar` for more information about this section. 
bar { 
  swaybar_command waybar 
} 

# Colors 
# class                 border  background  text    indicator child_border 
client.background       n/a     #ffffff     n/a     n/a       n/a 
client.focused          #c678dd #202335     #c678dd #c678dd   #c678dd 
client.focused_inactive #333333 #5f676a     #ffffff #484e50   #5f676a 
client.unfocused        #282c34 #222222     #888888 #292d2e   #222222 
client.urgent           #2f343a #900000     #ffffff #900000   #900000 
client.placeholder      #000000 #0c0c0c     #ffffff #000000   #0c0c0c 

include /etc/sway/config.d/*

# viele programme brauchen ewig zum starten, damit wird dies gelöst 
# und nicht vergessen: export GTK_USE_PORTAL=0 
exec dbus-update-activation-environment --systemd DISPLAY WAYLAND_DISPLAY SWAYSOCK 
exec swaync -s /home/snd/.config/swaync/style.css -c /home/snd/.config/swaync/config.json 
exec systemctl --user import-environment
  '';
}
