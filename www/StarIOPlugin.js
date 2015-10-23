
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

  StarIOPlugin.prototype.printReceipt = function (port, callback) {
      cordova.exec(function(result) {
                    callback(null, result)
                   },
                   function(error) {
                    callback(error)
                   }, 'StarIOPlugin', 'printReceipt', [port, []]);
  }


if (!window.plugins) {
  window.plugins = {};
}
if (!window.plugins.country) {
  window.plugins.country = new StarIOPlugin();
}

if (module.exports) {
  module.exports = StarIOPlugin;
}
