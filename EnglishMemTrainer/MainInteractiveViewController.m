//
//  MainInteractiveViewController.m
//  EnglishMemTrainer
//
//  Created by MacBookPro - Yuriy  on 7/14/16.
//  Copyright © 2016 com.mac.yuriy. All rights reserved.
//

#import "MainInteractiveViewController.h"
#import "SWRevealViewController.h"
#import "ParseCSV.h"
#import "Dictionary.h"
#import "StatisticViewController.h"

static NSString * const answerPlaceholder = @"Answer";

@interface MainInteractiveViewController () {
    UIVisualEffectView *visualEffectView;
    NSTimer *_timer;
    int _timeSec;
    int _correctResult;
    int _incorrectResult;
}

@property (strong, nonatomic) NSMutableArray *answeredIndexesArray;
@property (strong, nonatomic) Dictionary *dictObject;
@property (strong, nonatomic) NSArray *gestureRecognizerArray;

@end

@implementation MainInteractiveViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupRevealController];

    [self initDictionaryWithParsedFile:[self getParsedArray]];
    [self getRandomDictObject];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (!visualEffectView) {
        [self setupStartView];
    }
    
    [self setupShowUIButton];
    [self setupSegmentedControl];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - UI Setup

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
    [self.view bringSubviewToFront:self.startView];
}

- (void)setupRightStatisticButton {
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemBookmarks
                                                                                 target:self
                                                                                 action:@selector(actionShowStatistic:)];
    [self.navigationItem setRightBarButtonItem:rightButton];
}

- (void)initDictionaryWithParsedFile:(NSArray *)parsedArray {
    NSMutableDictionary *tempContentDictionary =[NSMutableDictionary dictionary];
    self.dictObjectsArray = [NSMutableArray array];
    
    for (NSArray *array in parsedArray) {
        Dictionary *dictContent = [[Dictionary alloc] initWithArray:array];
        [self.dictObjectsArray addObject:dictContent];
        
        if (array.count >= 2) {
            [tempContentDictionary addEntriesFromDictionary:@{[array objectAtIndex:0] : [array objectAtIndex:1]}];
        }
    }
    self.contentDict = [[NSDictionary alloc] initWithDictionary:tempContentDictionary];
    //[self printElements:self.contentDict];
    //[self printElements:self.dictObjectsArray];
}

- (NSArray *)getParsedArray {
    NSString *path = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/google.csv"];
    return [[ParseCSV sharedManager] readCSVFile:path];
}

- (void)setDefaultSettings {
    self.answeredIndexesArray = [NSMutableArray array];
    self.correctAnswersArray = [NSMutableArray array];
    self.incorrectAnswersArray = [NSMutableArray array];
    [self setupRightStatisticButton];
    [self displayResults];
    [self actionSegment:self.segmentedControl];
    
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
            NSLog(@"Element:: %@ %@", element.engString,
                  element.rusString);
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

#pragma mark - Timer

- (void)startTimer {
    [self.timerLabel setAlpha:1];
    [self.timerLabel setHidden:NO];
    _timer = [NSTimer scheduledTimerWithTimeInterval:1.0f
                                              target:self
                                            selector:@selector(timerTick:)
                                            userInfo:nil
                                             repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:_timer
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
    NSString *timerResult = [NSString stringWithFormat:@"%02d", _timeSec];
    self.timerLabel.text = timerResult;
    if (_timeSec == 5) {
        [self stopTimer];
        [self actionShowResult:self.showButton];
    }
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
    CGRect frame = [self.answerLabel convertRect:self.answerLabel.frame toView:self.view];
    if (recognizer.state == UIGestureRecognizerStateEnded && recognizer.numberOfTapsRequired > 1) {
        if (CGRectContainsPoint(frame, location) && ![self.correctAnswersArray containsObject:self.dictObject]) {
            [self.incorrectAnswersArray addObject:self.dictObject];
            _incorrectResult++;
        }
    } else {
        if (CGRectContainsPoint(frame, location) && ![self.incorrectAnswersArray containsObject:self.dictObject]) {
            [self.correctAnswersArray addObject:self.dictObject];
            _correctResult++;
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


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - Actions

- (IBAction)actionShowResult:(UIButton *)sender {
    sender.selected = ![sender isSelected];
    if (sender.selected) {
        if (self.segmentedControl.selectedSegmentIndex == StateLangEng) {
            self.answerLabel.text = self.dictObject.rusString;
        } else if (self.segmentedControl.selectedSegmentIndex == StateLangRus) {
            self.answerLabel.text = self.dictObject.engString;
        }
        [sender setTitle:@"NEXT" forState:UIControlStateSelected];
        [sender setTintColor:[UIColor whiteColor]];
        [sender setTitleColor:[UIColor darkGrayColor] forState:UIControlStateSelected];
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
    
    [UIView animateWithDuration:0.2
                     animations:^{
                         self.startView.alpha = 0.0;
                     } completion:^(BOOL finished) {
                         [self.startView removeFromSuperview];
                         [visualEffectView removeFromSuperview];
                     }];
}

- (void)actionSegment:(UISegmentedControl *)sender {
    
    [self showNextQuiz:sender];
}

- (void)showNextQuiz:(UISegmentedControl *)sender {
    if (sender.selectedSegmentIndex == StateLangEng) {
        self.quizLable.text = self.dictObject.engString;
        
    } else if (sender.selectedSegmentIndex == StateLangRus) {
        self.quizLable.text = self.dictObject.rusString;
        
    }
    
    self.answerLabel.text = answerPlaceholder;
}

- (void)actionShowStatistic:(UIBarButtonItem *)sender {
    StatisticViewController *statisticVC = [self.storyboard instantiateViewControllerWithIdentifier:@"StatisticViewController"];
    [self.navigationController pushViewController:statisticVC animated:YES];
    
}
@end
