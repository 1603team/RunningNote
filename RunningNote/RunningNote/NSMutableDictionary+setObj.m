//
//  NSMutableDictionary+setObj.m
//  RunningNote
//
//  Created by qingyun on 16/7/21.
//  Copyright © 2016年 qingyun. All rights reserved.
//

#import "NSMutableDictionary+setObj.h"

@implementation NSMutableDictionary (setObj)

- (void)GHB_setObject:(id)anObject forKey:(id<NSCopying>)aKey {
    if (anObject == nil) {
        return;
    }
    [self setObject:anObject forKey:aKey];
}

@end
