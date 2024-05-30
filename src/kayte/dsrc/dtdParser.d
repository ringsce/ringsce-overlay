import std.file : readText;
import std.stdio : writeln;
import dxml.parser : parseDocument;
import dxml.entity : DocumentType;
import dxml.util : filterText;

void main() {
    // Read the DTD content from the external file
    string dtdPath = "ui.dtd";
    string dtdContent;
    try {
        dtdContent = readText(dtdPath);
    } catch (Exception e) {
        writeln("Failed to read DTD file: ", e.msg);
        return;
    }

    // Wrap DTD content in a dummy XML document to parse it
    string xmlContent = `<!DOCTYPE UI SYSTEM "ui.dtd"> <UI></UI>`;

    // Parse the XML content
    auto doc = parseDocument!()(
        xmlContent, 
        (ref filterText e) {});

    // Extract and print the DTD information
    DocumentType docType = doc.docType;
    writeln("Root element: ", docType.name);
    writeln("DTD declarations:");
    foreach (decl; docType.declarations) {
        writeln(decl);
    }
}
