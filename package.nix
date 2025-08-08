# The full, non-renamed package
{
  fetchFromGitHub,
  mkLLVMPackages,
  monorepoSrc ?
    fetchFromGitHub {
      owner = "jacobly0";
      repo = "llvm-project";
      rev = "d2c9e33092f979a2f748cef772728ad1bd45075d"; # branch lldb-zig
      hash = "sha256-J0JUZBLrZmiJ6hidLxXS0gkelqINXrHrufoOMCn/H4U=";
    },
  llvmVersion ? "21.0.0-lldb-zig",
}: let
  llvmPackages =
    (mkLLVMPackages.override {
        # FIXME: this may cause cross-compilation issues
        buildLlvmTools = llvmPackages.tools;
      } {
        version = llvmVersion;
        gitRelease = {rev-version = llvmVersion;};
        inherit monorepoSrc;
      }).value;
in
  llvmPackages
