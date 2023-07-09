{  config, lib, ... }:
let 
  c = config.theme.colours;
  gui = config.setup.gui.enable;
  removeFirstSymbol = str: lib.replaceStrings ["#"] [""] str;
in
{

  # TODO
  console.colors = lib.mkIf gui [
    "${ removeFirstSymbol c.bg}"
    "${ removeFirstSymbol c.red}"
    "${ removeFirstSymbol c.green}"
    "${ removeFirstSymbol c.yellow}"
    "${ removeFirstSymbol c.blue}"
    "${ removeFirstSymbol c.pink}"
    "${ removeFirstSymbol c.cyan}"
    "${ removeFirstSymbol c.subtext1}"
    "${ removeFirstSymbol c.surface2}"
    "${ removeFirstSymbol c.red}"
    "${ removeFirstSymbol c.green}"
    "${ removeFirstSymbol c.yellow}"
    "${ removeFirstSymbol c.blue}"
    "${ removeFirstSymbol c.pink}"
    "${ removeFirstSymbol c.cyan}"
    "${ removeFirstSymbol c.subtext1}"
    "${ removeFirstSymbol c.subtext0}"
  ];

}
