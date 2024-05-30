#ifndef KAYTE_CSSPARSER_H
#define KAYTE_CSSPARSER_H

#include <string>

namespace kayte {
    class CSSParser {
    public:
        void parse(const std::string& css);
    };
}

#endif // KAYTE_CSSPARSER_H
