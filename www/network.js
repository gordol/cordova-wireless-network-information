
var exec = require('cordova/exec'),
    cordova = require('cordova'),
    channel = require('cordova/channel'),
    utils = require('cordova/utils');

function WirelessNetworkConnection() {
    this.type = 'unknown';
}

WirelessNetworkConnection.prototype.getType = function(successCallback, errorCallback) {
    exec(successCallback, errorCallback, "WirelessNetworkInfo", "getCurrentAccessTechnology", []);
};

//posts requestBody to URL, and check for 200 status
WirelessNetworkConnection.prototype.testConnectivity = function(url, requestBody, successCallback, errorCallback) {
    exec(successCallback, errorCallback, "WirelessNetworkInfo", "getCurrentAccessTechnology", [url, requestBody]);
};

var me = new WirelessNetworkConnection();

channel.createSticky('onCordovaWirelessConnectionReady');
channel.waitForInitialization('onCordovaWirelessConnectionReady');

channel.onCordovaReady.subscribe(function() {
	var timerId = null;
    me.getType(function(type) {
        me.type = type;
        if (type === null){
            timerId = setTimeout(function(){
                cordova.fireDocumentEvent("WWANOffline");
                timerId = null;
            }, 5000);
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
        console.log("Error initializing Wireless Network Connection: " + e);
    });
});

channel.onCordovaReady.subscribe(function() {
	var timerId = null;
    me.testConnectivity('http://field-agent.net/api/echo?Message=ping', function(online) {
        if (online === false){
            timerId = setTimeout(function(){
                cordova.fireDocumentEvent("ConnectionTestFailed");
                timerId = null;
            }, 60000);
        } else {
            if (timerId !== null) {
                clearTimeout(timerId);
                timerId = null;
            }
            cordova.fireDocumentEvent("ConnectionTestSuccess");
        }

        if (channel.onCordovaWirelessConnectionReady.state !== 2) {
            channel.onCordovaWirelessConnectionReady.fire();
        }
    },
    function (e) {
        if (channel.onCordovaWirelessConnectionReady.state !== 2) {
            channel.onCordovaWirelessConnectionReady.fire();
        }
        console.log("Error initializing Wireless Network Connection: " + e);
    });
});

module.exports = me;
