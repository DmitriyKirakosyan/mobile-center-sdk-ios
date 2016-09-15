/*
 * Copyright (c) Microsoft Corporation. All rights reserved.
 */

#import "SonomaCore+Internal.h"
#import <Foundation/Foundation.h>

@interface SNMPageLog : SNMLogWithProperties

/** Name of the event.
 */
@property(nonatomic) NSString *name;

@end