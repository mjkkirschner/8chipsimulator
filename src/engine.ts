
import { Ipart } from "./primitives";
import * as _ from "underscore";


export class graph {
    public nodes: node[];

    constructor(parts: Ipart[]) {
        let AllNodes = parts.map(part => {
            return new node(part);
        });
        AllNodes.forEach(node => {
            let neighbors = node.pointer.outputs.map(pin => {
                return pin.attachedWires.map(wire => {
                    return wire.endPin.owner;
                });
            });
            //foreach neighbor node we need to find the node it points to
            //and call addneighbor!
            let flatNeighbors = _.flatten(neighbors) as Ipart[];
            flatNeighbors.forEach(neigbor => {
                let matchingPart = _.find(AllNodes, (item) => { return item.pointer === neigbor });
                if (matchingPart == null) {
                    throw new Error("could not find a matching part but it should exist");
                }
                node.addNeighbor(matchingPart);

            });

        });
        this.nodes = AllNodes;
    }

    public printNodes() {
        this.nodes.forEach(x => {
            console.log("xxxxxx");
            x.adj.forEach(n => {
                console.log(x.pointer.constructor, " is attached to:", n.pointer.constructor)
            });
        });
    }
}

class node {
    visited: boolean;
    pointer: Ipart;
    adj: node[];

    constructor(pointer: any) {
        this.pointer = pointer;
        this.adj = [];

    }
    addNeighbor(node: node) {
        this.adj.push(node);
    }
}

export class execution {


    //public static topologicalSort(parts: Ipart[]): Ipart[] {



}
}