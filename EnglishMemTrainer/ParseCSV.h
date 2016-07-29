//
//  ParseCSV.h
//  EnglishMemTrainer
//
//  Created by MacBookPro - Yuriy  on 7/18/16.
//  Copyright © 2016 com.mac.yuriy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ParseCSV : NSObject

@property (strong, nonatomic) NSString *path;

+ (id)sharedManager;

- (NSArray *)readCSVFile:(NSString *)path;

@end
