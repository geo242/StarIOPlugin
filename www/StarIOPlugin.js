
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

module.exports = new StarIOPlugin();
