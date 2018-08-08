
import { Ipart } from "./primitives";
import * as _ from "underscore";
import { IPartViewState } from "./views/partView";
import { clock } from "./clock";
import { outputPin } from "./pins_wires";


export class graph {
    public nodes: graphNode[];

    constructor(parts: Ipart[]) {
        let AllNodes = parts.map(part => {
            return new graphNode(part);
        });
        AllNodes.forEach(node => {
            let neighbors = node.pointer.outputs.map(pin => {
                return pin.attachedWires.map(wire => {
                    if (wire.endPin.owner) {
                        return wire.endPin.owner;
                    }
                    throw new Error("owner was null for wire starting at:" + node.pointer.displayName + ",port: " + pin.name)

                });
            });
            //foreach neighbor node we need to find the node it points to
            //and call addneighbor!
            let flatNeighbors = _.flatten(neighbors) as Ipart[];
            flatNeighbors.forEach(neigbor => {
                let matchingPart = _.find(AllNodes, (item) => { return item.pointer === neigbor });
                if (matchingPart == null) {
                    throw new Error("could not find a matching node for part: " + neigbor + ", but it should exist");
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

    public DFS(start: graphNode): graphNode[] {
        let stack = [start];
        let visited: graphNode[] = [];
        while (stack.length > 0) {
            let vertex = stack.pop();
            if (!(_.contains(visited, vertex))) {
                visited.push(vertex);
                stack.concat(_.difference(vertex.adj, visited));
            }
        }
        return visited;
    }

    public topoSortInternal(vertex: graphNode, visited: graphNode[], stack: graphNode[]) {
        visited.push(vertex);

        //recurse on children that we have not already recursed on.
        vertex.adj.forEach(x => {
            if (!(_.contains(visited, x))) {
                this.topoSortInternal(x, visited, stack)
            }
        });
        stack.unshift(vertex);


    }

    public topoSort(): graphNode[] {
        let visited: graphNode[] = [];
        let stack: graphNode[] = [];
        this.nodes.forEach(node => {
            if (!(_.contains(visited, node))) {
                this.topoSortInternal(node, visited, stack);
            }
        });
        return stack;
    }

    private minDistance(node: graphNode, placedNodes: graphNode[]) {
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
        let column: { items: Array<graphNode>, height: number } = { items: [], height: 0 };

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

export class graphNode {
    visited: boolean;
    pointer: Ipart;
    adj: graphNode[];
    //properties only used for layout algo
    pos: { x: number, y: number }

    constructor(pointer: any) {
        this.pointer = pointer;
        this.adj = [];
        this.pos = { x: 0, y: 0 };
    }
    addNeighbor(node: graphNode) {
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
    public id: string
    public caller: Task
    public executedAtTime;

    constructor(caller: Task, partUpdated: Ipart, callBack: Function, executedAtTime?: number) {
        this.caller = caller;
        this.partUpdated = partUpdated;
        this.callBack = callBack;
        this.id = this.uuidv4();
        this.executedAtTime = executedAtTime != null ? executedAtTime : null;
    }

}

export class simulatorExecution {


    rootOfAllTasks: Task;
    time: number;

    constructor(parts: Ipart[]) {
        this.parts = parts;
        this.time = 0;
    }

    public incrementTime(timeUnits: number) {
        this.time = this.time + timeUnits;
    }

    // this function asserts invariants hold about our schedule and throws errors if they are false.
    private validateSchedule(): void {
        let neverWillRuns = this.schedule.filter((task) => { return task.executedAtTime < this.time && task.executedAtTime != null });
        if (neverWillRuns.length > 0) {
            console.log("currentTime:", this.time);
            console.log(this.schedule);
            throw new Error("There is a task in the schedule which was scheduled to run in the past, but it never ran.");
        }
    }

    public schedule: Array<Task>;
    public currentTask: Task;
    public parts: Array<Ipart>;

    public insertTask(task: Task) {
        var callerIndex = _.findLastIndex(this.schedule, (x) => { return x.id == task.caller.id || x.caller.id == task.caller.id })
        this.schedule.splice(callerIndex + 1, 0, task);
    }

    public findEntryPoints() {
        let filtered = this.parts.filter(x => { return x.inputs.length == 0 || x instanceof clock });
        console.log("found", filtered, "as entry points");
        return filtered;
    }

    private scheduleDownStreamTasks(task: Task, portIdsToSchedule: string[]): void {

        let downStreamParts = _.flatten(task.partUpdated.outputs.map(x => x.attachedWires.map(y => y.endPin.owner))) as Ipart[];
        let uniqueDownStreamParts = _.unique(downStreamParts);

        // we do this so we can only update parts which lie downstream of an updated port - 
        // instead of updating all downstream parts... This shouldn't be an issue, except clockWithMode parts
        // keep internal state that is effected by update being called...

        //find which ports connect to each of these unique parts...
        let portPartMap = {};
        task.partUpdated.outputs.forEach(port => {
            let downStreamPartsOnThisPort = port.attachedWires.map(x => x.endPin.owner);
            let uniquePartsOnThisPort = _.intersection(downStreamPartsOnThisPort, uniqueDownStreamParts.map(x => x));
            if (uniquePartsOnThisPort.length > 0) {
                portPartMap[port.id] = uniquePartsOnThisPort;
            }
        });

        //grab all the matching parts
        let uniqueDownstreamPartsOnModifiedPortsOnly = _.unique(_.flatten(portIdsToSchedule.map((id) => { return portPartMap[id] }))) as Ipart[];

        let downstreamTasks = uniqueDownstreamPartsOnModifiedPortsOnly.map(part => {
            //tricky recursive scheduling.
            let downstreamTask = new Task(task, part, null, this.time + 1);
            downstreamTask.callBack = () => {   //here we determine if we should schedule any more downstream tasks.
                //we'll check what the current output values are and run an update of the part
                //if the output changes, we'll schedule tasks for the downstream parts which were on ports that changed their
                //values
                let currentOutputs = part.outputs.map(x => x.value);
                part.update(this);
                let newOutputs = part.outputs.map(x => x.value);

                //we should only schedule downstream tasks on parts that are attached to ports
                //which have changed their value.

                let portsToSchedule: outputPin[] = this.findPortsToSchedule(currentOutputs, newOutputs, part);

                //if there is a difference then we need to schedule downstream tasks
                if (!(_.isEqual(currentOutputs, newOutputs))) {
                    this.scheduleDownStreamTasks(downstreamTask, portsToSchedule.map(x => x.id));
                }
            }
            return downstreamTask;
        });
        downstreamTasks.forEach(x => { this.insertTask(x) });
    }

    public generateTaskAndDownstreamTasks(rootTask: Task, part: Ipart, scheduleAtTime?: number): Task {
        let mainTask = new Task(rootTask, part, null, scheduleAtTime);
        mainTask.callBack = () => {
            let currentOutputs = part.outputs.map(x => x.value);
            part.update(this);
            let newOutputs = part.outputs.map(x => x.value);

            //we should only schedule downstream tasks on parts that are attached to ports
            //which have changed their value.

            let portsToSchedule: outputPin[] = this.findPortsToSchedule(currentOutputs, newOutputs, part);

            //if there is a difference then we need to schedule downstream tasks
            if (!(_.isEqual(currentOutputs, newOutputs))) {
                this.scheduleDownStreamTasks(mainTask, portsToSchedule.map(x => x.id));
            }
        };
        return mainTask;
    }

    private findPortsToSchedule(currentOutputs: boolean[], newOutputs: boolean[], part: Ipart) {
        let equalVals = currentOutputs.map((x, i) => x == newOutputs[i]);
        let portsToSchedule: outputPin[] = [];
        equalVals.forEach((v, i) => {
            //port at i had a different value...
            //so schedule that.
            if (v == false) {
                let port = part.outputs[i];
                if (port.attachedWires.length > 0) {
                    portsToSchedule.push(port);
                }
            }
        });
        return portsToSchedule;
    }

    public Evaluate() {

        let entryPoints = this.findEntryPoints();
        this.rootOfAllTasks = new Task(null, null, () => { throw new Error("I am the root, I should never run"); });

        let tasks = entryPoints.map(x => {
            return this.generateTaskAndDownstreamTasks(this.rootOfAllTasks, x, 0);
        });

        this.schedule = tasks.map((x) => { return x });
        this.runTasksInSchedule();
    }

    private runTasksInSchedule() {
        setInterval(() => {
            _.range(0, 200).forEach(x => {
                if (this.schedule.length > 0) {
                    let currentTasks = this.schedule.filter(x => x.executedAtTime == this.time);
                    currentTasks.forEach((currentTask) => {
                        this.currentTask = currentTask;
                        // if the current task has a specified time to execute
                        // then only run the task if this matches the current simulation time
                        this.schedule.splice(_.indexOf(this.schedule, this.currentTask), 1);
                        this.currentTask.callBack();
                    });
                    this.validateSchedule();
                    this.incrementTime(1);
                }
            })
        }, 1);
    }
}