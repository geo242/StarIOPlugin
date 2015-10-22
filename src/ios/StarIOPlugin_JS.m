/*
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
 *      CDVPlugin
 *      CDVPlugin Template Created 05/09/2015.
 *      Copyright 2013 @RandyMcMillan
 *
 *     Created by Younes on 05/09/2015.
 *     Copyright __MyCompanyName__ 2015. All rights reserved.
 */

#import "StarIOPlugin_JS.h"

@implementation StarIOPlugin_JS

// Remove line breaks/returns to use as one constant string!
// Yes you can inject self executing functions into the webView!
NSString *const kCDVPluginINIT		= @"(function() {console.log('kCDVPluginINIT evaluated!');})();";
NSString *const kCDVPluginFUNCTION = @"(function() {console.log('kCDVPluginFUNCTION evaluated!');})();";
// REF http://docs.phonegap.com/en/2.3.0/cordova_notification_notification.md.html#Notification
// NSString *const kCDVPluginALERT = @"navigator.notification.alert('Cordova  CDVPlugin Plugin is working!')";
NSString *const kCDVPluginALERT = @"window.alert('MESSAGE CDVPlugin_JS.m LINE:37',alertDismissed,'Event Create & Saved','OK');";

@end
