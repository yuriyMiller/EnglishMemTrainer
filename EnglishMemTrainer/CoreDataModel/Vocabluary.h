//
//  Vocabluary.h
//  EnglishMemTrainer
//
//  Created by MacBookPro - Yuriy  on 8/3/16.
//  Copyright © 2016 com.mac.yuriy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

NS_ASSUME_NONNULL_BEGIN

@interface Vocabluary : NSManagedObject

+ (NSString *)entityName;
+ (instancetype)insertNewObjectIntoContext:(NSManagedObjectContext *)context;

@end

NS_ASSUME_NONNULL_END

#import "Vocabluary+CoreDataProperties.h"
