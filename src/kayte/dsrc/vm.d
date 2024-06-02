// vm.d

import std.stdio;
import std.file;

void main() @safe {
    string pk3Filename = "system.pk3";
    string sourceDirectory = "scripts";

    auto archive = new ZipArchive;

    if (exists(sourceDirectory)) {
        processFiles(sourceDirectory, archive);
    } else {
        writeln("Source directory ", sourceDirectory, " does not exist.");
    }

    // For simplicity, let's assume parseXmlComments is a safe function
    parseXmlComments("path/to/your/xmlfile.xml");

    // For simplicity, let's assume writing to file is safe
    archive.write(pk3Filename);
    writeln(pk3Filename, " generated successfully.");
}
