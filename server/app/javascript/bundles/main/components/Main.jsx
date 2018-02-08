import React from 'react';
import PropTypes from 'prop-types';

import SubtitlesSelect from './SubtitlesSelect';
import WeightWidget from './WeightWidget';
import Output from './Output';

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
                    mode: 'LANG',
                    error: null,
                },
                sub2: {
                    name: '',
                    content: '',
                    mode: 'LANG',
                    error: null,
                },
                output: {
                    sub2Percentage: 50,
                    format: 'ASS',
                    error: null,
                },
            }
        };
    }

    setResult(id, key, value) {
        const result = this.state.result[id];
        result[key] = value;
        this.setState({[id]: result});
    };

    validate() {
        const result = this.state.result;
        const sub1 = result.sub1;
        const sub2 = result.sub2;
        const output = result.output;


        [sub1, sub2].forEach(sub => {
            sub.error = null;
            if (sub.name) {
                if (!sub.content || sub.content === 'data:') {
                    sub.error = "Select a non empty file";
                }
            } else {
                sub.error = "Select a file";
            }
        });

        this.setState({result: result});

        if (!sub1.error && !sub2.error && !output.error) {
            this.refs.mixData.value = JSON.stringify(this.state.result);
            this.refs.mixForm.submit();
        }
    }

    render() {
        return (
            <div className="container">
                <div id="description">
                    <h2>
                        Picks one subtitle at a time:
                    </h2>
                    <ul className="larger-font">
                        <li>
                            Randomly chosen based on weight
                        </li>
                        <li>
                            Or weighed based on your learned words <small className="smallNumber">(TBD)</small>
                        </li>
                    </ul>
                </div>
                <div className="row">
                    <div className="col-md-6">
                        <SubtitlesSelect name={"Language No. 1"}
                                         id={'sub1'}
                                         data={this.state.result.sub1}
                                         onChange={this.setResult.bind(this, 'sub1')}/>
                    </div>
                    <div className="col-md-6">
                        <SubtitlesSelect name={"Language No. 2"}
                                         id={'sub2'}
                                         data={this.state.result.sub2}
                                         onChange={this.setResult.bind(this, 'sub2')}/>
                    </div>
                </div>
                <hr/>
                <div className="row">
                    <div className="col-md-6 col-md-offset-3">
                        <WeightWidget id={'output'}
                                      data={this.state.result.output}
                                      onChange={this.setResult.bind(this, 'output')}/>
                    </div>
                </div>
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
