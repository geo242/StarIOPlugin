
  function StarIOPlugin() {}


  /*
  SellsyStarIO.prototype.checkStatus = function (success, fail, object) {
    cordova.exec(success, fail, 'SellsyStarIO', 'checkStatus', [object]);
  }*/

  StarIOPlugin.prototype.checkStatus = function (port, callback) {
      cordova.exec(function(result) {
                    callback(null, result)
                   },
                   function(error) {
                    callback(error)
                   }, 'StarIOPlugin', 'checkStatus', [port]);
  }


  StarIOPlugin.prototype.portDiscovery = function (callback) {
      cordova.exec(function(result) {
                    callback(null, result)
                   },
                   function(error) {
                    callback(error)
                   }, 'StarIOPlugin', 'portDiscovery', []);
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
