//
//  StatisticViewController.h
//  EnglishMemTrainer
//
//  Created by MacBookPro - Yuriy  on 7/27/16.
//  Copyright © 2016 com.mac.yuriy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StatisticViewController : UITableViewController
@property (weak, nonatomic) IBOutlet UILabel *correctValueLabel;
@property (weak, nonatomic) IBOutlet UILabel *incorrectValueLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalValueLabel;
@property (weak, nonatomic) IBOutlet UILabel *restWordsValueLabel;

@property (strong, nonatomic) NSString *correctResult;
@property (strong, nonatomic) NSString *incorrectResult;
@property (strong, nonatomic) NSString *totalResult;

@end
