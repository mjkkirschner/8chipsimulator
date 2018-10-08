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
    STOREAATPOINTER
}

class codeConverter {

    constructor() {

    }

    instructionAsBinaryString(command: commandType): boolean[] {
        //given a command which maps directly to an enum number
        //lets convert it to a 16bit binary string.
        return command.toString(2).padStart(16, "0");
    }

    instructionAsHexString(command: commandType): string {
        //given a command which maps directly to an enum number
        //lets convert it to a 16bit binary string.
        return "0x" + (command.toString(16).padStart(4, "0"));
    }


}


class parser {

    output: string[];
    currentLineIndex = -1;
    currentLine: string
    allInputLines: string[] = [];

    commandTypeToNumberOfLines: { [key: string]: number };

    constructor(assemblyFile: fs.PathLike) {
        //open the file
        let data = fs.readFileSync(assemblyFile);
        let dataString = data.toString();
        this.allInputLines = dataString.split(os.EOL);


    }

    private setInitialMaps() {
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
    }


    advance() {
        //for some commands we need to advance 2 or more lines.
        //if those commands take operands.
        //consult the map to determine how many lines to advance.
        let increment = 1;
        //we need to increment based on the last command.
        if (this.currentLine != null) {
            increment = this.commandTypeToNumberOfLines[this.commandType()];
            console.log("incrment is", increment, "for commandType:", this.commandType());
        }

        this.currentLineIndex = this.currentLineIndex + increment;
        this.currentLine = this.allInputLines[this.currentLineIndex];

    }

    hasMoreCommands(): boolean {
        return this.currentLineIndex < this.allInputLines.length
    }

    commandType(): commandType {
        return commandType[this.currentLine];
    }

    operands(): string[] {
        if (this.commandTypeToNumberOfLines[this.commandType()] > 1) {
            return [this.allInputLines[this.currentLineIndex + 1]];
        }
        throw new Error(this.commandType().toString() + "does not have an operand")
    }

    parse(format: outputFormat) {
        let converter = new codeConverter();
        while (this.hasMoreCommands()) {
            this.advance();
            if (format == outputFormat.hex) {
                this.output.push(converter.instructionAsHexString(this.commandType()));

            }
            else {
                this.output.push(converter.instructionAsBoolArray(this.commandType()));
            }
            // TODO do any conversion we need to do on the operand - 
            // the operand might be hex, decimal, or binary... convert it.
            this.output.concat(this.operands());
        }
    }

}