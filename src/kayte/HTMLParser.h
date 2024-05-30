#ifndef KAYTE_HTMLPARSER_H
#define KAYTE_HTMLPARSER_H

#include <string>

namespace kayte {
    class HTMLParser {
    public:
        void parse(const std::string& html);
    };
}

#endif // KAYTE_HTMLPARSER_H
