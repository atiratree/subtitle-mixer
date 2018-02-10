import PropTypes from 'prop-types';
import React from 'react';
import {id as id2} from "../../../common/utils";

let id = null;

export default class FileSelect extends React.Component {
    static propTypes = {
        id: PropTypes.string.isRequired,
        name: PropTypes.string.isRequired,
        buttonText: PropTypes.string.isRequired,
        labelText: PropTypes.string,
        onNewFile: PropTypes.func.isRequired,
    };

    constructor(props) {
        super(props);
        id = id2.bind(this.props.id);
    }

    render() {
        const label = this.props.labelText ? (
            <label htmlFor={id("file-input")}>
                {this.props.labelText}
            </label>
        ) : null;

        return (
            <div>
                {label}
                <div className="form-group file-select">
                    <div className="input-group">
                        <input id={id("file-name")}
                               type="text"
                               className="form-control file-select-name"
                               readOnly="readonly"
                               value={this.props.name}/>
                        <span className="input-group-btn" onClick={() => this.fileInput.click()}>
                            <button type="button" className="btn btn-default file-select-button">
                                {this.props.buttonText}
                            </button>
                        </span>
                        <input type="file" className="hide"
                               id={id("file-input")}
                               ref={(input) => {
                                   this.fileInput = input;
                               }}
                               onChange={this.props.onNewFile}/>
                    </div>
                </div>
            </div>
        );
    }
}
