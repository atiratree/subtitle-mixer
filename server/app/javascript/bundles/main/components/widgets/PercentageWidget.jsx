import PropTypes from 'prop-types';
import React from 'react';
import ReactBootstrapSlider from 'react-bootstrap-slider'

export default class PercentageWidget extends React.Component {
    static propTypes = {
        id: PropTypes.string.isRequired,
        percentage: PropTypes.number.isRequired,
        onChange: PropTypes.func.isRequired,
        leftLabel: PropTypes.string,
        rightLabel: PropTypes.string,
        label: PropTypes.string,
    };

    constructor(props) {
        super(props);

        this.onSliderChange = this.onSliderChange.bind(this);
    }

    onSliderChange(e) {
        this.props.onChange(e.target.value);
    }

    render() {
        const props = this.props;
        const percentage = props.percentage;
        const leftPercentage = 100 - percentage;

        const left = props.leftLabel ? (
            <label className="left-percentage">
                <small className="smallNumber">{props.leftLabel}</small>
                {` ${leftPercentage}%`}
            </label>
        ) : null;

        const right = props.leftLabel ? (
            <label className="right-percentage">
                {`${percentage}% `}
                <small className="smallNumber">(No. 2)</small>
            </label>
        ) : null;

        const header = props.label ? (
            <div>
                <label>
                    {props.label}
                </label>
                <br/>
            </div>
        ) : null;

        return (
            <div id={this.props.id} className="text-center form-group">
                {header}
                {left}
                <ReactBootstrapSlider
                    value={percentage}
                    change={this.onSliderChange}
                    slideStop={this.onSliderChange}
                    step={1}
                    max={100}
                    min={0}
                    tooltip="hide"
                    orientation="horizontal"/>
                {right}
            </div>
        );
    }
}
