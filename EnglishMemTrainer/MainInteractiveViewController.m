//
//  MainInteractiveViewController.m
//  EnglishMemTrainer
//
//  Created by MacBookPro - Yuriy  on 7/14/16.
//  Copyright © 2016 com.mac.yuriy. All rights reserved.
//

#import "MainInteractiveViewController.h"
#import "SWRevealViewController.h"
#import "StatisticViewController.h"
#import "ParseCSV.h"
#import "Dictionary.h"
#import "Vocabluary.h"
#import "EnglishMemConst.h"
#import "CoreDataManager.h"

static NSString * const answerPlaceholder = @"Answer";

@interface MainInteractiveViewController () {
    UIVisualEffectView *visualEffectView;
    NSTimer *_timer;
    NSTimer *_sessionTimer;
    int _timeSec;
    int _sessionSec;
    int _sessionMin;
    int _correctResult;
    int _incorrectResult;
}

@property (strong, nonatomic) NSMutableArray *answeredIndexesArray;
@property (strong, nonatomic) Dictionary *dictObject;
@property (strong, nonatomic) NSArray *gestureRecognizerArray;
@property (strong, nonatomic) NSDate *pauseStart;
@property (strong, nonatomic) NSDate *previousFireDate;

@end

@implementation MainInteractiveViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupRevealController];
    NSArray *testAr = [[CoreDataManager sharedManager] fetchRequestWithEntityName:@"Vocabluary"];
    [[CoreDataManager sharedManager] printFetchedResult:testAr];

    [self initDictionaryWithParsedFile:[self getParsedArray]];
    
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (!visualEffectView) {
        [self setupStartView];
    }
    
    [self setupShowUIButton];
    [self setupInfoImageView];
    [self setupSegmentedControl];
    if (self.pauseStart != nil && self.previousFireDate != nil) {
        [self resumePause];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - UI Setup
- (void)setupInfoImageView {
    self.infoView.hidden = YES;
}

- (void)setupShowUIButton {
    self.showButton.layer.cornerRadius = 5;
    self.showButton.layer.borderWidth = 1;
    self.showButton.layer.borderColor = [[UIColor grayColor] CGColor];
}

- (void)setupRevealController {
    SWRevealViewController *revealViewController = self.revealViewController;
    if (revealViewController) {
        UIBarButtonItem *menuButton = [[UIBarButtonItem alloc]
                                       initWithImage:[UIImage
                                                      imageNamed:@"reveal-icon.png"]
                                       style:UIBarButtonItemStylePlain
                                       target:self.revealViewController
                                       action:@selector(revealToggle:)];
        [self.navigationItem setLeftBarButtonItem:menuButton];
        [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    }
}

- (void)setupSegmentedControl {
    self.segmentedControl.backgroundColor = [UIColor colorWithRed:88.0f/255.0 green:88.0f/255.0 blue:88.0f/255.0 alpha:1];
    self.segmentedControl.selectedSegmentIndex = 1;
    self.segmentedControl.tintColor = [UIColor lightGrayColor];
    self.segmentedControl.layer.cornerRadius = 5.f;
    self.segmentedControl.layer.borderWidth = 1.f;
    self.segmentedControl.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    self.segmentedControl.layer.masksToBounds = YES;
    [self.segmentedControl addTarget:self action:@selector(actionSegment:) forControlEvents:UIControlEventValueChanged];
}

- (void)setupStartView {
    UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    visualEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
    visualEffectView.frame = self.view.bounds;
    [self.view addSubview:visualEffectView];

    [self.startView setAlpha:1.0f];
    [self.startView setHidden:NO];
    [self.view bringSubviewToFront:self.startView];
    [self setupStartViewButtons];
}

- (void) setupStartViewButtons {
    if (_sessionTimer) {
        [self disableButton:self.startButton];
        [self enableButton:self.resumeButton];
        [self enableButton:self.infoButton];
    } else {
        [self enableButton:self.startButton];
        [self disableButton:self.resumeButton];
        [self disableButton:self.infoButton];
    }
}

- (void)disableButton:(UIButton *)button {
    [button setAlpha:0.55f];
    [button setEnabled:NO];
}

- (void)enableButton:(UIButton *)button {
    [button setAlpha:1.f];
    [button setEnabled:YES];
}

- (void)setupRightStatisticButton {
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemBookmarks
                                                                                 target:self
                                                                                 action:@selector(actionShowStatistic:)];
    [self.navigationItem setRightBarButtonItem:rightButton];
}

- (void)setDefaultSettings {
    self.answeredIndexesArray = [NSMutableArray array];
    self.correctAnswersArray = [NSMutableArray array];
    self.incorrectAnswersArray = [NSMutableArray array];
    [self setupRightStatisticButton];
    [self displayResults];
    [self actionSegment:self.segmentedControl];
    
}

#pragma mark - Initialization

- (void)initDictionaryWithParsedFile:(NSArray *)parsedArray {
    NSMutableDictionary *tempContentDictionary =[NSMutableDictionary dictionary];
    self.dictObjectsArray = [NSMutableArray array];
    
    if (parsedArray) {
        for (NSArray *array in parsedArray) {
            //Dictionary *dictContent = [[Dictionary alloc] initWithArray:array];
            Dictionary *dictContent = [[CoreDataManager sharedManager] addDictionaryWithArray:array];
            [self.dictObjectsArray addObject:dictContent];
            
            if (array.count >= 2) {
                [tempContentDictionary addEntriesFromDictionary:@{[array objectAtIndex:0] : [array objectAtIndex:1]}];
            }
        }
        [self saveToCoreData];
        self.contentDict = [[NSDictionary alloc] initWithDictionary:tempContentDictionary];
        [self getRandomDictObject];
    }
    
    //[self printElements:self.contentDict];
    //[self printElements:self.dictObjectsArray];
}

- (NSArray *)getParsedArray {
    NSString *path = [NSHomeDirectory() stringByAppendingPathComponent:[@"Documents/" stringByAppendingString:googleVocab]];
    if ([[NSFileManager defaultManager] fileExistsAtPath:path] ) {
        return [[ParseCSV sharedManager] readCSVFile:path];
    } else {
        NSString *error = @"File is not exist";
        NSLog(@"%@", error);
        [self showAlert:error];
        return nil;
    }
}

#pragma mark - Private methods

- (void)printElements:(id)elements {
    if ([elements isKindOfClass:[NSDictionary class]]) {
        NSDictionary *dictElements = (NSDictionary *)elements;
        for (NSString *key in [dictElements allKeys]) {
                        NSLog(@"KEY:: %@", key);
                        NSLog(@"VALUE:: %@", [dictElements objectForKey:key]);
        }
    } else if ([elements isKindOfClass:[NSArray class]]) {
        NSArray *elementsArray = (NSArray *)elements;
        
        for (Dictionary *element in elementsArray) {
            NSLog(@"Element:: %@ %@", element.engAttribute,
                  element.rusAttribute);
        }
    }
}

- (NSUInteger )getRandomIndex {
    NSUInteger randomIndex = arc4random() % self.dictObjectsArray.count;
    NSLog(@"%ld", randomIndex);
    return randomIndex;
}

- (void)getRandomDictObject {
    NSUInteger index = [self getRandomIndex];
    if (self.dictObjectsArray.count != self.answeredIndexesArray.count) {
        while ([self.answeredIndexesArray containsObject:@(index)]) {
            index = [self getRandomIndex];
        }
    }
    
    [self.answeredIndexesArray addObject:[NSNumber numberWithInteger:index]];

    self.dictObject = [self.dictObjectsArray objectAtIndex:index];
}

- (void)displayResults{
    NSString *title = [NSString stringWithFormat:@"Result: %d/%d", _correctResult, _incorrectResult];
    NSString *correct = @": ";
    NSString *incorrect = @"/";
    
    NSDictionary *titleAttribute = @{NSForegroundColorAttributeName : [UIColor grayColor],
                                                NSFontAttributeName : [UIFont fontWithName:@"SinhalaSangamMN" size:18.0f]};
    NSDictionary *correctAttribute = @{NSForegroundColorAttributeName : [UIColor greenColor],
                                                  NSFontAttributeName : [UIFont fontWithName:@"SinhalaSangamMN-Bold" size:18.0f]};
    NSDictionary *incorrectAttribute = @{NSForegroundColorAttributeName : [UIColor redColor],
                                                    NSFontAttributeName : [UIFont fontWithName:@"SinhalaSangamMN-Bold" size:18.0f]};
    
    
    NSRange correctRange = [title rangeOfString:correct];
    NSRange incorrectRange = [title rangeOfString:incorrect];
    correctRange.location = correctRange.location + 1;
    incorrectRange.location = incorrectRange.location + 1;
    
    NSMutableAttributedString *atributedString = [[NSMutableAttributedString alloc] initWithString:title];
    [atributedString setAttributes:titleAttribute range:NSMakeRange(0, title.length)];
    [atributedString setAttributes:correctAttribute range:correctRange];
    [atributedString setAttributes:incorrectAttribute range:incorrectRange];
    
    UILabel *label = [[UILabel alloc] init];
    label.attributedText = atributedString;
    self.navigationItem.titleView = label;
    [self.navigationItem.titleView sizeToFit];
}

- (void)saveToCoreData {
    
//    for (Dictionary *dictObj in self.dictObjectsArray) {
//        [[CoreDataManager sharedManager] addDictionary:dictObj];
//        
//    }
    [[CoreDataManager sharedManager] addStorageWithName:@"Main Storage"];
    Vocabluary *vocab = [[CoreDataManager sharedManager] addVocabluaryWithName:googleVocab];
    [vocab addDictionaries:[NSMutableSet setWithArray:self.dictObjectsArray]];
    //[[CoreDataManager sharedManager] removeAllEntities];
}

- (BOOL)isSentenceExist {
    if (self.dictObject.sentenceAttribute && self.dictObject.sentenceAttribute.length > 0) {
        return YES;
    }
    return NO;
}

#pragma mark - Timer

- (void)startTimer {
    [self.timerLabel setAlpha:1];
    [self.timerLabel setHidden:NO];
    _timer = [NSTimer scheduledTimerWithTimeInterval:1.0f
                                              target:self
                                            selector:@selector(timerTick:)
                                            userInfo:nil
                                             repeats:YES];
    _sessionTimer = [NSTimer scheduledTimerWithTimeInterval:1.0f
                                                     target:self
                                                   selector:@selector(sessionTimerTick:)
                                                   userInfo:nil
                                                    repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:_timer
                                 forMode:NSDefaultRunLoopMode];
    [[NSRunLoop currentRunLoop] addTimer:_sessionTimer
                                 forMode:NSDefaultRunLoopMode];
}

- (void)stopTimer {
    [_timer invalidate];
    _timeSec = 0;
    
    
    [UIView animateWithDuration:0.6f animations:^{
        [self.timerLabel setAlpha:0];
    } completion:^(BOOL finished) {
        [self.timerLabel setHidden:YES];
        [self setupGestureRecognizer];
    }];
}

- (void)timerTick:(NSTimer *)timer {
    _timeSec++;
    
    if (_timeSec == 5 || self.showButton.isSelected) {
        [self stopTimer];
        if (!self.showButton.isSelected){
            [self actionShowResult:self.showButton];
        }
    }
    NSString *timerResult = [NSString stringWithFormat:@"%02d", _timeSec];
    self.timerLabel.text = timerResult;
}

- (void)sessionTimerTick:(NSTimer *)timer {
    _sessionSec++;
    if (_sessionSec % 5 == 0) {
        NSString *timerResult = [NSString stringWithFormat:@"%02d:%02d", _sessionMin, _sessionSec];
        NSLog(@"%@", timerResult);
    }
    
    if (_sessionSec == 60) {
        _sessionSec = 0;
        _sessionMin++;
    }
}

- (void)startPause {
    self.pauseStart = [NSDate dateWithTimeIntervalSinceNow:0];
    self.previousFireDate = [_sessionTimer fireDate];
    NSLog(@"%@ %@", self.pauseStart, self.previousFireDate);
    [_sessionTimer setFireDate:[NSDate distantFuture]];
}

- (void)resumePause {
    float pauseTime = -1 * [self.pauseStart timeIntervalSinceNow];
    [_sessionTimer setFireDate:[NSDate dateWithTimeInterval:pauseTime sinceDate:self.previousFireDate]];
}

#pragma mark - GestureRecognizer

- (void)setupGestureRecognizer {
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(actionSingleTap:)];
    singleTap.numberOfTapsRequired = 1;
    [self.view addGestureRecognizer:singleTap];
    
    UITapGestureRecognizer *doubleTap =
    [[UITapGestureRecognizer alloc] initWithTarget:self
                                            action:@selector(actionDoubleTap:)];
    doubleTap.numberOfTapsRequired = 2;
    [self.view addGestureRecognizer:doubleTap];
    [singleTap requireGestureRecognizerToFail:doubleTap];
    
    self.gestureRecognizerArray = [[NSArray alloc] initWithObjects:singleTap, doubleTap, nil];
}

- (void)actionSingleTap:(UITapGestureRecognizer *)recognizer {

    [self actionRecognizer:recognizer];
    NSLog(@"single tap");
}

- (void)actionDoubleTap:(UITapGestureRecognizer *)recognizer {
    [self actionRecognizer:recognizer];
    NSLog(@"double tap");
}

- (void)actionRecognizer:(UITapGestureRecognizer *)recognizer {
    CGPoint location = [recognizer locationInView:[recognizer.view superview]];
    CGRect frameLabel = [self.answerLabel convertRect:self.answerLabel.frame toView:self.view];
    CGRect frameimageView = [self.infoView convertRect:self.infoView.frame toView:self.view];
    if (recognizer.state == UIGestureRecognizerStateEnded && recognizer.numberOfTapsRequired > 1) {
        if (CGRectContainsPoint(frameLabel, location) && ![self.correctAnswersArray containsObject:self.dictObject]) {
            [self.incorrectAnswersArray addObject:self.dictObject];
            _incorrectResult++;
        }
    } else {
        if (CGRectContainsPoint(frameLabel, location) && ![self.incorrectAnswersArray containsObject:self.dictObject]) {
            [self.correctAnswersArray addObject:self.dictObject];
            _correctResult++;
        } else if (CGRectContainsPoint(frameimageView, location) && self.dictObject.sentenceAttribute.length > 0) {
            self.answerLabel.text = self.dictObject.sentenceAttribute;
        }
    }
    [self displayResults];
    [self removeGestureRecogniserInteration];
    
}

- (void)removeGestureRecogniserInteration {
    for (UIGestureRecognizer *gestureRecogniser in self.gestureRecognizerArray) {
        [self.view removeGestureRecognizer:gestureRecogniser];
    }
}

#pragma mark - Actions

- (IBAction)actionShowResult:(UIButton *)sender {
    sender.selected = ![sender isSelected];
    if (sender.selected) {
        if (self.segmentedControl.selectedSegmentIndex == StateLangEng) {
            self.answerLabel.text = self.dictObject.rusAttribute;
        } else if (self.segmentedControl.selectedSegmentIndex == StateLangRus) {
            self.answerLabel.text = self.dictObject.engAttribute;
        }
        [sender setTitle:@"NEXT" forState:UIControlStateSelected];
        [sender setTintColor:[UIColor whiteColor]];
        [sender setTitleColor:[UIColor darkGrayColor] forState:UIControlStateSelected];
        self.infoView.hidden = ![self isSentenceExist];
        
    } else {
        [self getRandomDictObject];
        [self showNextQuiz:self.segmentedControl];
        [sender setTitle:@"SHOW" forState:UIControlStateNormal];
        self.answerLabel.text = answerPlaceholder;
        [sender setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [self startTimer];
    }
}

- (IBAction)actionStartQuiz:(UIButton *)sender {
    [self setDefaultSettings];
    [self startTimer];
    [self hideStartViewWithAnimation];
}

- (IBAction)actionResume:(UIButton *)sender {
    [self resumePause];
    [self hideStartViewWithAnimation];
}

- (IBAction)actionInfo:(UIButton *)sender {
    StatisticViewController *statisticVC = [self.storyboard instantiateViewControllerWithIdentifier:@"StatisticViewController"];
    [self.navigationController pushViewController:statisticVC animated:YES];
    
}

- (void)actionSegment:(UISegmentedControl *)sender {
    
    [self showNextQuiz:sender];
}

- (void)showNextQuiz:(UISegmentedControl *)sender {
    if (sender.selectedSegmentIndex == StateLangEng) {
        self.quizLable.text = self.dictObject.engAttribute;
        
    } else if (sender.selectedSegmentIndex == StateLangRus) {
        self.quizLable.text = self.dictObject.rusAttribute;
        
    }
    
    self.answerLabel.text = answerPlaceholder;
}

- (void)actionShowStatistic:(UIBarButtonItem *)sender {
    [self startPause];
    [self setupStartView];
}

#pragma mark - Animation

- (void)hideStartViewWithAnimation {
    [UIView animateWithDuration:0.2
                     animations:^{
                         self.startView.alpha = 0.0;
                     } completion:^(BOOL finished) {
                         [self.startView setHidden:YES];
                         [visualEffectView removeFromSuperview];
                     }];
}

#pragma mark - Alert View

- (void)showAlert:(NSString *)message {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Warning"
                                                    message:message delegate:self
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
}
@end
