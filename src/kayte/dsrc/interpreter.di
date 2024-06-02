module kaytec.Interpreter;

extern(C++) {
    class Interpreter {
    public:
        Interpreter();
        ~Interpreter();
        bool loadScript(const QString &scriptPath);
        QString run();
        bool loadXML(const QString &xmlContent);
        QString getXMLValue(const QString &tagName);
        void initializeAI();
        void initializeKeywords();
        void trainAI(const std::vector<QString> &trainingData);
        QString suggestCompletion(const QString &partialCode);
        QString translateToBytecode(const QString &pascalCode);
    };
}
