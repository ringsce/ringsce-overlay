import std.stdio;
import std.xml;
import std.file;

void parseXmlComments(string xmlFilePath) {
    // Read the content of the XML file
    string xmlContent = readText(xmlFilePath);

    // Parse the content into an XmlDocument
    XmlDocument document;
    try {
        document = parseString(xmlContent);
    } catch (Exception e) {
        writeln("Failed to parse XML file: ", e.msg);
        return;
    }

    writeln("XML Comments found:");
    parseNodeForComments(document.root);
}

void parseNodeForComments(XmlNode node) {
    // Check if the node itself is a comment
    if (node.type == XmlNodeType.comment) {
        writeln(node.text);
    }

    // Recursively check child nodes for comments
    foreach (child; node.children) {
        parseNodeForComments(child);
    }
}

void main() {
    string xmlFilePath = "path/to/your/xmlfile.xml";
    parseXmlComments(xmlFilePath);
}
