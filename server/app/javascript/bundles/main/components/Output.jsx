import PropTypes from 'prop-types';
import React from 'react';

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
    }

    onFormatChange(e) {
        this.props.onChange('format', e.target.value);
    }


    onPersistFormattingChange(e) {
        this.props.onChange('persistFormatting', e.target.checked);
    }

    render() {
        const data = this.props.data;

        return (
            <div id={this.props.id}>
                <h3 className="output-header">
                    Output
                </h3>
                <div className="form-horizontal">
                    <div className="form-group">
                        <label className="col-sm-5 control-label">
                            Format
                        </label>
                        <div className="col-sm-5 text-center">
                            <select className="form-control" onChange={this.onFormatChange} defaultValue={data.format}>
                                <option>SRT</option>
                                <option>ASS</option>
                            </select>
                        </div>
                    </div>
                    <div className="form-group">
                        <label className="col-sm-5 control-label">
                            Persist Styles
                        </label>
                        <div className="col-sm-5 text-center" >
                            <div className="checkbox">
                                <label>
                                    <input type="checkbox" onChange={this.onPersistFormattingChange} defaultChecked={data.persistFormatting}/>
                                </label>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        );
    }
}
