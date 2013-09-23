//
//  AKViewController.h
//  PreziTrafficControl
//
//  Created by Adam Kornafeld on 9/23/13.
//  Copyright (c) 2013 Adam Kornafeld. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AKViewController : UIViewController

@property (strong, nonatomic) IBOutlet UILabel *timeLabel;
@property (strong, nonatomic) IBOutlet UIButton *setButton;
@property (strong, nonatomic) IBOutlet UIButton *resetButton;
@property (strong, nonatomic) IBOutlet UISwitch *timerSwitch;

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *timerSwitchBottomSpacer;

@property (strong, nonatomic) IBOutlet UITableView *tableView;

- (IBAction)timerSwitchValueDidChange: (id)sender;
- (IBAction)setButtonTouchUpInside: (id)sender;
- (IBAction)resetButtonTouchUpInside: (id)sender;

@end
