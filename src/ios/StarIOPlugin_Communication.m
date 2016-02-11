//
//  Communication.m
//  mPOP SDK
//
//  Created by Yuji on 2015/06/10.
//  Copyright (c) 2015年 Star Micronics. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "StarIOPlugin_Communication.h"

@implementation StarIOPlugin_Communication

+ (BOOL)sendCommands:(NSData *)commands port:(SMPort *)port {
    BOOL result = NO;
    
    NSString *title   = @"";
    NSString *message = @"";
    
    uint32_t commandLength = (uint32_t) [commands length];
    
    unsigned char *commandsBytes = (unsigned char *) [commands bytes];
    
    @try {
        while (YES) {
            if (port == nil) {
                title = @"Fail to Open Port";
                break;
            }
            
            StarPrinterStatus_2 printerStatus;
            
            [port beginCheckedBlock:&printerStatus :2];
            
            if (printerStatus.offline == SM_TRUE) {
                title   = @"Printer Error";
                message = @"Printer is offline (BeginCheckedBlock)";
                break;
            }
            
            NSDate *startDate = [NSDate date];
            
            uint32_t total = 0;
            
            while (total < commandLength) {
                uint32_t written = [port writePort:commandsBytes :total :commandLength - total];
                
                total += written;
                
                if ([[NSDate date] timeIntervalSinceDate:startDate] >= 30.0) {     // 30000mS!!!
                    break;
                }
            }
            
            if (total < commandLength) {
                title   = @"Printer Error";
                message = @"Write port timed out";
                break;
            }
            
            port.endCheckedBlockTimeoutMillis = 30000;     // 30000mS!!!
            
            [port endCheckedBlock:&printerStatus :2];
            
            if (printerStatus.offline == SM_TRUE) {
                title   = @"Printer Error";
                message = @"Printer is offline (endCheckedBlock)";
                break;
            }
            
            result = YES;
            break;
        }
    }
    @catch (PortException *exc) {
        title   = @"Printer Error";
        message = @"Write port timed out (PortException)";
    }
    
    return result;
}

+ (BOOL)sendCommandsDoNotCheckCondition:(NSData *)commands port:(SMPort *)port {
    BOOL result = NO;

    NSString *title   = @"";
    NSString *message = @"";

    uint32_t commandLength = (uint32_t) [commands length];

    unsigned char *commandsBytes = (unsigned char *) [commands bytes];

    @try {
        while (YES) {
            if (port == nil) {
                title = @"Fail to Open Port";
                break;
            }

            StarPrinterStatus_2 printerStatus;

            [port getParsedStatus:&printerStatus :2];

            //          if (printerStatus.offline == SM_TRUE) {     // Do not check condition. (F/W 1.1 or later.)
            //              title   = @"Printer Error";
            //              message = @"Printer is offline (BeginCheckedBlock)";
            //              break;
            //          }

            NSDate *startDate = [NSDate date];

            uint32_t total = 0;

            while (total < commandLength) {
                uint32_t written = [port writePort:commandsBytes :total :commandLength - total];

                total += written;

                if ([[NSDate date] timeIntervalSinceDate:startDate] >= 30.0) {     // 30000mS!!!
                    break;
                }
            }

            if (total < commandLength) {
                title   = @"Printer Error";
                message = @"Write port timed out";
                break;
            }

            [port getParsedStatus:&printerStatus :2];

            //          if (printerStatus.offline == SM_TRUE) {     // Do not check condition. (F/W 1.1 or later.)
            //              title   = @"Printer Error";
            //              message = @"Printer is offline (endCheckedBlock)";
            //              break;
            //          }

            result = YES;
            break;
        }
    }
    @catch (PortException *exc) {
        title   = @"Printer Error";
        message = @"Write port timed out (PortException)";
    }

    return result;
}

+ (BOOL)sendCommands:(NSData *)commands portName:(NSString *)portName portSettings:(NSString *)portSettings timeout:(NSInteger)timeout {
    BOOL result = NO;

    NSString *title   = @"";
    NSString *message = @"";

    if (timeout > UINT32_MAX) {
        timeout = UINT32_MAX;
    }

    uint32_t commandLength = (uint32_t) [commands length];

    unsigned char *commandsBytes = (unsigned char *) [commands bytes];

    SMPort *port = nil;

    @try {
        while (YES) {
            port = [SMPort getPort:portName :portSettings :(uint32_t) timeout];

            if (port == nil) {
                title = @"Fail to Open Port";
                break;
            }

            StarPrinterStatus_2 printerStatus;

            [port beginCheckedBlock:&printerStatus :2];

            if (printerStatus.offline == SM_TRUE) {
                title   = @"Printer Error";
                message = @"Printer is offline (BeginCheckedBlock)";
                break;
            }

            NSDate *startDate = [NSDate date];

            uint32_t total = 0;

            while (total < commandLength) {
                uint32_t written = [port writePort:commandsBytes :total :commandLength - total];

                total += written;

                if ([[NSDate date] timeIntervalSinceDate:startDate] >= 30.0) {     // 30000mS!!!
                    break;
                }
            }

            if (total < commandLength) {
                title   = @"Printer Error";
                message = @"Write port timed out";
                break;
            }

            port.endCheckedBlockTimeoutMillis = 30000;     // 30000mS!!!

            [port endCheckedBlock:&printerStatus :2];

            if (printerStatus.offline == SM_TRUE) {
                title   = @"Printer Error";
                message = @"Printer is offline (endCheckedBlock)";
                break;
            }

            result = YES;
            break;
        }
    }
    @catch (PortException *exc) {
        title   = @"Printer Error";
        message = @"Write port timed out (PortException)";
    }
    @finally {
        if (port != nil) {
            [SMPort releasePort:port];
        }
    }

    return result;
}

+ (BOOL)sendCommandsDoNotCheckCondition:(NSData *)commands portName:(NSString *)portName portSettings:(NSString *)portSettings timeout:(NSInteger)timeout {
    BOOL result = NO;

    NSString *title   = @"";
    NSString *message = @"";

    if (timeout > UINT32_MAX) {
        timeout = UINT32_MAX;
    }

    uint32_t commandLength = (uint32_t) [commands length];

    unsigned char *commandsBytes = (unsigned char *) [commands bytes];

    SMPort *port = nil;

    @try {
        while (YES) {
            port = [SMPort getPort:portName :portSettings :(uint32_t) timeout];

            if (port == nil) {
                title = @"Fail to Open Port";
                break;
            }

            StarPrinterStatus_2 printerStatus;

            [port getParsedStatus:&printerStatus :2];

            //          if (printerStatus.offline == SM_TRUE) {     // Do not check condition. (F/W 1.1 or later.)
            //              title   = @"Printer Error";
            //              message = @"Printer is offline (BeginCheckedBlock)";
            //              break;
            //          }

            NSDate *startDate = [NSDate date];

            uint32_t total = 0;

            while (total < commandLength) {
                uint32_t written = [port writePort:commandsBytes :total :commandLength - total];

                total += written;

                if ([[NSDate date] timeIntervalSinceDate:startDate] >= 30.0) {     // 30000mS!!!
                    break;
                }
            }

            if (total < commandLength) {
                title   = @"Printer Error";
                message = @"Write port timed out";
                break;
            }

            [port getParsedStatus:&printerStatus :2];

            //          if (printerStatus.offline == SM_TRUE) {     // Do not check condition. (F/W 1.1 or later.)
            //              title   = @"Printer Error";
            //              message = @"Printer is offline (endCheckedBlock)";
            //              break;
            //          }

            result = YES;
            break;
        }
    }
    @catch (PortException *exc) {
        title   = @"Printer Error";
        message = @"Write port timed out (PortException)";
    }
    @finally {
        if (port != nil) {
            [SMPort releasePort:port];
        }
    }
    
    return result;
}

@end
