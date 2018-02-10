import PropTypes from 'prop-types';
import React from 'react';

import PercentageWidget from '../widgets/PercentageWidget';
import FileSelect from '../widgets/FileSelect';

import {STUDY} from "../../../common/constants";
import {id as id2} from "../../../common/utils";

let id = null;

export default class SubtitlesSelect extends React.Component {
    static propTypes = {
        name: PropTypes.string.isRequired,
        id: PropTypes.string.isRequired,
        data: PropTypes.object.isRequired,
        onChange: PropTypes.func.isRequired,
    };

    constructor(props) {
        super(props);
        this.setResult = this.setResult.bind(this);
        this.onNewFileEvent = this.onNewFileEvent.bind(this);
        this.onConsiderBellowThresholdChange = this.onConsiderBellowThresholdChange.bind(this);
        id = id2.bind(this.props.id);
    }

    setResult(key, value) {
        this.props.onChange(key, value)
    }

    onNewFileEvent(id, nameId, e) {
        if (e.target.files.length > 0) {
            // clear old content first
            this.setResult('error', null);
            this.setResult(id, null);
            this.setResult(nameId, null);
            const file = e.target.files[0];
            if (file.size > 30 * 1024 * 1024) {
                this.setResult('error', "Only files of size 30 MiB and less are supported");
                return
            }
            this.setResult(nameId, file.name);
            let reader = new FileReader();

            reader.onload = (e) => {
                this.setResult(id, e.target.result);
            };
            reader.readAsDataURL(file);
        }
    }

    onConsiderBellowThresholdChange(e) {
        this.setResult('considerBelowThreshold', e.target.checked);
    }

    render() {
        const data = this.props.data;
        const study = data.mode === STUDY;

        let errorLabel = null;
        let wordListAddon = null;

        if (data.error) {
            errorLabel = (
                <label className="text-danger">
                    <strong>
                        {data.error}
                    </strong>
                </label>
            )
        }

        if (study) {
            const consider = `Consider subs even bellow ${data.wordsPercentageThreshold}%`
            wordListAddon = (
                <div>
                    <hr/>
                    <FileSelect id={id("words-file")}
                                name={data.wordsName}
                                labelText="Learned words"
                                buttonText="Upload Words"
                                onNewFile={this.onNewFileEvent.bind(this, 'wordsContent', 'wordsName')}/>
                    <PercentageWidget id={id("percentage-threshold")}
                                      percentage={data.wordsPercentageThreshold}
                                      onChange={this.setResult.bind(this, 'wordsPercentageThreshold')}
                                      label= {`Pick sentences where at least ${data.wordsPercentageThreshold}% words are recognized`}
                                      showTopPercentage={true}/>
                    <div className="form-group">
                        <label className="control-label">
                            {consider}
                        </label>
                        <div className="checkbox">
                            <label>
                                <input className="checkbox" type="checkbox" onChange={this.onConsiderBellowThresholdChange}
                                       defaultChecked={data.considerBelowThreshold}/>
                            </label>
                        </div>
                    </div>
                </div>
            )
        }

        return (
            <div className="text-center" id={this.props.id}>
                <h3 className="sub-header">
                    {this.props.name}
                </h3>
                <div className="form-horizontal">
                    <FileSelect id={id("sub-file")}
                                name={data.name}
                                buttonText="Upload Subtitles"
                                onNewFile={this.onNewFileEvent.bind(this, 'content', 'name')}/>
                    {wordListAddon}
                </div>
                {errorLabel}
            </div>
        );
    }
}
