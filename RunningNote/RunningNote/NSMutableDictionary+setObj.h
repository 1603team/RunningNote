//
//  NSMutableDictionary+setObj.h
//  RunningNote
//
//  Created by qingyun on 16/7/21.
//  Copyright © 2016年 qingyun. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMutableDictionary (setObj)

- (void)GHB_setObject:(id)anObject forKey:(id<NSCopying>)aKey;

@end
