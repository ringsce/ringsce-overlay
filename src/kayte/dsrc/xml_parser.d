// xml_reader.d
import std.stdio;
import std.file;
import dxml.document;

void parseXmlComments(string xmlFilePath) {
    // Read the content of the XML file
    string xmlContent = readText(xmlFilePath);

    // Parse the content into a Document
    auto document = parseDocument!(true)(xmlContent);

    writeln("XML Comments found:");
    parseNodeForComments(document.root);
}

void parseNodeForComments(Node node) {
    // Check if the node itself is a comment
    if (node.type == NodeType.comment) {
        writeln(node.text);
    }

    // Recursively check child nodes for comments
    foreach (child; node.children) {
        parseNodeForComments(child);
    }
}
