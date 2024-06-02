// vm.d
import std.stdio;
import std.zip;

import pk3_manager;
import xml_reader;

void main() {
    string pk3Filename = "system.pk3";
    string sourceDirectory = "scripts";

    auto archive = new ZipArchive;

    if (exists(sourceDirectory)) {
        processFiles(sourceDirectory, archive);
    } else {
        writeln("Source directory ", sourceDirectory, " does not exist.");
    }

    parseXmlComments("path/to/your/xmlfile.xml");

    archive.write(pk3Filename);
    writeln(pk3Filename, " generated successfully.");
}
