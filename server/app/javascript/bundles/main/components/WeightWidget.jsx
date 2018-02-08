import PropTypes from 'prop-types';
import React from 'react';
import ReactBootstrapSlider from 'react-bootstrap-slider'

export default class WeightWidget extends React.Component {

    static propTypes = {
        id: PropTypes.string.isRequired,
        data: PropTypes.object.isRequired,
        onChange: PropTypes.func,
    };

    constructor(props) {
        super(props);

        this.onSliderChange = this.onSliderChange.bind(this);
    }

    onSliderChange(e) {
        this.props.onChange('sub2Percentage', e.target.value);
    }

    render() {
        const data = this.props.data;
        const sub2Percentage = data.sub2Percentage;
        const sub1Percentage = 100 - sub2Percentage;

        return (
            <div id={this.props.id} className="text-center">
                <div className="form-group">
                    <label>
                        Weight
                    </label>
                    <br/>
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
            </div>
        );
    }
}
