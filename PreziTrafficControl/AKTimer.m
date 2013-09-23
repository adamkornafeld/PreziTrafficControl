//
//  AKTimer.m
//  AirTrafficControl
//
//  Created by Adam Kornafeld on 9/18/13.
//  Copyright (c) 2013 Adam Kornafeld. All rights reserved.
//

#import "AKTimer.h"

static const int kDefaultTime = 120;

@interface AKTimer ()

@end

@implementation AKTimer

+ (AKTimer *)timer
{
  static AKTimer *instance = nil;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    instance = [[AKTimer alloc] init];
  });
  return instance;
}

- (id)init
{
  self = [super init];
  if (self)
  {
    _timerSuspended = YES;
    _time = _originalTime = kDefaultTime;
    _countDirection = CountDown;

    _dispatchQueue = dispatch_queue_create("com.PreziTrafficControl.AKTimer", NULL);
    _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, self.dispatchQueue);
    _timerSuspended = YES;

    __weak AKTimer *_self = self;
    dispatch_source_set_event_handler(_self.timer, ^(void){
      if (_self.countDirection == CountDown) _self.time -= 1;
      else _self.time += 1;
      if (_self.time == 0) _self.countDirection = CountUp;
    });

  }
  return self;
}

- (void)resumeTimer
{
  if (self.timerSuspended == YES)
  {
    dispatch_source_set_timer(_timer, dispatch_time(DISPATCH_TIME_NOW, NSEC_PER_SEC),
                              NSEC_PER_SEC, 0ull);

    dispatch_resume(self.timer);
    self.timerSuspended = NO;
  }
}

- (void)suspendTimer
{
  if (self.timerSuspended == NO)
  {
    dispatch_suspend(self.timer);
    self.timerSuspended = YES;
  }
}

- (void)resetTimer
{
  self.time = self.originalTime;
  self.countDirection = CountDown;
  [self suspendTimer];
}

- (NSInteger)minutes
{
  return self.time / 60;
}

- (NSInteger)seconds
{
  return self.time % 60;
}

- (NSInteger)percentRemaining
{
  return ((double)self.time / self.originalTime) * 100;
}

- (NSString *)description
{
  BOOL colon = (self.time % 2);
  NSInteger minutes = self.minutes;
  NSInteger originalMinutes = self.originalTime / 60;
  if (self.countDirection == CountDown && minutes >= 1 && (minutes + 1) <= originalMinutes) minutes += 1;
  NSInteger seconds = (self.countDirection == CountDown && minutes > 1) ? 0 : self.seconds;

  return [NSString stringWithFormat: (colon || self.originalTime == self.time) ? @"%02d:%02d" : @"%02d %02d", minutes, seconds];
}

@end
