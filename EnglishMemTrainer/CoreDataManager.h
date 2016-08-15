//
//  CoreDataManager.h
//  EnglishMemTrainer
//
//  Created by MacBookPro - Yuriy  on 8/3/16.
//  Copyright © 2016 com.mac.yuriy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AppDelegate.h"
@class Dictionary, Vocabluary, Storage, Statistic;

@interface CoreDataManager : NSObject


+ (instancetype)sharedManager;
- (NSManagedObjectContext *)managedObjectContext;
- (Dictionary *)addDictionaryWithArray:(NSArray *)array;
- (Storage *)addStorageWithName:(NSString *)name;
- (Vocabluary *)addVocabluaryWithName:(NSString *)name;
- (Statistic *)addStatisticWithParams:(NSDictionary *)dict;
- (NSArray *)fetchRequestWithEntityName:(NSString *)entityName;
- (void)printFetchedResult:(NSArray *)array;
- (void)removeAllEntities;
- (void)removeEntityWithName:(NSString *)entityName;

@end
