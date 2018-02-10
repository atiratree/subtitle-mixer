import PropTypes from 'prop-types';
import React from 'react';
import {ASS, SRT} from "../../../common/constants";
import {digitFilter} from "../../../common/utils";

export default class SubtitlesSelect extends React.Component {
    static propTypes = {
        id: PropTypes.string.isRequired,
        data: PropTypes.object.isRequired,
        onChange: PropTypes.func,
    };

    constructor(props) {
        super(props);

        this.onFormatChange = this.onFormatChange.bind(this);
        this.onPersistFormattingChange = this.onPersistFormattingChange.bind(this);
        this.onFontSizeChange = this.onFontSizeChange.bind(this);
    }

    onFormatChange(e) {
        this.props.onChange('format', e.target.value);
    }

    onPersistFormattingChange(e) {
        this.props.onChange('persistFormatting', e.target.checked);
    }

    onFontSizeChange(e) {
        this.props.onChange('fontSize', e.target.value);
    }

    render() {
        const data = this.props.data;

        const fontSize = data.format === ASS ? (
            <div className="form-group">
                <label className="col-sm-5 control-label" htmlFor="font-size">
                    Font Size
                </label>
                <div className="col-sm-5 text-center">
                    <input className="form-control" id="font-size"
                           type="number"
                           onChange={this.onFontSizeChange}
                           defaultValue={data.fontSize}
                           onKeyPress={digitFilter}
                           step={1}
                           min={0}/>
                </div>
            </div>
        ) : null;

        return (
            <div id={this.props.id}>
                <h3 className="output-header">
                    Output
                </h3>
                <div className="form-horizontal">
                    <div className="form-group">
                        <label className="col-sm-5 control-label" htmlFor="format">
                            Format
                        </label>
                        <div className="col-sm-5 text-center">
                            <select id="format" className="form-control" onChange={this.onFormatChange}
                                    defaultValue={data.format}>
                                <option>{SRT}</option>
                                <option>{ASS}</option>
                            </select>
                        </div>
                    </div>
                    {fontSize}
                    <div className="form-group">
                        <label className="col-sm-5 control-label" htmlFor="persist-styles">
                            Persist Styles
                        </label>
                        <div className="col-sm-5 text-center">
                            <div className="checkbox">
                                <label>
                                    <input className="checkbox" type="checkbox" id="persist-styles"
                                           onChange={this.onPersistFormattingChange}
                                           defaultChecked={data.persistFormatting}/>
                                </label>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        );
    }
}
