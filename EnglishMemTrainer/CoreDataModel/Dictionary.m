//
//  Dictionary.m
//  EnglishMemTrainer
//
//  Created by MacBookPro - Yuriy  on 8/3/16.
//  Copyright © 2016 com.mac.yuriy. All rights reserved.
//

#import "Dictionary.h"
#import "Vocabluary.h"
#import "CoreDataManager.h"

@implementation Dictionary {
    NSArray *stringArray;
}



- (instancetype)initWithArray:(NSArray *)array {

    if (self) {
        NSManagedObjectContext *context = self.managedObjectContext;
        NSEntityDescription *description = [NSEntityDescription entityForName:@"Dictionary"
                                                       inManagedObjectContext:context];
        self = [self initWithEntity:description insertIntoManagedObjectContext:context];
        stringArray = [[NSArray alloc] initWithArray:array];
       
        self.engAttribute = [self getStringValue:StateLangEng];
        self.rusAttribute = [self getStringValue:StateLangRus];
        self.sentenceAttribute = [self getStringValue:StateLangExample];
    }
    return self;
}

- (BOOL)isExampleExist{
    return (self.sentenceAttribute && [self getStringValue:StateLangExample]) ? YES : NO;
}

- (NSString *)getStringValue:(StateLang )state {
    NSString *string = nil;
    if (stringArray &&  state < stringArray.count) {
        string = [stringArray objectAtIndex:state];
        
    }
    return string;
}

+ (NSString *)entityName {
    return @"Dictionary";
}

+ (instancetype)insertNewObjectIntoContext:(NSManagedObjectContext *)context {
    return [NSEntityDescription insertNewObjectForEntityForName:[self entityName]
                                         inManagedObjectContext:context];
}

@end
