//
//  Storage+CoreDataProperties.h
//  EnglishMemTrainer
//
//  Created by MacBookPro - Yuriy  on 8/3/16.
//  Copyright © 2016 com.mac.yuriy. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Storage.h"

NS_ASSUME_NONNULL_BEGIN

@interface Storage (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *name;
@property (nullable, nonatomic, retain) NSSet<Vocabluary *> *vocabularies;

@end

@interface Storage (CoreDataGeneratedAccessors)

- (void)addVocabulariesObject:(Vocabluary *)value;
- (void)removeVocabulariesObject:(Vocabluary *)value;
- (void)addVocabularies:(NSSet<Vocabluary *> *)values;
- (void)removeVocabularies:(NSSet<Vocabluary *> *)values;

@end

NS_ASSUME_NONNULL_END
