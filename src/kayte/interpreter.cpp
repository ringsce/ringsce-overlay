#include <iostream>
#include <fstream>
#include <vector>
#include <string>
#include <zlib.h>
#include <zip.h>
#include <QFile>
#include <QTextStream>
#include <QDebug>
#include <algorithm>

#include "interpreter.h"

Interpreter::Interpreter(QObject *parent)
    : QObject(parent) {
    initializeAI();
    initializeKeywords();
}

Interpreter::~Interpreter() {
}



bool Interpreter::loadScript(const QString &scriptPath) {
    QFile file(scriptPath);
    if (!file.open(QIODevice::ReadOnly | QIODevice::Text)) {
        qWarning() << "Could not open script file:" << scriptPath;
        return false;
    }

    QTextStream in(&file);
    script = in.readAll();
    file.close();
    return true;
}

QString Interpreter::run() {
    if (script.isEmpty()) {
        return "No script loaded.";
    }

    // Translate Pascal code to bytecode
    QString bytecode = translateToBytecode(script);

    // Interpret the bytecode using the virtual machine
    QString result = interpretBytecode(bytecode);

     HTMLParser htmlParser;
    CSSParser cssParser;

    // Sample HTML and CSS strings
    std::string html = "<html><head><title>Test</title></head><body><h1>Hello, World!</h1></body></html>";
    std::string css = "body { background-color: lightblue; } h1 { color: navy; }";

    htmlParser.parse(html);
    cssParser.parse(css);

    std::cout << "HTML and CSS parsing completed." << std::endl;

    return result;
}


bool Interpreter::loadXML(const QString &xmlContent) {
    QString errorMsg;
    int errorLine, errorColumn;

    if (!xmlDoc.setContent(xmlContent, &errorMsg, &errorLine, &errorColumn)) {
        qWarning() << "XML Parse Error:" << errorMsg << "at line" << errorLine << "column" << errorColumn;
        return false;
    }
    return true;
}

QString Interpreter::getXMLValue(const QString &tagName) {
    QDomElement root = xmlDoc.documentElement();
    QDomNodeList elements = root.elementsByTagName(tagName);

    if (elements.isEmpty()) {
        return QString();
    }

    QDomElement element = elements.at(0).toElement();
    return element.text();
}

void Interpreter::initializeAI() {
    codeSnippets = {
        "begin\n  writeln('Hello, world!');\nend.",
        "var x: integer;\nbegin\n  x := 42;\n  writeln(x);\nend.",
        "function add(a, b: integer): integer;\nbegin\n  add := a + b;\nend;"
    };
}

void Interpreter::initializeKeywords() {
    pascalKeywords = {
        "mod", "begin", "end", "break", "asm", "case", "const", "destructor", "array", "constructor", "Procedure", "word", "float", "double",
        "div", "do", "downto", "else", "if", "for", "goto", "for", "function", "implementation", "nil", "interface", "not", "in",
        "of", "on"
    };
}

void Interpreter::trainAI(const std::vector<QString> &trainingData) {
    for (const auto &snippet : trainingData) {
        codeSnippets.push_back(snippet);
    }
}

QString Interpreter::suggestCompletion(const QString &partialCode) {
    for (const auto &snippet : codeSnippets) {
        if (snippet.startsWith(partialCode)) {
            return snippet.mid(partialCode.length());
        }
    }

    for (const auto &keyword : pascalKeywords) {
        if (keyword.startsWith(partialCode.trimmed(), Qt::CaseInsensitive)) {
            return keyword.mid(partialCode.trimmed().length());
        }
    }

    return "No suggestion available.";
}

QString Interpreter::translateToBytecode(const QString &pascalCode) {
    QString bytecode;

    QTextStream stream(&bytecode);

    // Split Pascal code into lines
    QStringList lines = pascalCode.split("\n",Qt::SkipEmptyParts);

    // Translate each line to bytecode
    for (const QString &line : lines) {
        QStringList tokens = line.trimmed().split(QRegExp("\\s+"), Qt::SkipEmptyParts);

        // Handle different Pascal constructs
        if (tokens.isEmpty()) {
            // Empty line, skip
            continue;
        } else if (tokens[0] == "begin") {
            stream << "BEGIN\n";
        } else if (tokens[0] == "end.") {
            stream << "END\n";
        } else if (tokens[0] == "writeln") {
            // Assume writeln only takes one argument for simplicity
            if (tokens.size() < 2 || !tokens[1].startsWith("'") || !tokens[1].endsWith("'")) {
                qWarning() << "Invalid writeln statement:" << line;
                continue;
            }
            QString value = tokens[1].mid(1, tokens[1].size() - 2); // Remove quotes
            stream << "WRITELN " << value << "\n";
        } else if (tokens[0] == "pk3_read") {
            // Assume pk3_read only takes one argument which is the path to the pk3 file
            if (tokens.size() < 2 || !tokens[1].startsWith("'") || !tokens[1].endsWith("'")) {
                qWarning() << "Invalid pk3_read statement:" << line;
                continue;
            }
            QString pk3Path = tokens[1].mid(1, tokens[1].size() - 2); // Remove quotes
            stream << "PK3_READ " << pk3Path << "\n";
        } else {
            // Unknown statement, ignore for now
            qWarning() << "Unknown statement:" << line;
        }
    }

    return bytecode;
}

QString Interpreter::
