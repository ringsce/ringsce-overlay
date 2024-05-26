#include <QCoreApplication>
#include <QDebug>
#include "interpreter.h"

/**
 * @brief Main function demonstrating the usage of the Interpreter class.
 * @param argc Argument count.
 * @param argv Argument values.
 * @return Application exit status.
 */
int main(int argc, char *argv[]) {
    QCoreApplication app(argc, argv);

    Interpreter interpreter;

    // Load and run a simple Pascal script
    QString scriptPath = "example.pas";  // Adjust the path to your Pascal script
    if (interpreter.loadScript(scriptPath)) {
        qDebug() << "Script output:" << interpreter.run();
    }

    // Load and parse an XML content
    QString xmlContent = R"(
        <root>
            <message>Hello, XML!</message>
        </root>
    )";
    if (interpreter.loadXML(xmlContent)) {
        qDebug() << "XML value for 'message':" << interpreter.getXMLValue("message");
    }

    // Train the AI with additional code snippets
    std::vector<QString> trainingData = {
        "procedure printNumber(x: integer);\nbegin\n  writeln(x);\nend;",
        "if x > 10 then\n  writeln('x is greater than 10');\nelse\n  writeln('x is 10 or less');"
    };
    interpreter.trainAI(trainingData);

    // Get a suggestion for a partial code
    QString partialCode = "begin\n  writeln('Hello";
    qDebug() << "Suggestion for partial code:" << interpreter.suggestCompletion(partialCode);

    // Get a suggestion for a keyword
    QString partialKeyword = "be";
    qDebug() << "Suggestion for keyword:" << interpreter.suggestCompletion(partialKeyword);

    return app.exec();
}
