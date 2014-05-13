
var exec     = require('cordova/exec'),
	cordova  = require('cordova'),
	channel  = require('cordova/channel'),
	channel2 = require('cordova/channel'),
	utils    = require('cordova/utils');

var WirelessNetworkConnection = function() {
	this.type = 'unknown';
};

WirelessNetworkConnection.prototype.getType = function(successCallback, errorCallback) {
	exec(successCallback, errorCallback, "WirelessNetworkInfo", "getCurrentAccessTechnology", []);
};

//post to URL and check for 200 status
WirelessNetworkConnection.prototype.testConnectivity = function(url, successCallback, errorCallback) {
	exec(successCallback, errorCallback, "WirelessNetworkInfo", "testServerConnectivity", [url]);
};

channel.createSticky('onCordovaWirelessConnectionReady');
channel.waitForInitialization('onCordovaWirelessConnectionReady');

channel2.createSticky('onCordovaConnectionTestReady');
channel2.waitForInitialization('onCordovaConnectionTestReady');

channel.onCordovaReady.subscribe(function() {
	var timerId = null,
		me = wirelessnetworkconnection;
	me.getType(function(type) {
		me.type = type;
		if (type === null){
			timerId = setTimeout(function(){
				cordova.fireDocumentEvent("WWANOffline");
				console.log('WWANOffline')
				timerId = null;
			}, 5000);
		} else {
			if (timerId !== null) {
				clearTimeout(timerId);
				timerId = null;
			}
			cordova.fireDocumentEvent("WWANOnline");
			console.log('WWANOnline')
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
	var timerId = null,
		me = wirelessnetworkconnection;
	me.testConnectivity('http://field-agent.net/api/echo?Message=ping', function(online) {
		if (online === false){
			timerId = setTimeout(function(){
				cordova.fireDocumentEvent("ConnectionTestFailed");
				console.log('ConnectionTestFailed')
				timerId = null;
			}, 5000);
		} else {
			if (timerId !== null) {
				clearTimeout(timerId);
				timerId = null;
			}
			cordova.fireDocumentEvent("ConnectionTestSuccess");
			console.log('ConnectionTestSuccess')
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

var wirelessnetworkconnection = new WirelessNetworkConnection();

module.exports = WirelessNetworkConnection;
