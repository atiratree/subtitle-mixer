import PropTypes from 'prop-types';
import React from 'react';

export default class SubtitlesSelect extends React.Component {
    static propTypes = {
        name: PropTypes.string.isRequired,
        id: PropTypes.string.isRequired,
        data: PropTypes.object.isRequired,
        onChange: PropTypes.func,
    };

    constructor(props) {
        super(props);

        this.setResult = this.setResult.bind(this);
        this.onNewFileEvent = this.onNewFileEvent.bind(this);
        this.id = this.id.bind(this);
    }

    onNewFileEvent(e) {
        if (e.target.files.length > 0) {
            const file = e.target.files[0];
            this.setResult('name', file.name);
            let reader = new FileReader();
            reader.onload = (e) => {
                this.setResult('content', e.target.result);
            };
            reader.readAsText(file);
        }
    }

    setResult(key, value) {
        this.props.onChange(key, value)
    }


    id(value) {
        return `${this.props.id}-${value}`
    }


    render() {
        const data = this.props.data;
        const id = this.id;

        let errorLabel = null;
        if (data.error) {
            errorLabel = (
                <label className="error-label text-danger">
                    <strong>
                        {data.error}
                    </strong>
                </label>
            )
        }

        return (
            <div id={this.props.id}>
                <h3 className="sub-header">
                    {this.props.name}
                </h3>
                <div className="form-horizontal">
                    <div className="form-group">
                        <label htmlFor={id("file")} className="col-sm-3  control-label">
                            Upload File
                        </label>
                        <div className="input-append">
                            <input id={id("file-name")}
                                   type="text"
                                   className="no-right-border span2"
                                   readOnly="readonly"
                                   value={ data.name }/>
                            <span className="add-on">
                                <label className="btn btn-default browse-button">
                                    Browse<input type="file" className="hide" id={id("file")}
                                                 onChange={this.onNewFileEvent}/>
                                </label>
                            </span>
                        </div>
                    </div>
                    {errorLabel}
                </div>
            </div>
        );
    }
}
