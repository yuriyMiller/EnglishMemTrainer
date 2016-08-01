//
//  MainInteractiveViewController.h
//  EnglishMemTrainer
//
//  Created by MacBookPro - Yuriy  on 7/14/16.
//  Copyright © 2016 com.mac.yuriy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MainInteractiveViewController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *quizLable;
@property (weak, nonatomic) IBOutlet UILabel *answerLabel;
@property (weak, nonatomic) IBOutlet UILabel *timerLabel;
@property (weak, nonatomic) IBOutlet UIButton *showButton;
@property (weak, nonatomic) IBOutlet UIButton *startButton;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentedControl;
@property (weak, nonatomic) IBOutlet  UIView *quizView;
@property (weak, nonatomic) IBOutlet  UIView *startView;
@property (weak, nonatomic) UIBarButtonItem *menuButton;


@property (strong, nonatomic) NSDictionary *contentDict;
@property (strong, nonatomic) NSMutableArray *dictObjectsArray;
@property (strong, nonatomic) NSMutableArray *correctAnswersArray;
@property (strong, nonatomic) NSMutableArray *incorrectAnswersArray;


- (IBAction)actionShowResult:(UIButton *)sender;



@end