import ReactOnRails from 'react-on-rails';

import'../bundles/result/styles/Result.scss';

import Result from '../bundles/result/components/Result';

// This is how react_on_rails can see the Main in the browser.
ReactOnRails.register({
    Result
});
