;==========================================================
;
;
;   ██████╗  ██████╗ ██╗  ██╗   ██╗██████╗  █████╗ ██████╗
;   ██╔══██╗██╔═══██╗██║  ╚██╗ ██╔╝██╔══██╗██╔══██╗██╔══██╗
;   ██████╔╝██║   ██║██║   ╚████╔╝ ██████╔╝███████║██████╔╝
;   ██╔═══╝ ██║   ██║██║    ╚██╔╝  ██╔══██╗██╔══██║██╔══██╗
;   ██║     ╚██████╔╝███████╗██║   ██████╔╝██║  ██║██║  ██║
;   ╚═╝      ╚═════╝ ╚══════╝╚═╝   ╚═════╝ ╚═╝  ╚═╝╚═╝  ╚═╝
;
;
;   To learn more about how to configure Polybar
;   go to https://github.com/polybar/polybar
;
;   The README contains a lot of information
;
;==========================================================

[colors]
background = #202335
background-alt = #373B41
foreground = #C5C8C6
primary = #c678dd
secondary = #8ABEB7
alert = #e06c75
disabled = #707880

[bar/left]
monitor = HDMI-A-0
width = 100%
height = 30pt
radius = 0

dpi = 96

background = ${colors.background}
foreground = ${colors.foreground}

line-size = 0pt

border-size = 0pt
border-color = #00000000

padding-left = 0
padding-right = 1

module-margin = 1

separator = |
separator-foreground = ${colors.disabled}

font-0 = Hack Nerd Font:size=14;2

modules-left = xworkspaces xwindow
modules-right = pulseaudio xkeyboard memory cpu wlan eth battery date

cursor-click = pointer
cursor-scroll = ns-resize

enable-ipc = true

; tray-position = right

; wm-restack = generic
; wm-restack = bspwm
; wm-restack = i3

; override-redirect = true

[bar/right]
monitor = DisplayPort-0
width = 100%
height = 30pt
radius = 0

dpi = 96

background = ${colors.background}
foreground = ${colors.foreground}

line-size = 0pt

border-size = 0pt
border-color = #00000000

padding-left = 0
padding-right = 1

module-margin = 1

separator = |
separator-foreground = ${colors.disabled}

font-0 = Hack Nerd Font:size=14;2

modules-left = xworkspaces xwindow
modules-right = pulseaudio xkeyboard memory cpu wlan eth battery date

cursor-click = pointer
cursor-scroll = ns-resize

enable-ipc = true

; tray-position = right

; wm-restack = generic
; wm-restack = bspwm
; wm-restack = i3

; override-redirect = true

[module/xworkspaces]
type = internal/xworkspaces

label-active = %name%
label-active-background = ${colors.background-alt}
label-active-underline= ${colors.primary}
label-active-padding = 1

label-occupied = %name%
label-occupied-padding = 1

label-urgent = %name%
label-urgent-background = ${colors.alert}
label-urgent-padding = 1

label-empty = %name%
label-empty-foreground = ${colors.disabled}
label-empty-padding = 1

[module/xwindow]
type = internal/xwindow
label = %title:0:60:...%

[module/filesystem]
type = internal/fs
interval = 25

mount-0 = /

label-mounted = %{F#c678dd}%mountpoint%%{F-} %percentage_used%%

label-unmounted = %mountpoint% not mounted
label-unmounted-foreground = ${colors.disabled}

[module/pulseaudio]
type = internal/pulseaudio

format-volume-prefix = "VOL "
format-volume-prefix-foreground = ${colors.primary}
format-volume = <label-volume>

label-volume = %percentage%%

label-muted = muted
label-muted-foreground = ${colors.disabled}

[module/xkeyboard]
type = internal/xkeyboard
blacklist-0 = num lock

label-layout = %layout%
label-layout-foreground = ${colors.primary}

label-indicator-padding = 2
label-indicator-margin = 1
label-indicator-foreground = ${colors.background}
label-indicator-background = ${colors.secondary}

[module/memory]
type = internal/memory
interval = 2
format-prefix = "RAM "
format-prefix-foreground = ${colors.primary}
label = %percentage_used:2%%

[module/cpu]
type = internal/cpu
interval = 2
format-prefix = "CPU "
format-prefix-foreground = ${colors.primary}
label = %percentage:2%%

[network-base]
type = internal/network
interval = 5
format-connected = <label-connected>
format-disconnected = <label-disconnected>
label-disconnected = %{F#c678dd}%ifname%%{F#707880} disconnected

[module/wlan]
inherit = network-base
interface-type = wireless
label-connected = %{F#c678dd}%ifname%%{F-} %essid% %local_ip%

[module/eth]
inherit = network-base
interface-type = wired
label-connected = %{F#c678dd}%ifname%%{F-} %local_ip%

[module/date]
type = internal/date
interval = 1

date = %H:%M
date-alt = %Y-%m-%d %H:%M:%S

label = %date%
label-foreground = ${colors.primary}

[module/battery]
type = internal/battery

; This is useful in case the battery never reports 100% charge
; Default: 100
full-at = 80

; format-low once this charge percentage is reached
; Default: 10
; New in version 3.6.0
low-at = 20

; Use the following command to list batteries and adapters:
; $ ls -1 /sys/class/power_supply/
battery = BAT0
adapter = ADP1

; If an inotify event haven't been reported in this many
; seconds, manually poll for new values.
;
; Needed as a fallback for systems that don't report events
; on sysfs/procfs.
;
; Disable polling by setting the interval to 0.
;
; Default: 5
poll-interval = 5

; Available tags:
;   <label-charging> (default)
;   <bar-capacity>
;   <ramp-capacity>
;   <animation-charging>
;format-charging = <animation-charging> <label-charging>

; Available tags:
;   <label-discharging> (default)
;   <bar-capacity>
;   <ramp-capacity>
;   <animation-discharging>
;format-discharging = <ramp-capacity> <label-discharging>

; Available tags:
;   <label-full> (default)
;   <bar-capacity>
;   <ramp-capacity>
;format-full = <ramp-capacity> <label-full>

; Format used when battery level drops to low-at
; If not defined, format-discharging is used instead.
; Available tags:
;   <label-low>
;   <animation-low>
;   <bar-capacity>
;   <ramp-capacity>
; New in version 3.6.0
;format-low = <label-low> <animation-low>

; Available tokens:
;   %percentage% (default) - is set to 100 if full-at is reached
;   %percentage_raw%
;   %time%
;   %consumption% (shows current charge rate in watts)
label-charging = %{F#c678dd}Charging %{F#c5c8c6}%percentage%%

; Available tokens:
;   %percentage% (default) - is set to 100 if full-at is reached
;   %percentage_raw%
;   %time%
;   %consumption% (shows current discharge rate in watts)
label-discharging = %{F#c678dd}Discharging %{F#c5c8c6}%percentage%%

; Available tokens:
;   %percentage% (default) - is set to 100 if full-at is reached
;   %percentage_raw%
;label-full = Fully charged

; Available tokens:
;   %percentage% (default) - is set to 100 if full-at is reached
;   %percentage_raw%
;   %time%
;   %consumption% (shows current discharge rate in watts)
; New in version 3.6.0
;label-low = BATTERY LOW

; Only applies if <ramp-capacity> is used
ramp-capacity-0 = 
ramp-capacity-1 = 
ramp-capacity-2 = 
ramp-capacity-3 = 
ramp-capacity-4 = 

; Only applies if <bar-capacity> is used
bar-capacity-width = 10

; Only applies if <animation-charging> is used
animation-charging-0 = 
animation-charging-1 = 
animation-charging-2 = 
animation-charging-3 = 
animation-charging-4 = 
; Framerate in milliseconds
animation-charging-framerate = 750

; Only applies if <animation-discharging> is used
animation-discharging-0 = 
animation-discharging-1 = 
animation-discharging-2 = 
animation-discharging-3 = 
animation-discharging-4 = 
; Framerate in milliseconds
animation-discharging-framerate = 500

; Only applies if <animation-low> is used
; New in version 3.6.0
animation-low-0 = !
animation-low-1 = 
animation-low-framerate = 200

[settings]
screenchange-reload = true
pseudo-transparency = true

; vim:ft=dosini  
