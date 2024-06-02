// pk3_manager.d
import std.stdio;
import std.file;
import std.zip;

void generatePk3(string pk3Filename, string sourceDir) @safe{
    auto archive = new ZipArchive;

    string[] folders = ["sounds", "assets", "objects", "scripts"];
    foreach (folder; folders) {
        string folderPath = sourceDir ~ "/" ~ folder;
        if (exists(folderPath)) {
            processFiles(folderPath, archive);
        } else {
            writeln("Folder ", folderPath, " does not exist.");
        }
    }

    archive.write(pk3Filename);
    writeln(pk3Filename, " generated successfully.");
}

void processFiles(string folder, ZipArchive archive) {
    foreach (entry; dirEntries(folder, SpanMode.depth)) {
        if (entry.isFile) {
            string relativePath = entry.name.replace(folder ~ "/", "");
            auto fileContent = read(entry.name);
            archive.addFile(relativePath, fileContent);
        }
    }
}
