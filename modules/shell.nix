{ pkgs, ... }:
{
  programs.starship = {
    enable = true;
  };

  environment.sessionVariables = rec {
    EDITOR = "nvim";
    # Setting this directly may introduce issues with some programs, but hopefully that is not relevant.
    LD_LIBRARY_PATH = "${pkgs.stdenv.cc.cc.lib}/lib";
  };
}
