import React from 'react';
import PropTypes from 'prop-types';

import PercentageWidget from './widgets/PercentageWidget';
import SubtitlesSelect from './parts/SubtitlesSelect';
import Output from './parts/Output';
import Modes from './parts/Modes';
import {ASS, LANG, STUDY} from "../../common/constants";

export default class Main extends React.Component {
    static propTypes = {
        authenticity_token: PropTypes.string.isRequired, // this is passed from the Rails view
    };

    constructor(props) {
        super(props);

        this.setResult = this.setResult.bind(this);
        this.validate = this.validate.bind(this);

        this.state = {
            result: {
                sub1: {
                    name: '',
                    content: '',
                    mode: LANG,
                    error: null,
                },
                sub2: {
                    name: '',
                    content: '',
                    mode: LANG,
                    error: null,
                    wordsName: '',
                    wordsContent: '',
                    wordsPercentageThreshold: 66,
                    considerBelowThreshold: false,
                },
                output: {
                    sub2Percentage: 50,
                    format: ASS,
                    fontSize: 45,
                    persistFormatting: false,
                    error: null,
                },
            }
        };
    }

    setResult(id, key, value) {
        const result = this.state.result;
        result[id][key] = value;
        this.setState({result: result});
    };

    validate() {
        const result = this.state.result;
        const sub1 = result.sub1;
        const sub2 = result.sub2;
        const output = result.output;

        const validateFile = (sub, name, content, type) => {
            if (name) {
                if (!content || content === 'data:') {
                    sub.error = `Select a non empty ${type} file`;
                }
            } else {
                sub.error = `Select a ${type} file`;
            }
        };

        [sub1, sub2].forEach(sub => {
            sub.error = null;

            if (sub.mode === STUDY) {
                validateFile(sub, sub.wordsName, sub.wordsContent, 'words');
            }
            validateFile(sub, sub.name, sub.content, 'subtitles');
        });

        this.setState({result: result});

        if (!sub1.error && !sub2.error && !output.error) {
            this.refs.mixData.value = JSON.stringify(this.state.result);
            this.refs.mixForm.submit();
        }
    }

    render() {
        const study = this.state.result.sub2.mode === STUDY;
        let weightWidget = null;

        if (!study) {
            weightWidget = (
                <div className="row">
                    <div className="col-md-6 col-md-offset-3">
                        <PercentageWidget id={'wight'}
                                          percentage={this.state.result.output.sub2Percentage}
                                          onChange={this.setResult.bind(this, 'output', 'sub2Percentage')}
                                          label="Weight"
                                          leftLabel="(No. 1)"
                                          rightLabel="(No. 2)"/>
                    </div>
                </div>
            )
        }

        return (
            <div className="container">
                <Modes id={'modes'}
                       mode={this.state.result.sub2.mode}
                       onChangeMode={(mode) => this.setResult('sub2', 'mode', mode)}/>
                <div className="row">
                    <div className="col-sm-4 col-sm-offset-1">
                        <SubtitlesSelect name={"Language No. 1"}
                                         id={'sub1'}
                                         data={this.state.result.sub1}
                                         onChange={this.setResult.bind(this, 'sub1')}/>
                    </div>
                    <div className="col-sm-4 col-sm-offset-2">
                        <SubtitlesSelect name={"Language No. 2"}
                                         id={'sub2'}
                                         data={this.state.result.sub2}
                                         onChange={this.setResult.bind(this, 'sub2')}/>
                    </div>
                </div>
                {study ? null : (<hr/>)}
                {study ? null : weightWidget}
                <hr/>
                <div className="row">
                    <div className="col-md-4 col-md-offset-4">
                        <Output id={'output'}
                                data={this.state.result.output}
                                onChange={this.setResult.bind(this, 'output')}/>
                    </div>
                </div>
                <hr/>
                <div className="row" id="mix-area">
                    <div className="col-md-6 col-md-offset-3 text-center">
                        <form ref="mixForm"
                              role='form' acceptCharset="UTF-8"
                              action='/mix' method='post'>
                            <input type='hidden' name='authenticity_token'
                                   value={this.props.authenticity_token}/>
                            <input ref="mixData" type='hidden' name='data'/>
                        </form>
                        <button id="submit" className="btn btn-default btn-info" onClick={this.validate}>
                            Mix Subtitles
                        </button>
                    </div>
                </div>
            </div>
        );
    }
}
