import * as React from 'react';
import * as ReactDOM from 'react-dom';
import { Ipart } from '../primitives';
import { outputPin } from '../pins_wires';
import * as _ from 'underscore';
import { Grid } from 'react-virtualized';
import { vgaMonitorPart } from '../debugParts/vgaMonitor';

export interface IVgaProps {
    model: vgaMonitorPart
}

export class MemoryDataView extends React.Component<IVgaProps> {

    constructor(props: IVgaProps) {
        super(props);
        this.state = {};
    }

    componentDidMount() {
        this.updateCanvas();
    }
    updateCanvas() {
        const ctx = (this.refs.canvas as HTMLCanvasElement).getContext('2d');
        let pixels = new Uint8ClampedArray(_.flatten(this.props.model.screen) as number[]);
        let image = new ImageData(pixels, this.props.model.width, this.props.model.height);
        ctx.putImageData(image, 0, 0);
    }
    render() {
        return (
            <canvas ref="canvas" width={640} height={480} />
        );
    }
}