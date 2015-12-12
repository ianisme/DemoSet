//
//  CpuModel.h
//  NSCoderDemo
//
//  Created by ian on 15/12/11.
//  Copyright © 2015年 ian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface CpuModel : NSObject<NSCoding>

@property (nonatomic, strong) UIImage *picture;

@property (nonatomic, copy) NSString *titleString;

@property (nonatomic, copy) NSString *contentString;

@end
