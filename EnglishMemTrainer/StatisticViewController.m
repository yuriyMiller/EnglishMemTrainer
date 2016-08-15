//
//  StatisticViewController.m
//  EnglishMemTrainer
//
//  Created by MacBookPro - Yuriy  on 7/27/16.
//  Copyright © 2016 com.mac.yuriy. All rights reserved.
//

#import "StatisticViewController.h"
#import "Statistic.h"

@interface StatisticViewController ()

@end

@implementation StatisticViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.correctValueLabel.text = [NSString stringWithFormat:@"%i", [self.statisticObj.correct intValue]];
    self.incorrectValueLabel.text = [NSString stringWithFormat:@"%i", [self.statisticObj.incorrect intValue]];
    self.totalValueLabel.text = [NSString stringWithFormat:@"%i", [self.statisticObj.total intValue]];
    self.sessionTime.text = [NSString stringWithFormat:@"%@", self.statisticObj.sessionTime];
    self.currentPageTitle.text = [NSString stringWithFormat:@"%@", self.statisticObj.currentPage];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//    return 3;
//}
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//    switch (section) {
//        case 1:
//            return 4;
//            break;
//        case 2:
//            return 2;
//            break;
//        case 3:
//            return 3;
//            break;
//        default:
//            break;
//    }
//    return 1;
//}
//
//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    UITableViewCell *cell = [[UITableViewCell alloc] init];
//    return cell;
//}

@end
