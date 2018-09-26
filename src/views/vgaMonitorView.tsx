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


export class VGADataView extends React.Component<IVgaProps> {
    private fullblack = _.range(0, this.props.model.width).map(i => _.flatten(_.range(0, this.props.model.height).map(j => [0, 0, 0, 255])));

    constructor(props: IVgaProps) {
        super(props);
        this.state = {};

    }

    componentDidMount() {
        this.updateCanvas();
    }

    componentDidUpdate() {
        this.updateCanvas();
    }
    updateCanvas() {
        const ctx = (this.refs.canvas as HTMLCanvasElement).getContext('2d');

        let pixels = new Uint8ClampedArray(this.generateFullPixelImageData());
        if (pixels != null && pixels.length > 0) {
            let image = new ImageData(pixels, this.props.model.width, this.props.model.height);
            ctx.putImageData(image, 0, 0);
        }

    }

    private generateFullPixelImageData() {
        let currentScreenDataFlat = _.flatten(this.props.model.screen);
        let newData = _.flatten(this.fullblack);
        currentScreenDataFlat.forEach((x, i) => { newData[i] = x })
        return newData
    }


    render() {
        return (
            <canvas ref="canvas" width={640} height={480} />
        );
    }
}