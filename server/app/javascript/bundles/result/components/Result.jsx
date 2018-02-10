import React from 'react';
import PropTypes from 'prop-types';
import download from 'downloadjs'

export default class Result extends React.Component {
    static propTypes = {
        name: PropTypes.string,
        base64Content: PropTypes.string,
        report: PropTypes.array.isRequired,
        error: PropTypes.string,
    };

    constructor(props) {
        super(props);
        if (!this.props.error) {
            download(this.props.base64Content, this.props.name)
        }
    }

    render() {
        const reported = (this.props.report.map((item, idx) => ( <li key={idx}>{item}</li>)));

        let errorLabel = null;
        if (this.props.error) {
            errorLabel = (
                <label className="error-label text-danger">
                    <strong>
                        {this.props.error}
                    </strong>
                </label>
            )
        }
        return (
            <div className="container">
                <div id="result">
                    <h2>
                        Result
                    </h2>
                    <ul className="larger-font">
                        {reported}
                    </ul>
                    {errorLabel}
                </div>
                <hr/>
                <div className="row">
                    <div className="col-md-6 col-md-offset-3 text-center">
                        <a href="/" className="btn btn-default btn-info">
                            Mix Again
                        </a>
                    </div>
                </div>
            </div>
        );
    }
}
