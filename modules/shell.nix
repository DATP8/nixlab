{ pkgs, ... }:
{
  programs.starship = {
    enable = true;
  };

  environment.sessionVariables = rec {
    EDITOR = "nvim";
    # Setting this directly may introduce issues with some programs, but hopefully that is not relevant.
    LD_LIBRARY_PATH = pkgs.lib.makeLibraryPath [
      pkgs.linuxPackages.nvidia_x11
      pkgs.ncurses5
      pkgs.stdenv.cc.cc.lib
    ];
    # TODO: Does this matter? IDK, if issues arise, try changing it
    # CUDA_PATH = "${pkgs.cudaPackages.cudatoolkit}";
    # CUDA_HOME = "${pkgs.cudaPackages.cudatoolkit}";
    CUDA_PATH = "${pkgs.cudatoolkit}";
    CUDA_HOME = "${pkgs.cudatoolkit}";
    EXTRA_LDFLAGS = "-L/lib -L${pkgs.linuxPackages.nvidia_x11}/lib";
    EXTRA_CCFLAGS = "-I/usr/include";
  };
}
