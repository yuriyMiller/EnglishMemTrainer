//
//  Dictionary.h
//  EnglishMemTrainer
//
//  Created by MacBookPro - Yuriy  on 7/19/16.
//  Copyright © 2016 com.mac.yuriy. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum : NSUInteger {
    StateLangEng,
    StateLangRus,
    StateLangExample,
} StateLang;

@interface Dictionary : NSObject

@property (strong, nonatomic) NSString *engString;
@property (strong, nonatomic) NSString *rusString;
@property (strong, nonatomic) NSString *engExample;
@property (assign, nonatomic) BOOL isExampleExist;
@property (assign, nonatomic) BOOL isImportant;
//@property (strong, nonatomic) NSDictionary *dictArray;
- (instancetype)initWithArray:(NSArray *)array;
@end
