// main.d
import std.stdio;
import std.datetime;
import std.concurrency;

import updater;
import pk3_manager;
import xml_reader;

string pk3Filename = "system.pk3";

void main() {
    writeln("Starting GitHub repository updater...");

    cloneRepository();
    generatePk3(pk3Filename, cloneDir);

    parseXmlComments("./ui/ui.xml");

    while (true) {
        updateRepository();
        generatePk3(pk3Filename, cloneDir);
        writeln("Waiting for ", to!string(updateInterval.total!"seconds"), " seconds before the next check...");
        Thread.sleep(updateInterval);
    }
}
