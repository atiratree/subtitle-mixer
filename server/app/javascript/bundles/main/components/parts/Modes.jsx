import PropTypes from 'prop-types';
import React from 'react';
import {LANG, STUDY} from "../../../common/constants";

export default class SubtitlesSelect extends React.Component {
    static propTypes = {
        id: PropTypes.string.isRequired,
        mode: PropTypes.string.isRequired,
        onChangeMode: PropTypes.func.isRequired,
    };

    constructor(props) {
        super(props);

        this.onModeChange = this.onModeChange.bind(this);
    }

    onModeChange(e) {
        this.props.onChangeMode(e.target ? e.target.value : e);
    }

    render() {
        const mode = this.props.mode;
        return (
            <div id={this.props.id}>
                <div id="description" className="description-area bigger-font">
                    <h3>
                        Choose how much of each language you want to see:
                    </h3>
                    <ul className="no-icon-list">
                        <li>
                            <div className="form-check">
                                <input className="form-check-input check" type="radio" name="mode-radios"
                                       id="lang-radio"
                                       checked={mode === LANG}
                                       onChange={this.onModeChange}
                                       value={LANG}/>
                                <label className="form-check-label no-bold-label"
                                       htmlFor="exampleRadios1"
                                       onClick={this.onModeChange.bind(this, LANG)}>
                                    <b>Mix: </b>
                                    subs randomly picked based on the percentage
                                </label>
                            </div>
                        </li>
                        <li>
                            <div className="form-check">
                                <input className="form-check-input" type="radio" name="mode-radios"
                                       id="study-radio"
                                       checked={mode === STUDY}
                                       onChange={this.onModeChange}
                                       value={STUDY}/>
                                <label className="form-check-label no-bold-label"
                                       htmlFor="exampleRadios2"
                                       onClick={this.onModeChange.bind(this, STUDY)}>
                                    <b>Study: </b>
                                    subs picked based on your learned words
                                </label>
                            </div>
                        </li>
                    </ul>
                </div>
            </div>
        );
    }
}
