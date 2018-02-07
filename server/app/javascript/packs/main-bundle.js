import ReactOnRails from 'react-on-rails';

import'../bundles/main/styles/Main.scss';

import Main from '../bundles/main/components/Main';

// This is how react_on_rails can see the Main in the browser.
ReactOnRails.register({
    Main
});
