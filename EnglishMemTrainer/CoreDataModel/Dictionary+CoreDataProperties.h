//
//  Dictionary+CoreDataProperties.h
//  EnglishMemTrainer
//
//  Created by MacBookPro - Yuriy  on 8/3/16.
//  Copyright © 2016 com.mac.yuriy. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Dictionary.h"

NS_ASSUME_NONNULL_BEGIN

@interface Dictionary (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *engAttribute;
@property (nullable, nonatomic, retain) NSString *rusAttribute;
@property (nullable, nonatomic, retain) NSString *sentenceAttribute;
@property (nullable, nonatomic, retain) Vocabluary *vocabluary;

@end

NS_ASSUME_NONNULL_END
