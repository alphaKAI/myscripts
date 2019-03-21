import std.range,
       std.stdio,
       std.file;

void main(string[] args) {
  args = args[1..$];

  if (!args.length) {
    writeln("usage : ./hexr files...");
  }

  foreach (arg; args) {
    if (!arg.exists) {
      throw new Error("Error : No such file - " ~ arg);
    }

    auto file   = File(arg, "rb");
    ubyte[] buf = new ubyte[file.size];
    file.rawRead(buf);

    char[16]  cbuf;
    ubyte[16] ubuf;
    size_t    cbuf_idx,
              ubuf_idx;

    alias print = (j) {
      writef("%06x0  ", j);

      foreach (k; 16.iota) {
        if (k < cbuf_idx) {
          auto u = ubuf[k];
          writef("%02x ", u);
        } else {
          write("   ");
        }
      }

      write(" |");
      foreach (k; 16.iota) {
        if (k < cbuf_idx) {
          auto c = cbuf[k];
          writef("%c", c);
        }
      } 
      writeln("|");

      cbuf_idx = 0;
      ubuf_idx = 0;
    };

    writeln("Hex dump of " ~ arg ~ ":");

    foreach (i, e; buf) {

      if (i != 0 && i % 16 == 0) {
        ulong j = i / 16 - 1;
        print(j);
      }

      ubuf[ubuf_idx++] = e;
      cbuf[cbuf_idx++] = (e < 32 || 127 < e) ? '.' : cast(char)e;

      if (i == buf.length - 1) {// if this loop will be end with this time and buffers(ubuf, cbuf) aren't empty, print buffers
        print(i / 16);
      }
    }
  }
}
