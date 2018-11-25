import * as fs from 'fs';
import * as os from 'os';

enum outputFormat {
    hex,
    binary,
}

enum commandType {
    NOP,
    LOADA,
    OUTA,
    ADD,
    SUBTRACT,
    STOREA,
    LOADAIMMEDIATE,
    JUMP,
    JUMPIFEQUAL,
    JUMPIFLESS,
    JUMPIFGREATER,
    LOADB,
    LOADBIMMEDIATE,
    STOREB,
    UPDATEFLAGS,
    HALT,
    LOADCONTROLIMMEDIATE,
    STORECOMSTATUS,
    STORECOMDATA,
    STOREAATPOINTER,
    LOADAATPOINTER,
    MULTIPLY,
    DIVIDE,
    MODULO,

    ASSEM_LABEL = -1,
    ASSEM_STORE_MACRO = -2,

}

export class assembler {

    private bootLoaderOffset = 255;
    private symbolTableOffset = 500;

    private assemblyFilePath: fs.PathLike;
    symbolTable: { [key: string]: number } = {};

    constructor(filePath: fs.PathLike) {
        this.assemblyFilePath = filePath;
    }

    private expandMacros(assemblyFilePath: fs.PathLike): string[] {
        let parser = new Parser(assemblyFilePath);
        while (parser.hasMoreCommands() && parser.advance()) {

            //if the current command is a storage macro, we should do a conversion like:

            //symbol = 100
            //is transformed to:
            ////////////////
            //LOADAIMMEDIATE
            //100
            //STOREA
            //symbol
            ////////////////

            if (parser.commandType() == commandType.ASSEM_STORE_MACRO) {

                parser.output.push(commandType[commandType.LOADAIMMEDIATE]);
                parser.output.push(parser.operands()[1]);
                parser.output.push(commandType[commandType.STOREA]);
                parser.output.push(parser.operands()[0]);

            }
            //all other commands are unchanged
            else {
                parser.output.push(parser.currentLine);
                if (parser.hasOperands()) {
                    parser.output = parser.output.concat(parser.operands());
                }

            }

        }
        return parser.output;
    }

    private addLabelsToSymbolTable(code: string[]) {
        let outputLineCounter = 0;

        let parser = new Parser(null, code);
        while (parser.hasMoreCommands() && parser.advance()) {

            //if the current command is a label - don't increment our counter.
            if (parser.commandType() != commandType.ASSEM_LABEL) {
                let increment = parser.commandTypeToNumberOfLines[parser.commandType()];
                outputLineCounter = outputLineCounter + increment;

                //variables will be handled in the next pass.
            }
            //if we see a label, add a symbol for the address it points to.
            else {
                this.symbolTable[parser.labelText()] = outputLineCounter + this.bootLoaderOffset;
                console.log("adding symbol", parser.labelText(), "at line ", outputLineCounter + this.bootLoaderOffset)
            }
        }
    }

    private convertOpCodes(code: string[]): string[] {
        let parser = new Parser(null, code);
        let converter = new codeConverter();

        while (parser.hasMoreCommands() && parser.advance()) {

            //dont do anything for labels - we already made symbols for them
            //in the first pass.
            if (parser.commandType() != commandType.ASSEM_LABEL) {
                //first convert the opcode.
                parser.output.push(converter.instructionAsHexString(parser.commandType()));

                //then check if this opcode has symbols
                if (parser.hasSymbols()) {
                    //get the symbol and lookup the memory address it points to - 
                    //store this as the next line in the output string array.

                    //TODO for now there is only ever 1;
                    let symbol = parser.operands()[0];
                    if (this.symbolTable[symbol] != null) {
                        parser.output.push(converter.numberAsHexString(this.symbolTable[symbol]));
                    }

                    //new symbol store it.
                    //increment the symbolTable offset so variables are stored at next free space at offset 255+500 ( so first one is at 755)
                    //this means programs have a max length currently of 500 lines - and can store 1000 - 755 symbols - 
                    //to increase this we just need to modify the bootloader - we have 64k address space to play with in the cpu.
                    //transfer time will just increase.
                    else {
                        console.log("adding symbol", symbol, "at line ", this.bootLoaderOffset + this.symbolTableOffset)
                        this.symbolTable[symbol] = this.bootLoaderOffset + this.symbolTableOffset;
                        this.symbolTableOffset = this.symbolTableOffset + 1;
                        parser.output.push(converter.numberAsHexString(this.symbolTable[symbol]));
                    }
                }
                //if no symbols check if it has any operands
                else if (parser.hasOperands()) {
                    parser.output = parser.output.concat(parser.operands().map(x => converter.numberAsHexString(parseInt(x))));
                }
            }

        }
        return parser.output;
    }


    convertToBinary(): string[] {

        //phase 1: expand macro commands:
        let expandedCode = this.expandMacros(this.assemblyFilePath);
        //phase 2: build the symbol table for labels:
        this.addLabelsToSymbolTable(expandedCode);
        //phase 3: do the actual conversion from command strings and dec numbers operands to hex.
        let outputLines = this.convertOpCodes(expandedCode);
        return outputLines;
    }
}

class codeConverter {

    constructor() {

    }

    instructionAsBinaryString(command: commandType): string {
        //given a command which maps directly to an enum number
        //lets convert it to a 16bit binary string.
        return command.toString(2).padStart(16, "0");
    }

    instructionAsHexString(command: commandType): string {
        //given a command which maps directly to an enum number
        //lets convert it to a 16bit binary string.
        return "0x" + (command.toString(16).padStart(4, "0"));
    }

    numberAsHexString(operand: number): string {
        return "0x" + (operand.toString(16).padStart(4, "0"));
    }


}


class Parser {

    output: string[] = [];
    currentLineIndex = -1;
    currentLine: string
    allInputLines: string[] = [];

    commandTypeToNumberOfLines: { [key: string]: number };


    constructor(assemblyFile: fs.PathLike, code: string[] = null) {
        if (code == null) {
            //open the file
            let data = fs.readFileSync(assemblyFile);
            let dataString = data.toString();
            //split on end of line, and filter blank lines or comment lines out.
            this.allInputLines = dataString.split(os.EOL).filter(x => x != "" && !(x.startsWith("//")));

        }
        //if client passes code directly just ignore the file path.
        else {
            this.allInputLines = code;
        }
        this.setInitialMaps();

    }


    private setInitialMaps() {
        this.commandTypeToNumberOfLines = {};
        //set how many lines of code each instruction is
        this.commandTypeToNumberOfLines[commandType.NOP] = 1;
        this.commandTypeToNumberOfLines[commandType.LOADA] = 2;
        this.commandTypeToNumberOfLines[commandType.OUTA] = 1;
        this.commandTypeToNumberOfLines[commandType.ADD] = 2;
        this.commandTypeToNumberOfLines[commandType.SUBTRACT] = 2;
        this.commandTypeToNumberOfLines[commandType.STOREA] = 2;
        this.commandTypeToNumberOfLines[commandType.LOADAIMMEDIATE] = 2;
        this.commandTypeToNumberOfLines[commandType.JUMP] = 2;
        this.commandTypeToNumberOfLines[commandType.JUMPIFEQUAL] = 2;
        this.commandTypeToNumberOfLines[commandType.JUMPIFLESS] = 2;
        this.commandTypeToNumberOfLines[commandType.JUMPIFGREATER] = 2;
        this.commandTypeToNumberOfLines[commandType.LOADB] = 2;
        this.commandTypeToNumberOfLines[commandType.LOADBIMMEDIATE] = 2;
        this.commandTypeToNumberOfLines[commandType.STOREB] = 2;
        this.commandTypeToNumberOfLines[commandType.UPDATEFLAGS] = 1;
        this.commandTypeToNumberOfLines[commandType.HALT] = 1;
        this.commandTypeToNumberOfLines[commandType.LOADCONTROLIMMEDIATE] = 2;
        this.commandTypeToNumberOfLines[commandType.STORECOMSTATUS] = 2;
        this.commandTypeToNumberOfLines[commandType.STORECOMDATA] = 2;
        this.commandTypeToNumberOfLines[commandType.STOREAATPOINTER] = 2;
        this.commandTypeToNumberOfLines[commandType.ASSEM_LABEL] = 1// TODO ??
        this.commandTypeToNumberOfLines[commandType.ASSEM_STORE_MACRO] = 1;
        this.commandTypeToNumberOfLines[commandType.LOADAATPOINTER] = 2;
        this.commandTypeToNumberOfLines[commandType.MULTIPLY] = 2;
        this.commandTypeToNumberOfLines[commandType.DIVIDE] = 2;
        this.commandTypeToNumberOfLines[commandType.MODULO] = 2;

    }

    //returns false if the current line is undefined...we're out
    // of commands.
    advance(): boolean {
        //for some commands we need to advance 2 or more lines.
        //if those commands take operands.
        //consult the map to determine how many lines to advance.
        let increment = 1;
        //we need to increment based on the last command.
        if (this.currentLine != null) {
            increment = this.commandTypeToNumberOfLines[this.commandType()];
            console.log("increment is", increment, "for commandType:", this.commandType(), this.currentLine);
        }

        this.currentLineIndex = this.currentLineIndex + increment;
        this.currentLine = this.allInputLines[this.currentLineIndex];

        if (this.currentLine != null) {
            return true;
        }
        return false;
    }

    hasMoreCommands(): boolean {
        return this.currentLineIndex < this.allInputLines.length;
    }

    commandType(): commandType {
        if (commandType[this.currentLine] != null) {
            return commandType[this.currentLine];
        }
        else if (this.currentLine.startsWith('(') && this.currentLine.endsWith(')')) {
            return commandType.ASSEM_LABEL;
        }
        else if (this.currentLine.includes("=")) {
            return commandType.ASSEM_STORE_MACRO;
        }
    }

    hasSymbols(): boolean {
        //return true that the current command has symbols if the command has operands and the operand is a alphabetic string.
        if (this.commandTypeToNumberOfLines[this.commandType()] > 1 &&
            this.allInputLines[this.currentLineIndex + 1][0].match(/^[A-Za-z]+$/) != null) {
            return true;
        }
        return false;
    }

    hasOperands(): boolean {
        if (this.commandTypeToNumberOfLines[this.commandType()] > 1
            || this.commandType() == commandType.ASSEM_STORE_MACRO) {
            return true;
        }
        return false;
    }

    operands(): string[] {
        if (this.commandTypeToNumberOfLines[this.commandType()] > 1) {
            return [this.allInputLines[this.currentLineIndex + 1]];
        }
        else if (this.commandType() == commandType.ASSEM_STORE_MACRO) {
            return this.currentLine.split('=').map(x => x.trim());
        }
        throw new Error(this.commandType().toString() + "does not have an operand")
    }


    labelText(): string {
        if (this.commandType() == commandType.ASSEM_LABEL) {
            return this.currentLine.replace("(", "").replace(")", "");
        }
        else throw new Error("not a label");
    }

    /*     getCommandTypeForLine(assemblyLineIndex: number): commandType {
            let currentLine = this.allInputLines[assemblyLineIndex];
            if (this.commandType[currentLine] != null) {
                return this.commandType();
            }
            else if (currentLine.startsWith('(') && currentLine.endsWith(')')) {
                return commandType.LABEL;
            } 
        }*/

    parse(format: outputFormat) {
        let converter = new codeConverter();
        while (this.hasMoreCommands() && this.advance()) {

            if (format == outputFormat.hex) {
                this.output.push(converter.instructionAsHexString(this.commandType()));

            }
            else {
                this.output.push(converter.instructionAsBinaryString(this.commandType()));
            }
            // TODO do any conversion we need to do on the operand - 
            // the operand might be hex, decimal, or binary... convert it.
            this.output.concat(this.operands());
        }
        console.log(this.output.join(os.EOL));
    }

}