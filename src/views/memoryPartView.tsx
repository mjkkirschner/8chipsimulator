import * as React from 'react';
import * as ReactDOM from 'react-dom';
import { Ipart } from '../primitives';
import { outputPin } from '../pins_wires';
import { Imemory } from '../sram';
import * as _ from 'underscore';
import { Grid } from 'react-virtualized';

export interface ImemoryDataProps {
    model: Imemory
}

export class MemoryDataView extends React.Component<ImemoryDataProps> {

    private chunkedData: Array<Array<number>>

    constructor(props: ImemoryDataProps) {
        super(props);
        this.state = {};
        this.chunkedData = _.chunk(this.props.model.data.map((x) => this.boolsToInt(x as any)), 8) as [][];

    }
    protected boolsToInt(values: Boolean[]) {
        return parseInt(values.map(value => { return Number(value) }).join(""), 2);
    }


    protected dataStyle(data: number, index: number) {


        let style = {
            backgroundColor: "rgba(224,103,103,.71)",
            padding: '0 4px',
            borderWidth: "1px",
            fontFamily: 'system-ui',
            "textAlign": "center" as "center",
        }

        if (data) {
            style.backgroundColor = "#DAF7A6";
        }

        let addressToRead = parseInt(this.props.model.addressPins.map(pin => { return Number(pin.value) }).join(""), 2);

        if (addressToRead == index) {
            style.backgroundColor = "#F43FF7";
        }

        return style;
    }

    protected cellRenderer(options: { columnIndex: number, key: string, rowIndex: number, style: React.CSSProperties }) {
        let data = this.chunkedData[options.rowIndex][options.columnIndex];
        let flatIndex = options.rowIndex * 8 + options.columnIndex;
        return (
            <div key={options.key}
                style={{ ...options.style, ...this.dataStyle(data, flatIndex) }}
            >
                {data}
            </div>
        )
    }


    public render() {
        //this.chunkedData = _.chunk(this.props.model.data.map((x) => this.boolsToInt(x as any)), 8) as [][];

        return (<Grid
            cellRenderer={this.cellRenderer.bind(this)}
            columnCount={this.chunkedData[0].length}
            columnWidth={35}
            height={300}
            rowCount={this.chunkedData.length}
            width={400}
            rowHeight={10}
        />)
    }
}
