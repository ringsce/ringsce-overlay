import std.file;
import std.datetime;
import std.concurrency;
import std.getopt;

import updater;
import pk3_manager;
import interpreter;
import xml_parser;

string pk3Filename = "system.pk3";

void saveSettings() {
    // Assume vmSettings is a struct or class containing the VM settings
    // Example:
    // struct VMSettings {
    //     string playerName;
    //     int difficultyLevel;
    //     // Add other settings as needed
    // }
    VMSettings vmSettings;

    // Fill in the VM settings (dummy data for demonstration)
    vmSettings.playerName = "Player1";
    vmSettings.difficultyLevel = 2;

    // Write the settings to a file
    string fileName = "progs.dat";
    try {
        auto file = File(fileName, "wb");
        // Serialize the VM settings and write to the file
        file.write(vmSettings); // Assuming VMSettings is serializable
        file.close();
        writeln("Settings saved to ", fileName);
    } catch (Exception e) {
        writeln("Error saving settings:", e.msg);
    }
}

void printHelp() {
    writeln("Usage: main [options]");
    writeln("Options:");
    writeln("  --version, -v      Display version information");
    writeln("  --help             Display this help message");
}

void main(string[] args) @safe {
    bool verbose = false;
    bool showVersion = false;

    getopt(args, 
           "version|v", () => showVersion = true,
           "help", () => { printHelp(); return 0; });

    if (showVersion) {
        writeln("Version 1.0");
        return;
    }

    writeln("Starting GitHub repository updater...");

    cloneRepository();
    generatePk3(pk3Filename, cloneDir);

    // Assuming parseXmlComments is a safe function
    parseXmlComments("../ui/ui.xml");

    while (true) {
        updateRepository();
        generatePk3(pk3Filename, cloneDir);
        writeln("Waiting for ", to!string(updateInterval.total!"seconds"), " seconds before the next check...");
        Thread.sleep(updateInterval);

        // Interpreter runnable 
        Interpreter interpreter = new Interpreter();
        interpreter.loadScript("path/to/script");
        if (verbose) {
            writeln(interpreter.run());
        }

        // After generating system.pk3, save the settings
        saveSettings();
    }
}
