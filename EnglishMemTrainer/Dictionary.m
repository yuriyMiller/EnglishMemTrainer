//
//  Dictionary.m
//  EnglishMemTrainer
//
//  Created by MacBookPro - Yuriy  on 7/19/16.
//  Copyright © 2016 com.mac.yuriy. All rights reserved.
//

#import "Dictionary.h"

@implementation Dictionary {
    NSArray *stringArray;
}

- (instancetype)initWithArray:(NSArray *)array
{
    self = [super init];
    if (self) {
        stringArray = [[NSArray alloc] initWithArray:array];
        self.engString = [self getStringValue:StateLangEng];
        self.rusString = [self getStringValue:StateLangRus];
        self.engExample = [self getStringValue:StateLangExample];
    }
    return self;
}

- (BOOL)isExampleExist{
    return (self.engExample && [self getStringValue:StateLangExample]) ? YES : NO;
}

- (NSString *)getStringValue:(StateLang )state {
    NSString *string = nil;
    if (stringArray &&  state < stringArray.count) {
        string = [stringArray objectAtIndex:state];
        
    }
    return string;
}

@end
