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
#import "StarIOPlugin_Communication.h"

@implementation StarIOPlugin

static NSString *dataCallbackId = nil;

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
    
    _starIoExtManager = nil;

	if ([objectAtIndex0 isEqualToString:@"success"]) {
		NSString *jsString = kCDVPluginINIT;
		[mvcCDVPlugin.webView stringByEvaluatingJavaScriptFromString:jsString];
		result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:@"Success! const kCDVPluginINIT was evaluated by webview!"];
        [self.commandDelegate sendPluginResult:result callbackId:callbackId];
	} else {NSLog(@"[command.arguments objectAtIndex:0] = %@", [command.arguments objectAtIndex:0]); }
}



- (void)checkStatus:(CDVInvokedUrlCommand *)command {
    NSLog(@"Checking status");
    [self.commandDelegate runInBackground:^{
        NSString *portName = nil;
        CDVPluginResult	*result = nil;
        StarPrinterStatus_2 status;
        SMPort *port = nil;
        
        if (command.arguments.count > 0) {
            portName = [command.arguments objectAtIndex:0];
        }
        @try {
            //TODO - Run in background
            if (_starIoExtManager == nil || _starIoExtManager.port == nil) {
                port = [SMPort getPort:portName :@"" :10000];
            } else {
                port = [_starIoExtManager port];
            }
            //TODO - wait till connected
            [port getParsedStatus:&status :2];
            NSDictionary *statusDictionary = [self portStatusToDictionary:status];
            result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDictionary:statusDictionary];
        }
        @catch (PortException *exception) {
            NSLog(@"Port exception");
        }
        @finally {        
            if (port != nil) {
                [SMPort releasePort:port];
            }
        }
        
        NSLog(@"Sending status result");
        [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
    }];
}

- (void)portDiscovery:(CDVInvokedUrlCommand *)command {
    NSLog(@"Finding ports");
    [self.commandDelegate runInBackground:^{
        NSString *portType = @"All";
        
        if (command.arguments.count > 0) {
            portType = [command.arguments objectAtIndex:0];
        }
        
        NSMutableArray *info = [[NSMutableArray alloc] init];
        
        //TODO - run in background
        if ([portType isEqualToString:@"All"] || [portType isEqualToString:@"Bluetooth"]) {
            NSArray *btPortInfoArray = [SMPort searchPrinter:@"BT:"];
            for (PortInfo *p in btPortInfoArray) {
                [info addObject:[self portInfoToDictionary:p]];
            }
        }
        
        if ([portType isEqualToString:@"All"] || [portType isEqualToString:@"LAN"]) {
            NSArray *lanPortInfoArray = [SMPort searchPrinter:@"LAN:"];
            for (PortInfo *p in lanPortInfoArray) {
                [info addObject:[self portInfoToDictionary:p]];
            }
        }
        
        if ([portType isEqualToString:@"All"] || [portType isEqualToString:@"USB"]) {
            NSArray *usbPortInfoArray = [SMPort searchPrinter:@"USB:"];
            for (PortInfo *p in usbPortInfoArray) {
                [info addObject:[self portInfoToDictionary:p]];
            }
        }
        
        
        CDVPluginResult	*result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsArray:info];
     
        NSLog(@"Sending ports result");
        [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
    }];
}

- (void)connect:(CDVInvokedUrlCommand *)command {
    NSString *portName = nil;
    
    if (command.arguments.count > 0) {
        portName = [command.arguments objectAtIndex:0];
    }
    
    if (_starIoExtManager == nil) {
        _starIoExtManager = [[StarIoExtManager alloc] initWithType:StarIoExtManagerTypeWithBarcodeReader
                                                          portName:portName
                                                      portSettings:@""
                                                   ioTimeoutMillis:10000];
        
        _starIoExtManager.delegate = self;
    }
    
    if (_starIoExtManager.port != nil) {
        [_starIoExtManager disconnect];
    }
    
    dataCallbackId = command.callbackId;
    CDVPluginResult	*result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsBool:[_starIoExtManager connect]];
    [result setKeepCallbackAsBool:YES];
    [self.commandDelegate sendPluginResult:result callbackId:dataCallbackId];
}

- (void)printReceipt:(CDVInvokedUrlCommand *)command {
    NSLog(@"printing receipt");
    [self.commandDelegate runInBackground:^{
        NSMutableData *commands = [NSMutableData data];
        NSString *portName = nil;
        NSString *content = nil;
        SMPort *port = nil;
        
        if (command.arguments.count > 0) {
            portName = [command.arguments objectAtIndex:0];
            content = [command.arguments objectAtIndex:1];
        }
        
        if (_starIoExtManager == nil || _starIoExtManager.port == nil) {
            port = [SMPort getPort:portName :@"" :10000];
        } else {
            port = [_starIoExtManager port];
        }
        
        [commands appendBytes:"\x1b\x1d\x61\x01" length:sizeof("\x1b\x1d\x61\x01") - 1];    // Alignment (Center)
        
        [commands appendData:[content dataUsingEncoding:NSASCIIStringEncoding]];
        
        [commands appendBytes:"\x1b\x64\x03" length:sizeof("\x1b\x64\x03") - 1];    // CutPaper(Feed&Partial)
        
        if (_starIoExtManager != nil) {
            [_starIoExtManager.lock lock];
        }
        
        BOOL printResult = [StarIOPlugin_Communication sendCommands:commands port:port];
        
        if (_starIoExtManager != nil) {
            [_starIoExtManager.lock unlock];
        }
        
        CDVPluginResult	*result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsBool:printResult];
        [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
    }];
}

-(void)openCashDrawer:(CDVInvokedUrlCommand *)command {
    NSLog(@"opening cash drawer");
    
    [self.commandDelegate runInBackground:^{
        NSString *portName = nil;
        SMPort *port = nil;
        
        if (command.arguments.count > 0) {
            portName = [command.arguments objectAtIndex:0];
        }
        
        if (_starIoExtManager == nil || _starIoExtManager.port == nil) {
            port = [SMPort getPort:portName :@"" :10000];
        } else {
            port = [_starIoExtManager port];
        }
        
        unsigned char openCashDrawerCommand = 0x07;
        
        NSData *commandData = [NSData dataWithBytes:&openCashDrawerCommand length:1];
        
        if (_starIoExtManager != nil) {
            [_starIoExtManager.lock lock];
        }
        
        BOOL printResult = [StarIOPlugin_Communication sendCommands:commandData port:port];
        
        if (_starIoExtManager != nil) {
            [_starIoExtManager.lock unlock];
        }
        
        CDVPluginResult	*result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsBool:printResult];
        [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
    }];

}

//Printer events
-(void)didPrinterCoverOpen {
    NSLog(@"printerCoverOpen");
    [self sendData:@"printerCoverOpen" data:nil];
}

-(void)didPrinterCoverClose {
    NSLog(@"printerCoverClose");
    [self sendData:@"printerCoverClose" data:nil];
}

-(void)didPrinterImpossible {
    NSLog(@"printerImpossible");
    [self sendData:@"printerImpossible" data:nil];
}

-(void)didPrinterOnline {
    NSLog(@"printerOnline");
    [self sendData:@"printerOnline" data:nil];
}

-(void)didPrinterOffline {
    NSLog(@"printerOffline");
    [self sendData:@"printerOffline" data:nil];
}

-(void)didPrinterPaperEmpty {
    NSLog(@"printerPaperEmpty");
    [self sendData:@"printerPaperEmpty" data:nil];
}

-(void)didPrinterPaperNearEmpty {
    NSLog(@"printerPaperNearEmpty");
    [self sendData:@"printerPaperNearEmpty" data:nil];
}

-(void)didPrinterPaperReady {
    NSLog(@"printerPaperReady");
    [self sendData:@"printerPaperReady" data:nil];
}


//Barcode reader events
-(void)didBarcodeReaderConnect {
    NSLog(@"barcodeReaderConnect");
    [self sendData:@"barcodeReaderConnect" data:nil];
}

-(void)didBarcodeDataReceive:(NSData *)data {
    NSLog(@"barcodeDataReceive");

    NSMutableString *text = [NSMutableString stringWithString:@""];
    
    const uint8_t *p = [data bytes];
    
    for (int i = 0; i < data.length; i++) {
        uint8_t ch = *(p + i);
        
        if(ch >= 0x20 && ch <= 0x7f) {
            [text appendFormat:@"%c", (char) ch];
        }
        else if (ch == 0x0d) { //carriage return
//            text = [NSMutableString stringWithString:@""];
        }
    }
    
    [self sendData:@"barcodeDataReceive" data:text];
}

-(void)didBarcodeReaderImpossible {
    NSLog(@"barcodeReaderImpossible");
    [self sendData:@"barcodeReaderImpossible" data:nil];
}

//Cash drawer events
-(void)didCashDrawerOpen {
    NSLog(@"cashDrawerOpen");
    [self sendData:@"cashDrawerOpen" data:nil];
}
-(void)didCashDrawerClose {
    NSLog(@"cashDrawerClose");
    [self sendData:@"cashDrawerClose" data:nil];
}

- (void)handleOpenURL:(NSNotification *)notification
{
	NSLog(@"%@ handleOpenURL!", [self class]);
}

- (void)onAppTerminate
{
	NSLog(@"%@ onAppTerminate!", [self class]);
    if (_starIoExtManager != nil && _starIoExtManager.port != nil) {
        [_starIoExtManager disconnect];
    }
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
    if (_starIoExtManager != nil && _starIoExtManager.port != nil) {
        [_starIoExtManager disconnect];
    }
}

//Utilities

- (NSMutableDictionary*)portInfoToDictionary:(PortInfo *)portInfo {
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setObject:[portInfo portName] forKey:@"portName"];
    [dict setObject:[portInfo macAddress] forKey:@"macAddress"];
    [dict setObject:[portInfo modelName] forKey:@"modelName"];
    [dict setObject:[NSNumber numberWithBool:[portInfo isConnected]] forKey:@"isConnected"];
    return dict;
}

- (NSMutableDictionary*)portStatusToDictionary:(StarPrinterStatus_2)status {
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setObject:[NSNumber numberWithBool:status.coverOpen == SM_TRUE] forKey:@"coverOpen"];
    [dict setObject:[NSNumber numberWithBool:status.offline == SM_TRUE] forKey:@"offline"];
    [dict setObject:[NSNumber numberWithBool:status.overTemp == SM_TRUE] forKey:@"overTemp"];
    [dict setObject:[NSNumber numberWithBool:status.cutterError == SM_TRUE] forKey:@"cutterError"];
    [dict setObject:[NSNumber numberWithBool:status.receiptPaperEmpty == SM_TRUE] forKey:@"receiptPaperEmpty"];
    return dict;
}

- (void)sendData:(NSString *)dataType data:(NSString *)data {
    if (dataCallbackId != nil) {
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
        [dict setObject:dataType forKey:@"dataType"];
        if (data != nil) {
            [dict setObject:data forKey:@"data"];
        }
        CDVPluginResult	*result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDictionary:dict];
        [result setKeepCallbackAsBool:YES];
        [self.commandDelegate sendPluginResult:result callbackId:dataCallbackId];
    }
}

@end
