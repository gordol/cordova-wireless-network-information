
var exec = require('cordova/exec'),
    cordova = require('cordova'),
    channel = require('cordova/channel'),
    channel2 = require('cordova/channel'),
    utils = require('cordova/utils');

function WirelessNetworkConnection() {
    this.type = 'unknown';
}

WirelessNetworkConnection.prototype.getType = function(successCallback, errorCallback) {
    exec(successCallback, errorCallback, "WirelessNetworkInfo", "getCurrentAccessTechnology", []);
};

//post to URL and check for 200 status
WirelessNetworkConnection.prototype.testConnectivity = function(url, successCallback, errorCallback) {
    exec(successCallback, errorCallback, "WirelessNetworkInfo", "testServerConnectivity", [url]);
};

var me = new WirelessNetworkConnection();

channel.createSticky('onCordovaWirelessConnectionReady');
channel.waitForInitialization('onCordovaWirelessConnectionReady');

channel2.createSticky('onCordovaConnectionTestReady');
channel2.waitForInitialization('onCordovaConnectionTestReady');

channel.onCordovaReady.subscribe(function() {
	var timerId = null;
    me.getType(function(type) {
        me.type = type;
        if (type === null){
            timerId = setTimeout(function(){
                cordova.fireDocumentEvent("WWANOffline");
                timerId = null;
            }, 500);
        } else {
            if (timerId !== null) {
                clearTimeout(timerId);
                timerId = null;
            }
            cordova.fireDocumentEvent("WWANOnline");
        }

        if (channel.onCordovaWirelessConnectionReady.state !== 2) {
            channel.onCordovaWirelessConnectionReady.fire();
        }
    },
    function (e) {
        if (channel.onCordovaWirelessConnectionReady.state !== 2) {
            channel.onCordovaWirelessConnectionReady.fire();
        }
        console.log("Error initializing wireless network connection: " + e);
    });
});

channel2.onCordovaReady.subscribe(function() {
	var timerId = null;
    me.testConnectivity('http://field-agent.net/api/echo?Message=ping', function(online) {
        if (online === false){
            timerId = setTimeout(function(){
                cordova.fireDocumentEvent("ConnectionTestFailed");
                timerId = null;
            }, 500);
        } else {
            if (timerId !== null) {
                clearTimeout(timerId);
                timerId = null;
            }
            cordova.fireDocumentEvent("ConnectionTestSuccess");
        }

        if (channel2.onCordovaConnectionTestReady.state !== 2) {
            channel2.onCordovaConnectionTestReady.fire();
        }
    },
    function (e) {
        if (channel2.onCordovaConnectionTestReady.state !== 2) {
            channel2.onCordovaConnectionTestReady.fire();
        }
        console.log("Error testing wireless connectivity: " + e);
    });
});

module.exports = me;
