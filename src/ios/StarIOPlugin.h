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

// http://docs.phonegap.com/en/2.8.0/guide_plugin-development_ios_index.md.html#Developing%20a%20Plugin%20on%20iOS

/*
 *
 *   - (void)myMethod:(CDVInvokedUrlCommand*)command;
 *
 */


#import <Foundation/Foundation.h>

#import <Cordova/CDVPlugin.h>
#import <StarIO/SMPort.h>
#import <StarIO_Extension/StarIoExtManager.h>

@interface StarIOPlugin : CDVPlugin <StarIoExtManagerDelegate> {}

@property (nonatomic) StarIoExtManager *starIoExtManager;

- (void)init:(CDVInvokedUrlCommand *)command;
- (void)portDiscovery:(CDVInvokedUrlCommand *)command;
- (void)checkStatus:(CDVInvokedUrlCommand *)command;
- (void)connect:(CDVInvokedUrlCommand *)command;
- (void)printReceipt:(CDVInvokedUrlCommand *)command;
@end
