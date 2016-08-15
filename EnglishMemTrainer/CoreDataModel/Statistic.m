//
//  Statistic.m
//  EnglishMemTrainer
//
//  Created by MacBookPro - Yuriy  on 8/12/16.
//  Copyright © 2016 com.mac.yuriy. All rights reserved.
//

#import "Statistic.h"
#import "Vocabluary.h"

@implementation Statistic

+ (NSString *)entityName {
        return @"Statistic";
}
    
+ (instancetype)insertNewObjectIntoContext:(NSManagedObjectContext *)context {
    return [NSEntityDescription insertNewObjectForEntityForName:[self entityName]
                                         inManagedObjectContext:context];
}

@end
