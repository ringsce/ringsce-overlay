module kaytec.CSSParser;

import std.stdio;
import std.array;
import std.exception;
import std.experimental.allocator;
import std.experimental.allocator.mallocator;
import std.experimental.allocator.building_blocks.region;
import std.experimental.allocator.gc_allocator;
import std.experimental.allocator.gc_allocator_helpers;
import std.experimental.allocator.utils;

import css;

class CSSParser {
public:
    void parse(string css) {
        writeln("Parsing CSS (D version): ", css);
        
        // Create an allocator for the CSS document
        auto region = Region!(Mallocator.instance)();
        //multiple arguments
       //auto allocator = makeAllocator!(RegionAllocator, RegionAllocator)!RegionAllocator(region);

        // Parse the CSS document
        try {
            auto document = css.parse(css, allocator);
            writeln("CSS parsed successfully.");
            
            // Traverse the document and process rules
            foreach (rule; document.rules)
                processRule(rule, 0);
        } catch (Exception e) {
            writeln("Error parsing CSS:", e.msg);
        }
    }

private:
    void processRule(Rule rule, size_t depth) {
        if (rule is null)
            return;
        
        // Print rule with indentation
        writeln(" ".repeat(depth * 2), rule.toString());
    }
}
