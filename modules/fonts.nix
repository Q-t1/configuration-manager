{ pkgs, ... }:
{
  fonts.packages = with pkgs; [
    geist-font
    jetbrains-mono
  ];
}
