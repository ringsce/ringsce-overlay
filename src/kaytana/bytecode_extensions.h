#ifndef BYTECODE_INSTRUCTIONS_H
#define BYTECODE_INSTRUCTIONS_H

enum class BytecodeInstruction {
    NOP,        // No operation
    HALT,       // Halt execution
    PUSH,       // Push a value onto the stack
    POP,        // Pop a value from the stack
    ADD,        // Add two values from the stack
    SUBTRACT,   // Subtract two values from the stack
    MULTIPLY,   // Multiply two values from the stack
    DIVIDE,     // Divide two values from the stack
    PRINTLN     // Print a value from the stack
};

#endif // BYTECODE_INSTRUCTIONS_H
