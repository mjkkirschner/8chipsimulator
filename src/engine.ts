
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

    public DFS(start: node): node[] {
        let stack = [start];
        let visited: node[] = [];
        while (stack.length > 0) {
            let vertex = stack.pop();
            if (!(_.contains(visited, vertex))) {
                visited.push(vertex);
                stack.concat(_.difference(vertex.adj, visited));
            }
        }
        return visited;
    }

    public topoSortInternal(vertex: node, visited: node[], stack: node[]) {
        visited.push(vertex);

        //recurse on children that we have not already recursed on.
        vertex.adj.forEach(x => {
            if (!(_.contains(visited, x))) {
                this.topoSortInternal(x, visited, stack)
            }
        });
        stack.unshift(vertex);


    }

    public topoSort(): Ipart[] {
        let visited:node[] = [];
        let stack:node[] = [];
        this.nodes.forEach(node => {
            if (!(_.contains(visited, node))) {
                this.topoSortInternal(node, visited, stack);
            }
        });
        return stack.map(x=>x.pointer);
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