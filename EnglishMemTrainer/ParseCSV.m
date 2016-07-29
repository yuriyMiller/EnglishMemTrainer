//
//  ParseCSV.m
//  EnglishMemTrainer
//
//  Created by MacBookPro - Yuriy  on 7/18/16.
//  Copyright © 2016 com.mac.yuriy. All rights reserved.
//

#import "ParseCSV.h"

@implementation ParseCSV

+ (id)sharedManager {
    static ParseCSV *parseCSV = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        parseCSV = [[self alloc] init];
    });
    return parseCSV;
}

- (instancetype)initWithPath:(NSString *)path
{
    self = [super init];
    if (self) {
        self.path = path;
    }
    return self;
}

- (NSArray *)readCSVFile:(NSString *)path {
    NSArray *lines = [NSArray array];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:path]) {
        NSString *file = [NSString stringWithContentsOfFile:path
                                                   encoding:NSUTF8StringEncoding
                                                      error:nil];
        lines = [file componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]];
       
        NSMutableArray *array = [NSMutableArray array];
        for (NSString *line in lines) {
            NSArray *separetedComponents = [NSArray array];
            
            if (![line isEqualToString:@",,"]) {
                //NSLog(@"%@", line);
                if ([line containsString:@"\""]) {
                    separetedComponents = [line componentsSeparatedByString:@"\""];
                    
                    //                if ([self isComponentsHasStatement:separetedComponents]) {
                    //                    NSString *statement = [self trimmCharacterFromString:separetedComponents[2]];
                    //                    separetedComponents = [[NSArray alloc] initWithObjects:separetedComponents[0],
                    //                                                                           separetedComponents[1],
                    //                                                                           statement, nil];
                    //                } else {
                    //                    separetedComponents = [[NSArray alloc] initWithObjects:separetedComponents[0],
                    //                                                                           separetedComponents[1], nil];
                    //                }
                    
                } else {
                    separetedComponents = [line componentsSeparatedByString:@","];
                }
                NSMutableArray *elements = [NSMutableArray array];
                for (NSString *component in separetedComponents) {
                    if (component.length > 0 && ![component isEqualToString:@","]) {
                        //NSLog(@"%@", component);
                        
                        NSString *trimmedComponent = [self trimmCharactersFromString:component];
                        
                        [elements addObject:trimmedComponent];
                    }
                }
                
                if (elements.count > 0) {
                    [array addObject:elements];
                }
            }
            
        }
        
        return array;
    }
    return nil;
}

- (BOOL)isComponentsHasStatement:(NSArray *)components {
    BOOL exist = NO;
    NSString *statement = [components objectAtIndex:2];
    if (components.count == 3 && statement.length > 0) {
        exist = YES;
    }
    return exist;
}

- (NSString *)trimmCharacterFromString:(NSString *)string {
    NSMutableCharacterSet *charactersToKeep = [NSMutableCharacterSet letterCharacterSet];
    NSCharacterSet *charactersToremove = [charactersToKeep invertedSet];
    NSString *result =[string stringByTrimmingCharactersInSet:charactersToremove];
    return result;
}

- (NSString *)trimmCharactersFromString:(NSString *)string {

    NSString *stringResult = @"";
    NSRegularExpression *regExp = [NSRegularExpression regularExpressionWithPattern:@"([^,.]+)"
                                                                            options:0
                                                                              error:nil];
    NSArray *matches= [regExp matchesInString:string
                                      options:NSMatchingReportProgress
                                        range:NSMakeRange(0, string.length)];
    
    NSMutableArray *matchesArray = [NSMutableArray array];
    for (NSTextCheckingResult *match in matches) {
        NSString *matchText = [string substringWithRange:[match range]];
        [matchesArray addObject:matchText];
    }
    return stringResult = [matchesArray componentsJoinedByString:@", "];
}
@end
