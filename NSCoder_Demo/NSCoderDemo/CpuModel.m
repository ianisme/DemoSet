//
//  CpuModel.m
//  NSCoderDemo
//
//  Created by ian on 15/12/11.
//  Copyright © 2015年 ian. All rights reserved.
//

#import "CpuModel.h"

@implementation CpuModel

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:UIImageJPEGRepresentation(self.picture, 1.0) forKey:@"picture"];
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self == [super init]) {
        self.picture = [UIImage imageWithData:[aDecoder decodeObjectForKey:@"picture"]];
    }
    return self;
}

@end
