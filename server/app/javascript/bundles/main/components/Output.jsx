import PropTypes from 'prop-types';
import React from 'react';
import ReactBootstrapSlider from 'react-bootstrap-slider'

export default class SubtitlesSelect extends React.Component {

    static propTypes = {
        id: PropTypes.string.isRequired,
        data: PropTypes.object.isRequired,
        onChange: PropTypes.func,
    };

    constructor(props) {
        super(props);

        this.onSliderChange = this.onSliderChange.bind(this);
        this.onFormatChange = this.onFormatChange.bind(this);
    }

    onSliderChange(e) {
        this.props.onChange('sub2Percentage', e.target.value);
    }

    onFormatChange(e) {
        this.props.onChange('format', e.target.value);
    }

    render() {
        const data = this.props.data;
        const sub2Percentage = data.sub2Percentage;
        const sub1Percentage = 100 - sub2Percentage;

        return (
            <div id={this.props.id}>
                <h2 className="output-header">
                    Output
                </h2>
                <br/>
                <div className="form-group">
                    <label className="left-percentage">
                        <small className="smallNumber">(No. 1)</small>
                        {` ${sub1Percentage}%`}
                    </label>
                    <ReactBootstrapSlider
                        value={sub2Percentage}
                        change={this.onSliderChange}
                        slideStop={this.onSliderChange}
                        step={1}
                        max={100}
                        min={0}
                        tooltip="hide"
                        orientation="horizontal"/>
                    <label className="right-percentage">
                        {`${sub2Percentage}% `}
                        <small className="smallNumber">(No. 2)</small>
                    </label>
                </div>
                <div className="row">
                    <div className="col-md-6 col-md-offset-3 text-center">
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
            </div>
        );
    }
}
