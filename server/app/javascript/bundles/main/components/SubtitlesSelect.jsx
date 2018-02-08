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
            // clear old content first
            this.setResult('error', null);
            this.setResult('content', null);
            this.setResult('name', null);
            const file = e.target.files[0];
            if (file.size > 5 * 1024 * 1024) {
                this.setResult('error', "Only files 5 MiB and less are supported");
                return
            }
            this.setResult('name', file.name);
            let reader = new FileReader();

            reader.onload = (e) => {
                this.setResult('content', e.target.result);
            };
            reader.readAsDataURL(file);
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
                <label className="text-danger">
                    <strong>
                        {data.error}
                    </strong>
                </label>
            )
        }

        return (

            <div className="row" id={this.props.id}>
                <div className="col-md-6 col-md-offset-3 text-center">
                    <h3 className="sub-header">
                        {this.props.name}
                    </h3>
                    <div className="form-horizontal">
                        <div className="form-group">
                            <label htmlFor={id("file")} className="control-label browse-label">
                                Upload File
                            </label>
                            <input id={id("file-name")}
                                   type="text"
                                   className="form-control"
                                   readOnly="readonly"
                                   value={data.name}/>
                            <label className="btn btn-default browse-button">
                                Browse<input type="file" className="hide" id={id("file")}
                                             onChange={this.onNewFileEvent}/>
                            </label>
                        </div>
                    </div>
                    {errorLabel}
                </div>
            </div>
        );
    }
}
