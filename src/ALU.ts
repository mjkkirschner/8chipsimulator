import { Ipart, IAggregatePart, basePart } from "./primitives";
import * as _ from "underscore";
import { inputPin, outputPin, internalWire, wire } from "./pins_wires";

//TODO add an ALU class...

export class fullAdder extends basePart implements Ipart {

    public datapins: inputPin[] = [new inputPin("data1", this), new inputPin("data2", this)];
    public sumPin = new outputPin("SumOut", this);
    public carryOut = new outputPin("carryOut", this);
    public carryIn: inputPin = new inputPin("carryIn", this);

    public get inputs() {
        return this.datapins.concat(this.carryIn);
    }

    public get outputs(): outputPin[] {
        return [this.sumPin, this.carryOut];
    }


    update() {
        //SUM = (A XOR B) XOR Cin = (A ⊕ B) ⊕ Cin
        //CARRY-OUT = A AND B OR Cin(A XOR B) = A.B + Cin(A ⊕ B)
        let A = this.datapins[0].value;
        let B = this.datapins[1].value;
        let C = this.carryIn.value;
        let AXORB = (Number(A) ^ Number(B))
        let SUM = AXORB ^ Number(C);
        let CARRYOUT = (A && B) || (Boolean(Number(C && A) ^ Number(C && B)));

        this.sumPin.value = Boolean(SUM);
        this.carryOut.value = CARRYOUT;
        super.update();
    }

    constructor(name?: string) {
        super(name);
    }

}

export class nbitAdder extends basePart implements Ipart, IAggregatePart {

    //0->N-1 are Apins, N -> (N*2)-1 are Bpins
    public dataPinsA: inputPin[] = [];
    public dataPinsB: inputPin[] = [];
    public carryIn = new inputPin("carryIn", this);
    private n: number;
    public internalWires: internalWire[] = [];

    public sumOutPins: outputPin[] = [];
    public carryOut = new outputPin("carryOut", this);
    parts: fullAdder[];

    public get inputs() {
        let step1 = this.dataPinsA.concat(this.dataPinsB);
        let step2 = step1.concat(this.carryIn);
        return step2;
    }

    public get outputs() {
        return this.sumOutPins//.concat(this.carryOut);
    }


    constructor(n: number, name?: string) {
        super(name);

        this.n = n;

        this.parts = _.range(0, n).map((x, index) => {
            let part = new fullAdder();
            this.dataPinsA[index] = new inputPin("inputA" + index, this, false, index);
            this.dataPinsB[index] = new inputPin("inputB" + index, this, false, index);
            this.sumOutPins[index] = new outputPin("output" + index, this, index);

            let intDataWire = new internalWire(this.dataPinsA[index], part.datapins[0]);
            let intDataWire2 = new internalWire(this.dataPinsB[index], part.datapins[1]);
            //reversed...
            let outWire = new internalWire(this.sumOutPins[index], part.sumPin, );
            this.internalWires.push(intDataWire, intDataWire2, outWire);

            return part;
        });

        this.parts.forEach((part, index) => {
            //assign the carryin of this adder to the carry out
            //of the previous one. - skip the LSB(last item)
            if (index != (n - 1)) {
                //TODO should this be an internal wire...?
                let internalCarryWire = new wire(this.parts[index + 1].carryOut, part.carryIn);
            }

        });


        //these may seem backwards - but recall that parts[0] represents the MSB.
        //hook up the LSB cinput to this chips cinput
        let internalCarryWire = new internalWire(this.carryIn, _.last(this.parts).carryIn);


        //hookup the carryOutput of this chip to the MSB carryoutput. 
        let internalOutputWire = new internalWire(this.carryOut, _.first(this.parts).carryOut);

    }

    update() {
        this.parts.slice().reverse().forEach(part => { part.update(); })
        super.update();
    }

    getDataAsInteger(): number {
        return parseInt(this.sumOutPins.map(pin => { return Number(pin.value) }).join(""), 2);
    }

}