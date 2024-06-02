module kaytec.HTMLParser;

import std.stdio;
import std.array;
import std.exception;
import std.experimental.allocator;
import std.experimental.allocator.mallocator;
import std.experimental.allocator.building_blocks.region;
import std.experimental.allocator.gc_allocator;
import std.experimental.allocator.gc_allocator_helpers;
import std.experimental.allocator.utils;

import html5;

class HTMLParser {
public:
    void parse(string html) {
        writeln("Parsing HTML (D version): ", html);
        
        // Create an allocator for the HTML document
        auto region = Region!(Mallocator.instance)();
        //multiple argumennts
        //auto allocator = makeAllocator!(GCAllocator, RegionAllocator)!RegionAllocator(region);

        // Parse the HTML document
        try {
            auto document = parseDocument(html, allocator);
            writeln("HTML parsed successfully.");
            
            // Traverse the document and process tags
            processNode(document.firstChild, 0);
        } catch (Exception e) {
            writeln("Error parsing HTML:", e.msg);
        }
    }

private:
    void processNode(ElementNode node, size_t depth) {
        if (node is null)
            return;
        
        // Print node name with indentation
        writeln(" ".repeat(depth * 2), "<", node.tagName, ">");
        
        // Process child nodes recursively
        foreach (child; node.children)
            processNode(cast(ElementNode)child, depth + 1);
        
        // Print closing tag
        writeln(" ".repeat(depth * 2), "</", node.tagName, ">");
    }
}
