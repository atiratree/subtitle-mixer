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
    }

    onFormatChange(e) {
        this.props.onChange('format', e.target.value);
    }

    render() {
        const data = this.props.data;

        return (
            <div id={this.props.id}>
                <h3 className="output-header">
                    Output
                </h3>
                <div className="row">
                        <div className="form-group">
                            <label>
                                Format
                            </label>
                            <select className="form-control" onChange={this.onFormatChange} defaultValue={data.format}>
                                <option>SRT</option>
                                <option>ASS</option>
                            </select>
                        </div>
                    </div>
            </div>
        );
    }
}
