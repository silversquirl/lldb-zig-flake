# The full, non-renamed package
{
  lib,
  fetchFromGitHub,
  mkLLVMPackages,
  enableAssertions ? true,
  monorepoSrc ?
    fetchFromGitHub {
      owner = "jacobly0";
      repo = "llvm-project";
      rev = "d2c9e33092f979a2f748cef772728ad1bd45075d"; # branch lldb-zig
      hash = "sha256-J0JUZBLrZmiJ6hidLxXS0gkelqINXrHrufoOMCn/H4U=";
    },
  llvmVersion ? "21.1.0-lldb-zig",
}: let
  llvmPackages =
    (mkLLVMPackages {
      version = llvmVersion;
      gitRelease = {rev-version = llvmVersion;};
      inherit monorepoSrc;
    }).value;
in
  llvmPackages.lldb.override {
    devExtraCmakeFlags = [(lib.cmakeBool "LLVM_ENABLE_ASSERTIONS" enableAssertions)];
  }
  // {inherit (llvmPackages) libclang libllvm;}
