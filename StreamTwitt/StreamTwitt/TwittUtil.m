//
//  TwittUtil.m
//  StreamTwitt
//
//  Created by Suman Chatterjee on 17/12/2014.
//  Copyright (c) 2014 Suman Chatterjee. All rights reserved.
//

#import "TwittUtil.h"

@implementation TwittUtil

+ (BOOL)isEmptyString:(NSString*)string
{
    NSString *value = [string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    return ([value length] == 0 || value == nil);
}

@end
