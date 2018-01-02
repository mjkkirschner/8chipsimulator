import { Ipart, pin, IAggregatePart } from "./primitives";
import * as _ from "underscore";



export class fullAdder implements Ipart {

    private datapins: pin[] = [new pin(), new pin()];
    public sumPin = new pin();
    public carryOut = new pin();
    public carryIn: pin;

    update() {
        //SUM = (A XOR B) XOR Cin = (A ⊕ B) ⊕ Cin
        //CARRY-OUT = A AND B OR Cin(A XOR B) = A.B + Cin(A ⊕ B)
        let A = this.datapins[0].value;
        let B = this.datapins[1].value;
        let C = this.carryIn.value;
        let AXORB = (Number(A) ^ Number(B))
        let SUM = AXORB ^ Number(C);
        let CARRYOUT = (A && B) || (C && Boolean(AXORB));

        this.sumPin.value = Boolean(SUM);
        this.carryOut.value = CARRYOUT;

    }
    assignInputPin(pin: pin, index: number) {
        this.datapins[index] = pin;
    }

    constructor(carryIn: pin) {
        this.carryIn = carryIn;
    }

}

export class nbitAdder implements Ipart, IAggregatePart {

    //0->N-1 are Apins, N -> (N*2)-1 are Bpins
    private datapins: pin[] = [];
    public carryIn: pin;
    private n:number;


    public sumOutPins: pin[] = [];
    public carryOut: pin;
    parts: fullAdder[];

    constructor(carryIn: pin, n: number) {

        this.carryIn = carryIn;
        this.n = n;

        this.parts = _.range(0, n).map((x, index) => {
            let part = new fullAdder(this.carryIn);
            this.sumOutPins[index] = part.sumPin;
            return part;
        });

        this.parts.forEach((part, index) => {
            //assign the carryin of this adder to the carry out
            //of the previous one. - skip the LSB(last item)
            if (index != (n - 1)) {
                part.carryIn = this.parts[index + 1].carryOut;
            }
        });


        //these may seem backwards - but recall that parts[0] represents the MSB.
        //hook up the LSB cinput to this chips cinput
        _.last(this.parts).carryIn = this.carryIn;
        //hookup the coutput of this chip to the MSB coutput. 
        this.carryOut = _.first(this.parts).carryOut;


        this.parts.forEach((part, index) => this.assignInputPin(new pin(), index));

    }

    update() {
        this.parts.forEach(part => { part.update(); })
    }
    assignInputPin(pin: pin, index: number) {
        //determine if this pin is an a or b pin
        let Aside = true;
        if (index >= this.n) {
            Aside = false;
        }
        //if Aside is false, then index is 1, which means this b is attached to the b input
        //of this adder.
        let finalIndex = Aside ? 0 : 1;
        let partIndex = index % this.n;

        this.parts[partIndex].assignInputPin(pin, finalIndex);
    }
    getDataAsInteger(): number {
        return parseInt(this.sumOutPins.map(pin => { return Number(pin.value) }).join(""), 2);
    }

}