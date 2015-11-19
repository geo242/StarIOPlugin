function StarIOPlugin() {}

StarIOPlugin.prototype.checkStatus = function (port, callback) {
    cordova.exec(function(result) {
            callback(null, result)
        },
        function(error) {
            callback(error)
        }, 'StarIOPlugin', 'checkStatus', [port]);
}


StarIOPlugin.prototype.portDiscovery = function (type, callback) {
    type = type || 'All';
    cordova.exec(function(result) {
            callback(null, result)
        },
        function(error) {
            callback(error)
        }, 'StarIOPlugin', 'portDiscovery', [type]);
}

StarIOPlugin.prototype.printReceipt = function (port, receipt, callback) {
    cordova.exec(function(result) {
            callback(null, result)
        },
        function(error) {
            callback(error)
        }, 'StarIOPlugin', 'printReceipt', [port, receipt]);
}

StarIOPlugin.prototype.openCashDrawer = function (port, callback) {
    cordova.exec(function(result) {
            callback(null, result)
        },
        function(error) {
            callback(error)
        }, 'StarIOPlugin', 'openCashDrawer', [port]);
}

StarIOPlugin.prototype.connect = function (port, callback) {
    var connected = false;
    cordova.exec(function (result) {
            //On initial connection - fire callback, otherwise fire a window event
            if (!connected) {
                callback(null, result);
                connected = true;
            } else {
                //This event will be to notify of events like barcode scans
                cordova.fireWindowEvent("starIOPluginData", result);
            }
        },
        function (error) {
            callback(error)
        }, 'StarIOPlugin', 'connect', [port]);
}