//
//  Statistic+CoreDataProperties.h
//  EnglishMemTrainer
//
//  Created by MacBookPro - Yuriy  on 8/12/16.
//  Copyright © 2016 com.mac.yuriy. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Statistic.h"

NS_ASSUME_NONNULL_BEGIN

@interface Statistic (CoreDataProperties)

@property (nullable, nonatomic, retain) NSNumber *correct;
@property (nullable, nonatomic, retain) NSNumber *incorrect;
@property (nullable, nonatomic, retain) NSNumber *total;
@property (nullable, nonatomic, retain) NSNumber *restWords;
@property (nullable, nonatomic, retain) NSDate *sessionTime;
@property (nullable, nonatomic, retain) NSDate *avarageTime;
@property (nullable, nonatomic, retain) NSNumber *important;
@property (nullable, nonatomic, retain) NSNumber *pages;
@property (nullable, nonatomic, retain) NSString *currentPage;
@property (nullable, nonatomic, retain) Vocabluary *vocabluary;

@end

NS_ASSUME_NONNULL_END
