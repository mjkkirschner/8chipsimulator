
import { Ipart } from "./primitives";
import * as _ from "underscore";
import { IPartViewState } from "./views/partView";
import { clock } from "./clock";


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

    public topoSort(): node[] {
        let visited: node[] = [];
        let stack: node[] = [];
        this.nodes.forEach(node => {
            if (!(_.contains(visited, node))) {
                this.topoSortInternal(node, visited, stack);
            }
        });
        return stack;
    }

    private minDistance(node: node, placedNodes: node[]) {
        let distances = placedNodes.map((otherNode) => {
            return Math.sqrt(Math.pow(node.pos.x - otherNode.pos.x, 2) + Math.pow(node.pos.y - otherNode.pos.y, 2))
        });
        if (distances == null) {
            return Infinity;
        }
        return Math.min(...distances);
    }

    //TODO we may need to run this on the view layer using actual bounds?
    public calculateColumnLayout(maxColumnHeight: number = 900, columnWidth: number = 400): void {
        let stack = this.nodes.map(x => { return x }).reverse();
        let currentPos = { x: 20, y: 20 };
        let columns = [];
        let column: { items: Array<node>, height: number } = { items: [], height: 0 };

        while (stack.length > 0) {
            let node = stack.pop();
            let nodeheight = Math.max(node.pointer.inputs.length, node.pointer.outputs.length) * 30;
            //if we're about to grow too large, then make a new column
            //and add this column to our list of completed columns.
            if (column.height + nodeheight > maxColumnHeight) {
                columns.push(column);
                column = { items: [], height: 0 };
                column.items.push(node);
                column.height = column.height + nodeheight;
                node.pos = currentPos;
                currentPos = { x: columns.length * columnWidth, y: column.height }
            }
            else {
                column.items.push(node);
                column.height = column.height + nodeheight;
                node.pos = currentPos;
                currentPos = { x: columns.length * columnWidth, y: column.height }
            }
        }
    }
}

class node {
    visited: boolean;
    pointer: Ipart;
    adj: node[];
    //properties only used for layout algo
    pos: { x: number, y: number }

    constructor(pointer: any) {
        this.pointer = pointer;
        this.adj = [];
        this.pos = { x: 0, y: 0 };
    }
    addNeighbor(node: node) {
        this.adj.push(node);
    }
}

export class Task {

    protected uuidv4() {
        return 'xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx'.replace(/[xy]/g, function (c) {
            var r = Math.random() * 16 | 0, v = c == 'x' ? r : (r & 0x3 | 0x8);
            return v.toString(16);
        });
    }

    public callBack: Function;
    public partUpdated: Ipart;
    //TODO not clear we need this.
    public id: string
    public caller: Task

    constructor(caller: Task, partUpdated: Ipart, callBack: Function) {
        this.caller = caller;
        this.partUpdated = partUpdated;
        this.callBack = callBack;
        this.id = this.uuidv4();
    }



}

export class simulatorExecution {

    constructor(parts: Ipart[]) {
        this.parts = parts;
    }
    //TODO remove this when clock and time steps are desgined.
    public mainClockSpeed = 50;

    public schedule: Array<Task>;
    public currentTask: Task;
    public parts: Array<Ipart>;

    public insertTask(task: Task) {
        var callerIndex = _.findLastIndex(this.schedule, (x) => { return x.id == task.caller.id || x.caller.id == task.caller.id })
        this.schedule.splice(callerIndex + 1, 0, task);
    }

    public findEntryPoints() {
        let filtered = this.parts.filter(x => { return x.inputs.length == 0 });
        console.log("found", filtered, "as entry points");
        return filtered;
    }

    private scheduleDownStreamTasks(task: Task): void {

        let downStreamParts = _.flatten(task.partUpdated.outputs.map(x => x.attachedWires.map(y => y.endPin.owner))) as Ipart[];
        let downstreamTasks = downStreamParts.map(part => {
            //tricky recrusive scheduling.
            let downstreamTask = new Task(task, part, null);
            downstreamTask.callBack = () => { part.update(); this.scheduleDownStreamTasks(downstreamTask); }
            return downstreamTask;
        });
        downstreamTasks.forEach(x => { this.insertTask(x) });
    }

    private generateTaskAndDownstreamTasks(rootTask: Task, part: Ipart): Task {
        let mainTask = new Task(rootTask, part, null);
        mainTask.callBack = () => {
            part.update();
            this.scheduleDownStreamTasks(mainTask);
        };
        return mainTask;
    }

    public Evaluate() {

        let entryPoints = this.findEntryPoints();
        let clocks = entryPoints.filter(x => { return x instanceof clock });
        let rootOfAllTasks = new Task(null, null, () => { throw new Error("I am the root, I should never run"); });

        let tasks = entryPoints.map(x => {
            return this.generateTaskAndDownstreamTasks(rootOfAllTasks, x);
        });

        this.schedule = tasks.map((x) => { return x });

        //TODO remove - this is a hack that schedules a clock increment task every n ms...
        setInterval(() => {
            if (this.schedule.length == 0) {
                clocks.forEach(x => {
                      let clocktTask = this.generateTaskAndDownstreamTasks(rootOfAllTasks, x);
                      this.insertTask(clocktTask);
                  });
                this.runTasksInSchedule();
            } else {
                throw new Error("trying to schedule a clock incrment while there are other tasks still in the q...., usually this means the clock is too fast...")
            };

        }, this.mainClockSpeed);

        this.runTasksInSchedule();
    }

    private runTasksInSchedule() {
        while (this.schedule.length > 0) {
            var headOfQ = this.schedule[0];
            this.currentTask = headOfQ;

            //setTimeout(() => { headOfQ.callBack() }, 0);
            headOfQ.callBack();
            this.schedule.shift();
        }
    }
}