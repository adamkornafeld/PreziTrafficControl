//
//  AKViewController.m
//  PreziTrafficControl
//
//  Created by Adam Kornafeld on 9/23/13.
//  Copyright (c) 2013 Adam Kornafeld. All rights reserved.
//

#import "AKViewController.h"
#import "AKTimer.h"

static const double kFontSize = 90.;

@interface AKViewController () <UIActionSheetDelegate>

@property (nonatomic, strong) UITapGestureRecognizer *tapRecognizer;

@end

@implementation AKViewController

- (void)viewDidLoad
{
  [super viewDidLoad];
  
  self.timerSwitch.on = NO;
  
  [[AKTimer timer] addObserver: self forKeyPath: @"time" options: NSKeyValueObservingOptionNew context: nil];
  [[AKTimer timer] addObserver: self forKeyPath: @"timerSuspended" options: NSKeyValueObservingOptionNew context: nil];
  [[AKTimer timer] addObserver: self forKeyPath: @"countDirection" options: NSKeyValueObservingOptionNew context: nil];
  
  self.tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget: self
                                                               action: @selector(viewTapInside:)];
  [self.view addGestureRecognizer: self.tapRecognizer];
  
  [self.timeLabel setText: [[AKTimer timer] description]];
}

- (void)didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

- (void)viewTapInside: (id)sender
{
  [self.view setNeedsUpdateConstraints];
  CGFloat constant = (self.timerSwitchBottomSpacer.constant > 0) ? -40.f : 20.f;
  [self.timerSwitchBottomSpacer setConstant: constant];
  
  [UIView animateWithDuration: .5 animations: ^{
    [self.view layoutIfNeeded];
  }];
}

- (void)flickr
{
  __block CGFloat duration = ((float)arc4random() / RAND_MAX) * (1.f-0.f);
  CGFloat alpha = ((float)arc4random() / RAND_MAX) * (1.f-0.f);
  [UIView animateWithDuration: duration animations:^{
    [self.timeLabel setAlpha: alpha];
  } completion:^(BOOL finished) {
    [self flickr];
  }];
}

#pragma mark - KVO

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
  dispatch_async(dispatch_get_main_queue(), ^{
    
    if (object == [AKTimer timer])
    {
      if ([keyPath isEqualToString: @"time"])
      {
        [self.timeLabel setText: [[AKTimer timer] description]];
        NSInteger percentRemaining = [AKTimer timer].percentRemaining;
        CountDirection direction = [AKTimer timer].countDirection;
        UIFont *font = [UIFont fontWithName: @"HelveticaNeue-Thin" size: kFontSize];
        if (direction == CountDown && percentRemaining >= 75)
        {
          font = [UIFont fontWithName: @"HelveticaNeue-Thin" size: kFontSize];
        }
        else if (direction == CountDown && percentRemaining >= 50)
        {
          font = [UIFont fontWithName: @"HelveticaNeue-Light" size: kFontSize];
        }
        else if (direction == CountDown && percentRemaining >= 25)
        {
          font = [UIFont fontWithName: @"HelveticaNeue" size: kFontSize];
        }
        else if (direction == CountUp)
        {
          font = [UIFont fontWithName: @"HelveticaNeue-Bold" size: kFontSize];
        }
        else
        {
          font = [UIFont fontWithName: @"HelveticaNeue-Medium" size: kFontSize];
        }
        [self.timeLabel setFont: font];
      }
      else if ([keyPath isEqualToString: @"timerSuspended"])
      {
        if ([AKTimer timer].timerSuspended == YES)
        {
          [self.timeLabel setText: [[AKTimer timer] description]];
        }
      }
      else if ([keyPath isEqualToString: @"countDirection"])
      {
        if ([AKTimer timer].countDirection == CountUp)
        {
          [self flickr];
        }
      }
    }
  });
}

#pragma mark - UI delegates

- (IBAction)timerSwitchValueDidChange: (id)sender
{
  UISwitch *timerSwitch = (UISwitch *)sender;
  if (timerSwitch.isOn)
  {
    [[AKTimer timer] resumeTimer];
    if ([AKTimer timer].countDirection == CountUp)
    {
      [self flickr];
    }
  }
  else
  {
    [[AKTimer timer] suspendTimer];
  }
}

- (IBAction)setButtonTouchUpInside: (id)sender
{
  
  
  UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle: @"Hello"
                                                           delegate: self
                                                  cancelButtonTitle: nil
                                             destructiveButtonTitle: nil
                                                  otherButtonTitles: nil];
  UIDatePicker *datePicker = [[UIDatePicker alloc] initWithFrame: CGRectMake(0, -180.f, 320.f, 180.f)];
  datePicker.datePickerMode = UIDatePickerModeCountDownTimer;
  //  [actionSheet addSubview: toolbar];
  [actionSheet addSubview: datePicker];
  [actionSheet showInView: self.view];
}

- (IBAction)resetButtonTouchUpInside: (id)sender
{
  if (self.timerSwitch.isOn == YES)
  {
    [self.timerSwitch setOn: NO animated: YES];
  }
  [[AKTimer timer] resetTimer];
}

#pragma mark - UIActionSheet delegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
  [actionSheet dismissWithClickedButtonIndex: buttonIndex animated: YES];
}

@end
