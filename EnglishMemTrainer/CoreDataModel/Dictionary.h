//
//  Dictionary.h
//  EnglishMemTrainer
//
//  Created by MacBookPro - Yuriy  on 8/3/16.
//  Copyright © 2016 com.mac.yuriy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Vocabluary;

NS_ASSUME_NONNULL_BEGIN

typedef enum : NSUInteger {
    StateLangEng,
    StateLangRus,
    StateLangExample,
} StateLang;

@interface Dictionary : NSManagedObject

- (instancetype)initWithArray:(NSArray *)array;
+ (instancetype)insertNewObjectIntoContext:(NSManagedObjectContext *)context;

@end

NS_ASSUME_NONNULL_END

#import "Dictionary+CoreDataProperties.h"
