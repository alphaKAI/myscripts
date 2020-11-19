import std.stdio;
import std.format;
import std.process;
import std.path;
import std.file;
import std.json;

class TargetInfo {
    string name;
    string mac;

    this(string name, string mac) {
        this.name = name;
        this.mac = mac;
    }

    void wakeup() {
        string cmd = "wol %s".format(this.mac);
        writeln("Wake up: ", this.name);
        executeShell(cmd);
    }
}

TargetInfo[] readTargetsFromSettingFile() {
    enum setting_file_name = "settings.json";
    enum app_name = "wakeon";

    string setting_file_path;
    {
        enum alphakai_dir = "~/.myscripts/%s".format(app_name);
        enum default_dir = "~/.config/%s".format(app_name);

        string[] setting_file_search_dirs;
        auto xdg_config_home = environment.get("XDG_CONFIG_HOME");
        if (xdg_config_home !is null) {
            setting_file_search_dirs = [
                xdg_config_home ~ "/" ~ app_name, default_dir, alphakai_dir
            ];
        }
        else {
            auto home_dir = environment.get("HOME");
            if (home_dir !is null) {
                setting_file_search_dirs = [
                    home_dir ~ ".config/%s".format(app_name), default_dir,
                    alphakai_dir
                ];
            }
            else {
                setting_file_search_dirs = [default_dir, alphakai_dir];
            }
        }

        foreach (dir; setting_file_search_dirs) {
            immutable path = expandTilde("%s/%s".format(dir, setting_file_name));
            if (path.exists) {
                setting_file_path = path;
            }
        }

        if (setting_file_path is null) {
            if (!expandTilde(default_dir)) {
                mkdir(expandTilde(default_dir));
            }
            string default_json = `{
        "targets": []
      }`;
            setting_file_path = "%s/%s".format(default_dir, setting_file_name).expandTilde;
            File(setting_file_path, "w").write(default_json);
        }
    }

    TargetInfo[] targets;
    foreach (target; readText(setting_file_path).parseJSON.object["targets"].array) {
        targets ~= new TargetInfo(target.object["name"].str, target.object["mac"].str);
    }

    return targets;
}

void main(string[] args) {
    args = args[1 .. $];
    TargetInfo[] targets = readTargetsFromSettingFile();

    if (!args.length) {
        writeln("Usage: ");
        writeln("   args:");
        writeln("     -l: list targets");
        writeln("     target name : target name");
        return;
    }

    switch (args[0]) {
    case "-l": {
            foreach (target; targets) {
                writefln(" - %s (Mac Address: %s)", target.name, target.mac);
            }
        }
        break;
    default: {
            TargetInfo target;
            foreach (_target; targets) {
                if (_target.name == args[0]) {
                    target = _target;
                    break;
                }
            }
            if (target !is null) {
                target.wakeup;
            }
            else {
                writefln("Error no such a target: %s", args[0]);
            }
        }
        break;
    }
}
