import { Ipart, basePart } from "./primitives";
import * as _ from "underscore";



export class wire {

    startPin: outputPin
    endPin: inputPin
    //TODO might need to also work with inputOutputPins
    constructor(startPin: outputPin, endPin: inputPin) {
        this.startPin = startPin;
        this.endPin = endPin;
        this.endPin.attachedWire = this;
        this.startPin.attachedWires.push(this);
    }
}


/**
 * internal wire, usually used to connect inputs to inputs
 * and outputs to outputs - just a passthrough reference of value.
 */
export class internalWire {

    startPin: inputPin | outputPin
    endPin: inputPin | outputPin
    //TODO might need to also work with inputOutputPins
    //TODO seems we might be able to make these connections in the correct directions
    //automatically somehow...
    constructor(startPin: outputPin | inputPin, endPin: inputPin | outputPin) {
        this.startPin = startPin;
        this.endPin = endPin;

        //if we are input -> input, then only the internal pin
        //must be able to go lookup a value - so this wire only exists here...?
        //TODO tests?
        if (this.endPin instanceof inputPin) {
            this.endPin.attachedWire = this;
        }

        if (this.startPin instanceof outputPin) {
            this.startPin.internalWire = this
        }

        //essentially internal wire are pointers,which means only one pin holds a reference...
    }
}



/**
 * pin enables connecting components together.
 */
export abstract class pin {

    name: string;
    owner: Ipart;
    id: string
    protected uuidv4() {
        return 'xxxxxxxx_xxxx_4xxx_yxxx_xxxxxxxxxxxx'.replace(/[xy]/g, function (c) {
            var r = Math.random() * 16 | 0, v = c == 'x' ? r : (r & 0x3 | 0x8);
            return v.toString(16);
        });
    }
    index:number = 0;
    constructor(name?: string, owner?: Ipart, index?:number) {
        this.id = this.uuidv4();
        if (name) {
            this.name = name;
        }
        if (owner) {
            this.owner = owner;
        }
        if(index != null){
            this.index = index;
        }
    }
}

export class inputPin extends pin {
    activeLow: boolean = false;
    attachedWire: wire | internalWire

    constructor(name?: string, owner?: Ipart, activeLow?: boolean, index?:number) {
        super(name, owner,index);

        if (activeLow != null) {
            this.activeLow = activeLow
        }
    }

    /**
 * an input pin only has a value if it's connected
 * to an ouput port via a wire.
 */
    get value(): boolean {
        if (this.attachedWire) {
            return this.attachedWire.startPin.value;
        }
        //console.log("nothing connected to this input pin, but we need the value");
        //console.log("returning false");
        //console.log("for pin: ", this.name, "on part: ", this.owner? this.owner.displayName || "null display name" : "unkown is null- how?");
        return false;
    }
}

/**
 * only output pins have values, if they reference other output pins they return those values.
 */
export class outputPin extends pin {
    private _value: boolean = false;
    private _internalWire: internalWire;

    /**
     * These are wires which lead to downstream inputPins.
     */
    public attachedWires: wire[] = [];

    get internalWire(): internalWire {
        return this._internalWire;
    }
    set internalWire(val: internalWire) {
        if (this._internalWire != null) {
            console.log("changing internal wire for", this);
        }
        this._internalWire = val;
    }

    /**
     * if this output pin is attached via any internalWires to other output pins
     * then grab that value...
     * otherwise get the internal value.
     */
    get value(): boolean {

        if (this.internalWire) {
            return this.internalWire.endPin.value;
        } else {
            return this._value;
        }
    }

    set value(val: boolean) {
        this._value = val;
    }
}


export enum pinMode { input, output };

/**
 * This class can be used represent a pin on a part which can act as an output, but at other times
 * might need to act as an input and will need to reference other output pins.
 */
export class inputOutputPin extends pin {
    public mode: pinMode = pinMode.output;
    public internalInput: inputPin;
    public internalOutput: outputPin;

    constructor(name?: string, owner?: Ipart, activeLowInput?:boolean, index?:number) {
        super(name, owner,index);
        this.internalInput = new inputPin(name + "input", this.owner,activeLowInput,index);
        this.internalOutput = new outputPin(name + "output", this.owner,index);
    }

    get value(): boolean {
        if (this.mode == pinMode.input) {

            return this.internalInput.value;
        }
        else {
            return this.internalOutput.value;
        }
    }
    set value(val: boolean) {
        if (this.mode == pinMode.input) {
            throw new Error("you cannot set the value of an input reference, set the value on the pin directly.");
        }
        else {
            this.internalOutput.value = val;
        }
    }
}