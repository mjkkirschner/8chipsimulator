import { basePart } from "./primitives";
import { outputPin } from "./pins_wires";


/**
 * toggle button is even simpler than a buffer, it has no input pins, only some internal state.
 * which is outputs.
 */

export class toggleButton extends basePart {

    public state: boolean = false;
    public outputPin: outputPin = new outputPin("buttonState", this);

    public get inputs() {
        return [];
    }

    public get outputs() {
        return [this.outputPin];
    }

    update() {
        this.outputPin.value = this.state;
        super.update();
    }
}

/**
 * momentary button is the same as toggle button but it will have a different view applied that
 * will only drive output state high while button is held down.
 */

export class momentaryButton extends toggleButton {

}