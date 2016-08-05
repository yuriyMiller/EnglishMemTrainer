//
//  Vocabluary+CoreDataProperties.h
//  EnglishMemTrainer
//
//  Created by MacBookPro - Yuriy  on 8/3/16.
//  Copyright © 2016 com.mac.yuriy. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Vocabluary.h"

NS_ASSUME_NONNULL_BEGIN

@interface Vocabluary (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *name;
@property (nullable, nonatomic, retain) NSSet<NSManagedObject *> *dictionaries;
@property (nullable, nonatomic, retain) NSManagedObject *storage;

@end

@interface Vocabluary (CoreDataGeneratedAccessors)

- (void)addDictionariesObject:(NSManagedObject *)value;
- (void)removeDictionariesObject:(NSManagedObject *)value;
- (void)addDictionaries:(NSSet<NSManagedObject *> *)values;
- (void)removeDictionaries:(NSSet<NSManagedObject *> *)values;

@end

NS_ASSUME_NONNULL_END
