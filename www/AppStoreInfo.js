var exec = require('cordova/exec');

exports.appInfo = function (success, error) {
    exec(success, error, 'AppStoreInfo', 'appInfo');
};
