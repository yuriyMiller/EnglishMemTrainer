//
//  CustomButton.m
//  EnglishMemTrainer
//
//  Created by MacBookPro - Yuriy  on 7/22/16.
//  Copyright © 2016 com.mac.yuriy. All rights reserved.
//

#import "CustomButton.h"

@implementation CustomButton


- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.borderWidth    = 2;
        self.cornerRadious  = 10;
        [self customInit];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self customInit];
    }
    return self;
}


- (void)drawRect:(CGRect)rect {
    [self customInit];
}

- (void)setNeedsLayout {
    [super setNeedsLayout];
    [self setNeedsDisplay];
}


- (void)prepareForInterfaceBuilder {
    
    [self customInit];
}

- (void)customInit {
        
    self.layer.cornerRadius = self.cornerRadious;
    self.layer.borderWidth = self.borderWidth;
    
    if (self.cornerRadious > 0) {
        self.layer.masksToBounds = YES;
    }
    
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame = self.bounds;
    
    gradient.colors = [NSArray arrayWithObjects:(id)[self.startColor CGColor],(id)[self.endColor CGColor], nil];
    gradient.endPoint = (self.isHorizontal) ? CGPointMake(1, 0) : CGPointMake(0, 1);
    [self.layer insertSublayer:gradient atIndex:0];
    
    if (!gradient) {
        self.layer.backgroundColor = [self.color CGColor];
    }
   
}
@end
