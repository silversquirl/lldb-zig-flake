# A trimmed down package with the binaries renamed to lldb-zig and lldb-zig-server
{
  stdenvNoCC,
  lldb-zig-full,
}:
stdenvNoCC.mkDerivation {
  name = "lldb-zig";
  meta = {
    description = "A fork of LLDB, for use with the Zig self-hosted backends";
    mainCommand = "lldb-zig";
  };
  src = lldb-zig-full;
  buildCommand = ''
    install -m755 -D "$src/bin/lldb" "$out/bin/lldb-zig"
    install -m755 -D "$src/bin/lldb-server" "$out/bin/lldb-zig-server"
    install -m644 -Dt "$out/lib" "$src/lib/liblldb.so"*
  '';
}
