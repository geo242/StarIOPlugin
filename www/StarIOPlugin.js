cordova.define("fr.sellsy.StarIOPlugin", function(require, exports, module) { /*
 *   Licensed to the Apache Software Foundation (ASF) under one
 *   or more contributor license agreements.  See the NOTICE file
 *   distributed with this work for additional information
 *   regarding copyright ownership.  The ASF licenses this file
 *   to you under the Apache License, Version 2.0 (the
 *   "License"); you may not use this file except in compliance
 *   with the License.  You may obtain a copy of the License at
 *
 *   http://www.apache.org/licenses/LICENSE-2.0
 *
 *   Unless required by applicable law or agreed to in writing,
 *   software distributed under the License is distributed on an
 *   "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
 *   KIND, either express or implied.  See the License for the
 *   specific language governing permissions and limitations
 *   under the License.
 *
 *      SellsyStarIO
 *      SellsyStarIO Template Created 05/09/2015.
 *      Copyright 2013 @RandyMcMillan
 *
 *     Created by Younes on 05/09/2015.
 *     Copyright __MyCompanyName__ 2015. All rights reserved.
 */

//(function () {

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


  module.exports = new StarIOPlugin();
  
  /*
  SellsyStarIO.install = function () {
    alert("install");
    if (!window.plugins) {
      window.plugins = {};
    }
    if (!window.plugins.SellsyStarIO) {
      window.plugins.SellsyStarIO = new SellsyStarIO();
    }
  }

  if (cordovaRef && cordovaRef.addConstructor) {
    cordovaRef.addConstructor(SellsyStarIO.install);
  } else {
    console.log("SellsyStarIO Cordova Plugin could not be installed.");
    return null;
  }*/


//})();
});
