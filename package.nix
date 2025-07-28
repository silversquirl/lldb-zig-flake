# The full, non-renamed package
{
  lib,
  fetchFromGitHub,
  stdenv,
  cmake,
  ninja,
  zlib,
  python313,
  python313Packages,
  libedit,
  swig,
  enableAssertions ? true,
  enableLibedit ? true,
  enablePython ? true,
}:
stdenv.mkDerivation {
  name = "lldb-zig-full";
  meta = {
    description = "A fork of LLDB, for use with the Zig self-hosted backends";
  };

  src = fetchFromGitHub {
    owner = "jacobly0";
    repo = "llvm-project";
    rev = "d2c9e33092f979a2f748cef772728ad1bd45075d"; # branch lldb-zig
    hash = "sha256-J0JUZBLrZmiJ6hidLxXS0gkelqINXrHrufoOMCn/H4U=";
  };

  nativeBuildInputs = [
    cmake
    ninja
    python313
    python313Packages.pyyaml
  ];
  buildInputs =
    [zlib]
    ++ lib.optional enableLibedit libedit
    ++ lib.optionals enablePython [python313 swig];

  cmakeBuildType = "RelWithDebInfo";
  cmakeDir = "../llvm";
  cmakeFlags = [
    (lib.cmakeFeature "LLVM_ENABLE_PROJECTS" "clang;lldb")
    (lib.cmakeBool "LLVM_ENABLE_ASSERTIONS" true)
    (lib.cmakeBool "LLDB_ENABLE_LIBEDIT" enableLibedit)
    (lib.cmakeBool "LLDB_ENABLE_PYTHON" enableAssertions)
  ];

  ninjaFlags = ["lldb" "lldb-server"];
}
