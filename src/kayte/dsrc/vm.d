import std.stdio;
import std.zip;
import std.file;
import std.exception;

void listPk3Contents(const string pk3Path) {
    try {
        // Open the pk3 (zip) archive
        auto zipArchive = new ZipArchive();
        zipArchive.load(read(pk3Path));

        writeln("PK3 file contains ", zipArchive.entries.length, " files:");

        foreach (entry; zipArchive.entries) {
            writeln(entry.name);
        }
    } catch (Exception e) {
        writeln("Failed to open PK3 file: ", pk3Path);
        writeln("Error: ", e.msg);
    }
}

void main() {
    string pk3Path = "path/to/your/pk3file.pk3";
    listPk3Contents(pk3Path);
}
