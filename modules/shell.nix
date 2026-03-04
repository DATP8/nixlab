{ pkgs, ... }:
{
  programs.starship = {
    enable = true;
  };

  environment.sessionVariables = rec {
    EDITOR = "nvim";
    # Setting this directly may introduce issues with some programs, but hopefully that is not relevant.
    # LD_LIBRARY_PATH = "${pkgs.stdenv.cc.cc.lib}/lib";
    LD_LIBRARY_PATH = pkgs.lib.makeLibraryPath [
      pkgs.cudaPackages.cuda_cudart
      pkgs.cudaPackages.cuda_nvrtc
      pkgs.cudaPackages.cudnn
      # pkgs.cudaPackages.cublas
      pkgs.cudaPackages.cuda_cccl
      # pkgs.cudaPackages.cuda_runtime
      pkgs.stdenv.cc.cc.lib
    ];
    CUDA_PATH = "${pkgs.cudaPackages.cudatoolkit}";
    CUDA_HOME = "${pkgs.cudaPackages.cudatoolkit}";
  };
}
