/// <reference path="../../node_modules/monaco-editor/monaco.d.ts" />

import React = require("react");

//class that draws a REPL
//this is used as a command line for interacting with the simulator / project.
export class CommandLineView extends React.Component<any> {

    private codeEditor: monaco.editor.IStandaloneCodeEditor

    constructor(props: any) {
        super(props);

    }

    componentDidMount() {

        setTimeout(() => {

            monaco.languages.typescript.javascriptDefaults.setDiagnosticsOptions({
                noSemanticValidation: true,
                noSyntaxValidation: false
            });

            // compiler options
            monaco.languages.typescript.javascriptDefaults.setCompilerOptions({
                target: monaco.languages.typescript.ScriptTarget.ES6,
                allowNonTsExtensions: true
            });

            // extra libraries
            monaco.languages.typescript.javascriptDefaults.addExtraLib([
                'declare function ',
            ].join('\n'), 'filename/facts.d.ts');


            this.codeEditor = monaco.editor.create(document.getElementById('consolecode'), {
                value: [
                    'function x() {',
                    '\tconsole.log("Hello world!");',
                    '}'
                ].join('\n'),
                language: 'javascript'
            });
        }, 200);
    };

    style = {
        color: '41474E',
        'backgroundColor': "#EEE",
        'borderStyle': 'solid',
        borderWidth: "1px",
        fontFamily: 'system-ui',
        width: "100%",
        height: "100%",
    }

    containerStyle = {

        width: "100%",
        height: "10%",
    }

    public render() {
        let eval2 = eval;
        return (
            <div style={this.containerStyle}>
                <div id="consolecode" style={this.style} >
                </div >
                <button style={{ float: 'right', position: "relative", top: "-50px", left: "-50px" }}
                    onClick={(data) => { eval2(this.codeEditor.getModel().getValue()) }} > "Evaluate" </button>
            </div>
        );
    }
}
