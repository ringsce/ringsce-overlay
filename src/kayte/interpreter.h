#ifndef INTERPRETER_H
#define INTERPRETER_H

#include <QObject>
#include <QString>
#include <QDomDocument>
#include <vector>
#include <unordered_set>

/**
 * @brief The Interpreter class provides functionalities to interpret Object Pascal scripts,
 * load and parse XML content, and offer AI-based code suggestions.
 */
class Interpreter : public QObject {
    Q_OBJECT

public:
    /**
     * @brief Constructor for Interpreter.
     * @param parent The parent QObject.
     */
    explicit Interpreter(QObject *parent = nullptr);

    /**
     * @brief Destructor for Interpreter.
     */
    ~Interpreter();

    /**
     * @brief Loads a script from the specified file path.
     * @param scriptPath The file path of the script.
     * @return true if the script is successfully loaded, false otherwise.
     */
    bool loadScript(const QString &scriptPath);

    /**
     * @brief Runs the loaded script.
     * @return The result of running the script.
     */
    QString run();

    /**
     * @brief Loads and parses XML content.
     * @param xmlContent The XML content as a string.
     * @return true if the XML content is successfully parsed, false otherwise.
     */
    bool loadXML(const QString &xmlContent);

    /**
     * @brief Retrieves the value of a specified XML tag.
     * @param tagName The name of the XML tag.
     * @return The value of the XML tag.
     */
    QString getXMLValue(const QString &tagName);

    /**
     * @brief Trains the AI model with additional code snippets.
     * @param trainingData A vector of code snippets for training.
     */
    void trainAI(const std::vector<QString> &trainingData);

    /**
     * @brief Suggests a completion for the given partial code.
     * @param partialCode The partial code to complete.
     * @return The suggested completion.
     */
    QString suggestCompletion(const QString &partialCode);

private:
    QString script;                 ///< The loaded script content.
    QDomDocument xmlDoc;            ///< The XML document.

    std::vector<QString> codeSnippets;   ///< AI model code snippets.
    std::unordered_set<QString> pascalKeywords;  ///< Set of Object Pascal keywords.

    /**
     * @brief Initializes the AI model with default code snippets.
     */
    void initializeAI();

    /**
     * @brief Initializes the set of Object Pascal keywords.
     */
    void initializeKeywords();
};
namespace kayte {
    class Interpreter {
    public:
        void run();
    };
}

#endif // INTERPRETER_H
