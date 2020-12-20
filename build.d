import std.process,
       std.format,
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
    "sizer": build_dub,
  ];

  import core.thread;
  auto tg = new ThreadGroup();

  foreach (name; commands.keys) {
    string build_cmd = "cd %s; %s".format(name, commands[name]);

    tg.create(((string name, string build_cmd) => () {
      writeln("[BUILD] ", name, " [CMD: ", build_cmd, "]");
      executeShell(build_cmd);
      writeln("[BUILD] ", name, " [FINISHED]");
    })(name, build_cmd));
  }
}
