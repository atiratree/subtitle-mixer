import PropTypes from 'prop-types';
import React from 'react';

export default class Main extends React.Component {
    static propTypes = {
        name: PropTypes.string, // this is passed from the Rails view
    };

    constructor(props) {
        super(props);

        this.updateName = this.updateName.bind(this);

        this.state = {
            name: this.props.name ? this.props.name : 'World'
        };
    }

    updateName = (name) => {
        this.setState({name});
    };

    render() {
        const v = "Hello " + this.state.name;
        console.log(v);

        return (
            <div>
                <h1>
                    {v}
                </h1>
                <form  role='form' acceptCharset="UTF-8" action='/mix' method='post'>
                    <input type='hidden' name='authenticity_token' value={this.props.authenticity_token} />
                    <input
                        id="name"
                        name='name[name]'
                        type="text"
                        value={this.state.name}
                        onChange={(e) => this.updateName(e.target.value)}/>
                </form>
            </div>
        );
    }
}
