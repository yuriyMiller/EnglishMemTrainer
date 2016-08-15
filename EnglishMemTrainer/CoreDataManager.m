//
//  CoreDataManager.m
//  EnglishMemTrainer
//
//  Created by MacBookPro - Yuriy  on 8/3/16.
//  Copyright © 2016 com.mac.yuriy. All rights reserved.
//

#import "CoreDataManager.h"
#import "EnglishMemConst.h"
#import "Storage.h"
#import "Statistic+CoreDataProperties.h"
#import "Dictionary+CoreDataProperties.h"
#import "Vocabluary+CoreDataProperties.h"

@implementation CoreDataManager {
    NSManagedObjectContext *managedObjectCOntext;
}


+ (instancetype)sharedManager {
    static CoreDataManager *dataManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dataManager = [[CoreDataManager alloc] init];
    });
    
    return dataManager;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        managedObjectCOntext = [self managedObjectContext];
    }
    return self;
}

- (NSManagedObjectContext *)managedObjectContext {
    NSManagedObjectContext *context = nil;
    id delegate = [[UIApplication sharedApplication] delegate];
    if ([delegate performSelector:@selector(managedObjectContext)]) {
        context = [delegate managedObjectContext];
    }
    return context;
}

#pragma mark - Add

- (Storage *)addStorageWithName:(NSString *)name {
    NSManagedObjectContext *context = managedObjectCOntext;
    Storage *storageObject = [NSEntityDescription insertNewObjectForEntityForName:[Storage entityName]
                                                           inManagedObjectContext:context];
    storageObject.name = name;
    return storageObject;
}

- (Dictionary *)addDictionaryWithArray:(NSArray *)array {
    NSManagedObjectContext *context = managedObjectCOntext;
//    NSManagedObject *dictObject = [NSEntityDescription insertNewObjectForEntityForName:@"Dictionary" inManagedObjectContext:context];
    
    Dictionary *dictObject = [Dictionary insertNewObjectIntoContext:context];
    [dictObject setValue:[self getStringValue:StateLangEng andArray:array]
                  forKey:@"engAttribute"];
    [dictObject setValue:[self getStringValue:StateLangRus andArray:array]
                  forKey:@"rusAttribute"];
    [dictObject setValue:[self getStringValue:StateLangExample andArray:array]
                  forKey:@"sentenceAttribute"];

    [self saveWithContext:context];
    return dictObject;
}

- (NSString *)getStringValue:(StateLang )state andArray:(NSArray *)stringArray {
    NSString *string = nil;
    if (stringArray &&  state < stringArray.count) {
        string = [stringArray objectAtIndex:state];
    }
    return string;
}

- (Vocabluary *)addVocabluaryWithName:(NSString *)name {
    NSManagedObjectContext *context = managedObjectCOntext;
//    Vocabluary *vocabObject = [NSEntityDescription insertNewObjectForEntityForName:@"Vocabluary" inManagedObjectContext:context];
    Vocabluary *vocabObject = [Vocabluary insertNewObjectIntoContext:context];
    [vocabObject setValue:name forKey:@"name"];
    
    [self saveWithContext:context];
    return vocabObject;
}

- (Statistic *)addStatisticWithParams:(NSDictionary *)dict {
    NSManagedObjectContext *context = managedObjectCOntext;
    Statistic *statisticObject = [Statistic insertNewObjectIntoContext:context];
    statisticObject.correct = dict[@"correct"];
    statisticObject.incorrect = dict[@"incorrect"];
    statisticObject.total = dict[@"total"];
    statisticObject.sessionTime = dict[@"sessionTime"];
    statisticObject.currentPage = dict[@"currentPage"];
    
    [self saveWithContext:context];
    return statisticObject;
}
#pragma mark - Save Context

- (void)saveWithContext:(NSManagedObjectContext *)context {
    NSError *error = nil;
    if (![context save:&error]) {
        NSLog(@"Can not save NSManagedObjectContext");
    }
}

#pragma mark - Remove

- (void)removeEntityWithName:(NSString *)entityName {
    NSManagedObjectContext *context = managedObjectCOntext;
    NSArray *fetchedArray = [self fetchRequestWithEntityName:entityName];
    for (id object in fetchedArray) {
        [context deleteObject:object];
    }
    [self saveWithContext:context];
}

- (void)removeAllEntities {
    NSManagedObjectContext *context = managedObjectCOntext;
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectModel *objectModel = [appDelegate managedObjectModel];
    NSDictionary *dict = objectModel.entitiesByName;
    
    for (NSString *key in dict) {
        NSLog(@"%@ was deleted from Core Data", key);
        NSArray *objects = [self fetchRequestWithEntityName:key];
        for (NSUInteger i = 0; i < objects.count; i++) {
            id object = [objects objectAtIndex:i];
            [context deleteObject:object];
        }
    }
    [self saveWithContext:context];
}

#pragma mark - Fetch

- (NSArray *)fetchRequestWithEntityName:(NSString *)entityName {
    NSManagedObjectContext *context = managedObjectCOntext;
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *description = [NSEntityDescription entityForName:entityName
                                                   inManagedObjectContext:context];
    [fetchRequest setEntity:description];
    NSError *error = nil;
    NSArray *fetchedArray = [context executeFetchRequest:fetchRequest error:&error];
    if (error) {
        NSLog(@"%@", [error localizedDescription]);
    }

    //[self printFetchedResult:fetchedArray];
    
    return fetchedArray;
}

- (void)printFetchedResult:(NSArray *)array {
    for (id object in array) {
        if ([object isKindOfClass:[Dictionary class]]) {
            Dictionary *dict = (Dictionary *)object;
            NSLog(@"KEY:: %@ VALUE:: %@ SENTENCE:: %@", dict.engAttribute,
                                                        dict.rusAttribute,
                                                        dict.sentenceAttribute);
        } else if ([object isKindOfClass:[Vocabluary class]]) {
            Vocabluary *vocab = (Vocabluary *)object;
            NSLog(@"Name: %@", vocab.name);
        }
    }
}
@end
