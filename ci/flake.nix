# Another nix flake, that overrides some stuff in flake.nix for CI purposes
{
  inputs = {
    lldb-zig.url = "path:..";
  };

  outputs = inputs: let
    nixpkgs = inputs.lldb-zig.inputs.nixpkgs;
    forSystems = nixpkgs.lib.genAttrs (builtins.attrNames inputs.lldb-zig.packages);
  in {
    packages = forSystems (system: let
      pkgs = import inputs.lldb-zig.inputs.nixpkgs {inherit system;};
      packages = inputs.lldb-zig.packages.${system};
    in rec {
      ninja = pkgs.ninja.overrideAttrs (prev: {
        version = "0.13.0-memory-limit-git";
        src = pkgs.fetchFromGitHub {
          owner = "ninja-build";
          repo = "ninja";
          rev = "267d85b8bedd3fb6dc1f131aa91a88a2d810da65"; # pull/2605
          hash = "sha256-RkSz28hlCAaa1N2FDM0ziOWYse7OZmvnaHS1GpGSyTs=";
        };
        patches = [];
      });

      lldb-zig-full = (packages.lldb-zig-full.override {inherit ninja;}).overrideAttrs (prev: {
        ninjaFlags = prev.ninjaFlags ++ ["--keep-free-memory" "2G"];
      });
      lldb-zig = packages.lldb-zig.override {inherit lldb-zig-full;};
    });
  };
}
