cordova-wireless-network-information
======

To install this plugin, follow the [Command-line Interface Guide](http://cordova.apache.org/docs/en/edge/guide_cli_index.md.html#The%20Command-line%20Interface).

If you are not using the Cordova Command-line Interface, follow [Using Plugman to Manage Plugins](http://cordova.apache.org/docs/en/edge/plugin_ref_plugman.md.html).

Installation
--------

    $ cordova plugin add https://bitbucket.org/ThreeScreens/cordova-wireless-network-information

Properties
--------

- type {String}

Events
--------

- WWANOffline
- WWANOnline
- ConnectionTestFailed
- ConnectionTestSuccess

Example(s)
--------

Create an instance:

    var n = new navigator.wirelessConnection();
    console.log("Plugin network type is: ", n.type);
    
Event Listeners
	
	document.addEventListener("WWANOffline", yourCallbackFunction, false);
    document.addEventListener("WWANOnline", yourCallbackFunction, false);
    document.addEventListener("ConnectionTestSuccess", yourCallbackFunction, false);
    document.addEventListener("ConnectionTestFailed", yourCallbackFunction, false);

