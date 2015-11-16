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

#import <Cordova/CDVAvailability.h>
#import <Cordova/CDVViewController.h>
#import <Cordova/CDVDebug.h>

#import "StarIOPlugin.h"
#import "StarIOPlugin_JS.h"

#import <StarIO/SMPort.h>

@implementation StarIOPlugin

/*
 *
 *   - (void)myPluginMethod:(CDVInvokedUrlCommand*)command
 *   {
 *   // Check command.arguments here.
 *   [self.commandDelegate runInBackground:^{
 *   NSString* payload = nil;
 *   // Some blocking logic...
 *   CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:payload];
 *   // The sendPluginResult method is thread-safe.
 *   [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
 *   }];
 *   }
 *
 */
- (void)init:(CDVInvokedUrlCommand *)command
{
	NSLog(@"init called from %@!", [self class]);

	if (self.hasPendingOperation) {
		//        [self.commandDelegate runInBackground:^{NSLog(@"BackGround Thread sample code!");}];
		NSLog(@"%@.hasPendingOperation = YES", [self class]);
	} else {
		//        [self.commandDelegate runInBackground:^{NSLog(@"BackGround Thread sample code!");}];
		NSLog(@"%@.hasPendingOperation = NO", [self class]);
	}

	NSString	*systemVersion		= [[UIDevice currentDevice] systemVersion];
	BOOL		isLessThaniOS4		= ([systemVersion compare:@"4.0" options:NSNumericSearch] == NSOrderedAscending);
	BOOL		isGreaterThaniOS4	= ([systemVersion compare:@"4.0" options:NSNumericSearch] == NSOrderedDescending);
	BOOL		isLessThaniOS5		= ([systemVersion compare:@"5.0" options:NSNumericSearch] == NSOrderedAscending);
	BOOL		isGreaterThaniOS5	= ([systemVersion compare:@"5.0" options:NSNumericSearch] == NSOrderedDescending);
	BOOL		isLessThaniOS6		= ([systemVersion compare:@"6.0" options:NSNumericSearch] == NSOrderedAscending);
	BOOL		isEqualToiOS6		= ([systemVersion compare:@"6.0" options:NSNumericSearch] == NSOrderedSame);
	BOOL		isGreaterThaniOS6	= ([systemVersion compare:@"6.0" options:NSNumericSearch] == NSOrderedDescending);

	if (isLessThaniOS4 && isLessThaniOS5) {}

	if (isGreaterThaniOS4 && isLessThaniOS5) {}

	if (isGreaterThaniOS5 && isLessThaniOS6) {}

	if (isEqualToiOS6) {
		NSLog(@"isEqualToiOS6");
	}

	if (isGreaterThaniOS6) {
		NSLog(@"isGreaterThaniOS6");
	}

	NSString	*callbackId		= [command.arguments objectAtIndex:0];
	NSString	*objectAtIndex0 = [command.arguments objectAtIndex:0];

	CDVViewController	*mvcCDVPlugin = (CDVViewController *)[super viewController];
	CDVPluginResult		*result;

	// [self.commandDelegate runInBackground:^{NSLog(@"BackGround Thread sample code!");}];

	if ([objectAtIndex0 isEqualToString:@"success"]) {
		NSString *jsString = kCDVPluginINIT;
		[mvcCDVPlugin.webView stringByEvaluatingJavaScriptFromString:jsString];
		result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:@"Success! const kCDVPluginINIT was evaluated by webview!"];
        [self.commandDelegate sendPluginResult:result callbackId:callbackId];
	} else {NSLog(@"[command.arguments objectAtIndex:0] = %@", [command.arguments objectAtIndex:0]); }
}

- (void)nativeFunctionWithAlert:(CDVInvokedUrlCommand *)command
{
	NSLog(@"nativeFunctionWithAlert called from %@!", [self class]);

	if (self.hasPendingOperation) {
		NSLog(@"%@.hasPendingOperation = YES", [self class]);
	} else {
		//  [self.commandDelegate runInBackground:^{NSLog(@"BackGround Thread sample code!");}];
		NSLog(@"%@.hasPendingOperation = NO", [self class]);
	}

	// [self.commandDelegate runInBackground:^{NSLog(@"BackGround Thread sample code!");}];

	NSString	*callbackId		= [command.arguments objectAtIndex:0];
	NSString	*objectAtIndex0 = [command.arguments objectAtIndex:0];

	CDVViewController	*mvcCDVPlugin = (CDVViewController *)[super viewController];
	CDVPluginResult		*result;

	if ([objectAtIndex0 isEqualToString:@"literalString"]) {
		NSString *jsString = kCDVPluginALERT;
		[mvcCDVPlugin.webView stringByEvaluatingJavaScriptFromString:jsString];
		result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:@"Success! const kCDVPluginALERT was evaluated by webview and created alert!"];
        [self.commandDelegate sendPluginResult:result callbackId:callbackId];
	} else {NSLog(@"[command.arguments objectAtIndex:0] = %@", [command.arguments objectAtIndex:0]); }
}

- (void)nativeFunction:(CDVInvokedUrlCommand *)command
{
	NSLog(@"nativeFunction called from %@!", [self class]);

	if (self.hasPendingOperation) {
		// [self.commandDelegate runInBackground:^{NSLog(@"BackGround Thread sample code!");}];
		NSLog(@"%@.hasPendingOperation = YES", [self class]);
	} else {
		// [self.commandDelegate runInBackground:^{NSLog(@"BackGround Thread sample code!");}];
		NSLog(@"%@.hasPendingOperation = NO", [self class]);
	}

	[self.commandDelegate runInBackground:^{NSLog(@"BackGround Thread sample code!"); }];

	NSString	*objectAtIndex0 = [command.arguments objectAtIndex:0];

	CDVViewController	*mvcCDVPlugin = (CDVViewController *)[super viewController];
	CDVPluginResult		*result;

	if ([objectAtIndex0 isEqualToString:@"literalString"]) {
		NSString *jsString = kCDVPluginFUNCTION;
		[mvcCDVPlugin.webView stringByEvaluatingJavaScriptFromString:jsString];
		result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:@"Success! const kCDVPluginFUNCTION was evaluated by webview!"];
        [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
	} else {NSLog(@"[command.arguments objectAtIndex:0] = %@", [command.arguments objectAtIndex:0]); }
}

- (NSMutableDictionary*)portInfoToDictionary:(PortInfo *)portInfo {
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setObject:[portInfo portName] forKey:@"portName"];
    [dict setObject:[portInfo macAddress] forKey:@"macAddress"];
    [dict setObject:[portInfo modelName] forKey:@"modelName"];
    [dict setObject:[portInfo isConnected] ? @"true" : @"false" forKey:@"isConnected"];
    return dict;
}

- (void)portDiscovery:(CDVInvokedUrlCommand *)command {
    NSLog(@"Finding ports");
    
	NSString *portType = @"All";
    
    if (command.arguments.count > 0) {
        portType = [command.arguments objectAtIndex:0];
    }
    
    NSMutableArray *info = [[NSMutableArray alloc] init];
    
    if ([portType isEqualToString:@"All"] || [portType isEqualToString:@"Bluetooth"]) {
        NSArray *btPortInfoArray = [SMPort searchPrinter:@"BT:"];
        for (PortInfo *p in btPortInfoArray) {
            [info addObject:[self portInfoToDictionary:p]];
        }
    }
    
    if ([portType isEqualToString:@"All"] || [portType isEqualToString:@"LAN"]) {
        NSArray *lanPortInfoArray = [SMPort searchPrinter:@"LAN:"];
        for (PortInfo *p in lanPortInfoArray) {
//            [info addObject:(PortInfo *)p];
               [info addObject:[self portInfoToDictionary:p]];
        }
    }
    
    if ([portType isEqualToString:@"All"] || [portType isEqualToString:@"USB"]) {
        NSArray *usbPortInfoArray = [SMPort searchPrinter:@"USB:"];
        for (PortInfo *p in usbPortInfoArray) {
//            [info addObject:(PortInfo *)p];
               [info addObject:[self portInfoToDictionary:p]];
        }
    }
    
    
    CDVPluginResult	*result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsArray:info];
 
    NSLog(@"Sending ports result");
    [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
}

- (void)handleOpenURL:(NSNotification *)notification
{
	NSLog(@"%@ handleOpenURL!", [self class]);
}

- (void)onAppTerminate
{
	NSLog(@"%@ onAppTerminate!", [self class]);
}

- (void)onMemoryWarning
{
	NSLog(@"%@ onMemoryWarning!", [self class]);
}

- (void)onReset
{
	NSLog(@"%@ onReset!", [self class]);
}

- (void)dispose
{
	NSLog(@"%@ dispose!", [self class]);
}

@end
