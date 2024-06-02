// vm.d
module kaytec.VM;

import std.stdio;
import std.file;

void processFiles(string directory, ZipArchive archive) {
    foreach (file; dirEntries(directory, SpanMode.depth)) {
        if (isFile(file) && (file.endsWith(".kayte") || file.endsWith(".k"))) {
            string fileName = file.baseName;
            string filePathInArchive = "scripts/" ~ fileName;
            archive.add(filePathInArchive, read(file));
            writeln("Added ", file, " to archive as ", filePathInArchive);
        }
    }
}

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
    parseXmlComments("../ui//ui.xml");

    // For simplicity, let's assume writing to file is safe
    archive.write(pk3Filename);
    writeln(pk3Filename, " generated successfully.");
}
