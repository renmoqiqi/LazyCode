//
//  PHAutoCoding.h
//  LazyCode
//
//  Created by penghe on 15/2/3.
//  Copyright (c) 2015年 penghe. All rights reserved.
//

#import <Foundation/Foundation.h>

//一个自动给自定义的类添加copy  codeding 方法的类目  提供了对NSCoding 和NSCopying的自动支持

@interface PHAutoCoding : NSObject

@end
@interface NSObject (PHAutoCoding) <NSSecureCoding>

//coding

+ (NSDictionary *)codableProperties;
- (void)setWithCoder:(NSCoder *)aDecoder;

//property access

- (NSDictionary *)codableProperties;
- (NSDictionary *)dictionaryRepresentation;

//loading / saving
+ (instancetype)objectWithContentsOfFile:(NSString *)path;
- (BOOL)writeToFile:(NSString *)filePath atomically:(BOOL)useAuxiliaryFile;

@end