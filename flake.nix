{
  description = "A fork of LLDB, for use with the Zig self-hosted backends";

  inputs = {
    nixpkgs.url = "nixpkgs";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = {
    self,
    nixpkgs,
    flake-utils,
  }:
    {
      overlay = final: prev: {
        # The full, non-renamed package
        lldb-zig-full = final.callPackage ./package.nix {};
        # A trimmed down package with the binaries renamed to lldb-zig and lldb-zig-server
        lldb-zig = final.stdenvNoCC.mkDerivation {
          name = "lldb-zig";
          meta = {
            description = "A fork of LLDB, for use with the Zig self-hosted backends";
            mainCommand = "lldb-zig";
          };
          src = final.lldb-zig-full;
          buildCommand = ''
            install -m755 -D "$src/bin/lldb" "$out/bin/lldb-zig"
            install -m755 -D "$src/bin/lldb-server" "$out/bin/lldb-zig-server"
            install -m644 -Dt "$out/lib" "$src/lib/liblldb.so"*
          '';
        };
      };
    }
    // flake-utils.lib.eachDefaultSystem (system: let
      pkgs = import nixpkgs {inherit system;};
    in {
      packages =
        {default = self.packages.${system}.lldb-zig;}
        // self.overlay pkgs pkgs;
    });
}
