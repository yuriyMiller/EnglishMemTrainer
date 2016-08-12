//
//  Statistic.h
//  EnglishMemTrainer
//
//  Created by MacBookPro - Yuriy  on 8/12/16.
//  Copyright © 2016 com.mac.yuriy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Vocabluary;

NS_ASSUME_NONNULL_BEGIN

@interface Statistic : NSManagedObject


+ (NSString *)entityName;
+ (instancetype)insertNewObjectIntoContext:(NSManagedObjectContext *)context;

@end

NS_ASSUME_NONNULL_END

#import "Statistic+CoreDataProperties.h"
