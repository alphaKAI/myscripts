import std.parallelism,
       std.process,
       std.stdio,
       std.file;

void main() {
  string build_dub = "dub build --build=release";
  string[string] commands = [
    "amv" : build_dub,
    "cxz" : build_dub,
    "doco" : build_dub,
    "dww" : build_dub,
    "hexr" : build_dub,
    "streamFilter" : build_dub,
    "xxz" : build_dub,
    "ctwi" : build_dub,
    "ctl" : build_dub,
    "dbk" : build_dub,
  ];

  auto base_dir = getcwd;

  foreach (name; commands.keys.parallel) {
    string build_cmd = commands[name]; 
    writeln("[BUILD] ", name, " [CMD: ", build_cmd, "]");
    name.chdir;
    executeShell(build_cmd);
    base_dir.chdir;
    writeln("[BUILD] ", name, " [FINISHED]");
  }
}
