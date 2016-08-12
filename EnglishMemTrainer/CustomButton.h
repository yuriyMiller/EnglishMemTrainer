//
//  CustomButton.h
//  EnglishMemTrainer
//
//  Created by MacBookPro - Yuriy  on 7/22/16.
//  Copyright © 2016 com.mac.yuriy. All rights reserved.
//

#import <UIKit/UIKit.h>
IB_DESIGNABLE

@interface CustomButton : UIButton

@property (nonatomic) IBInspectable UIColor *color;
@property (nonatomic) IBInspectable UIColor *startColor;
@property (nonatomic) IBInspectable UIColor *endColor;
@property (nonatomic) IBInspectable CGFloat borderWidth;
@property (nonatomic) IBInspectable CGFloat cornerRadious;
@property (nonatomic) IBInspectable BOOL isHorizontal;

//@interface Vocabluary : NSManagedObject
//
//+ (NSString *)entityName;
//+ (instancetype)insertNewObjectIntoContext:(NSManagedObjectContext *)context;
//
//@end

//@implementation Vocabluary
//
//+ (NSString *)entityName {
//    return @"Vocabluary";
//}
//
//+ (instancetype)insertNewObjectIntoContext:(NSManagedObjectContext *)context {
//    return [NSEntityDescription insertNewObjectForEntityForName:[self entityName]
//                                         inManagedObjectContext:context];
//}

@end
