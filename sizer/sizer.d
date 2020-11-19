import std.stdio;
import std.file;
import std.parallelism;
import std.algorithm;
import std.process;
import std.format;
import std.string;
import std.conv;
import std.typecons;
import core.sync.mutex;

void main(string[] args) {
  string target =
    args.length == 2 ? args[1]
                     : getcwd;
  alias NameSize = Tuple!(string, size_t);
  NameSize[] entries;
  size_t total;

  Mutex mtx = new Mutex;

  foreach (entry; parallel(dirEntries(target, SpanMode.shallow), 1)) {
  //foreach (entry; dirEntries(target, SpanMode.shallow)) {
    string name = entry.name;
    auto cmd = executeShell("du -sm \"%s\"".format(name));
    if (cmd.status != 0) {
      writefln("Failed to execute cmd with - %s", name);
    } else {
      size_t e_size = cmd.output.split[0].to!size_t;
      synchronized (mtx) {
        entries ~= tuple(name, e_size);
        total += e_size;
      }
    }
  }

  writeln("total: ", total, "MB");
  entries.sort!"a[1]<b[1]";
  foreach (elem; entries) {
    writefln("%d - %s", elem[1], elem[0]);
  }
}
