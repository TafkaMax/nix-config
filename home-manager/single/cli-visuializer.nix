{ pkgs, lib, ...}:

{
  home.file."cli-visuializer".text = ''
    # use c to switch beetween color themes
    colors.scheme=rainbow,dracula
  '';
  home.file."cli-visuializer".target = ".config/vis/config";
  
  home.file."cli-visuializer-rainbow".text = ''
    #1F80F3
    #08ADD8
    #06B3D4
    #01D7AF
    #01DBA9
    #0DF47E
    #26FE53
    #2CFF4B
    #4FF829
    #58F522
    #83DE0B
    #8FD506
    #ADBB01
    #BEAA01
    #D78C07
    #E27C0D
    #F65525
    #F94C2B
    #FE2A4D
    #FE2456
    #F20B81
    #D901AC
    #D501B2
    #B007D6
    #AA09DA
    #7C21F4
    #6D2DF9
    #5541FE
    #3E58FE
    #2A70F9
  '';
  home.file."cli-visuializer-rainbow".target = ".config/vis/colors/rainbow";
  
  home.file."cli-visuializer-dracula".text = ''
    gradient=true
    #ff79c6
    #bd93f9
    #8be9fd
    #50fa7b
    #ffb86c
    #f1fa8c
    #ff5555 
  '';
  home.file."cli-visuializer-dracula".target = ".config/vis/colors/dracula";
}
