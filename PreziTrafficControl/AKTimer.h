//
//  AKTimer.h
//  AirTrafficControl
//
//  Created by Adam Kornafeld on 9/18/13.
//  Copyright (c) 2013 Adam Kornafeld. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, CountDirection)
{
  CountDown = 0,
  CountUp = 1,
};

@interface AKTimer : NSObject

@property (assign, nonatomic) NSInteger time;
@property (assign, nonatomic) NSInteger originalTime;
@property (assign, nonatomic) CountDirection countDirection;
@property (strong, nonatomic) dispatch_queue_t dispatchQueue;
@property (strong, nonatomic) dispatch_source_t timer;
@property (assign, nonatomic) BOOL timerSuspended;

+ (AKTimer *)timer;
- (void)resumeTimer;
- (void)suspendTimer;
- (void)resetTimer;
- (NSInteger)minutes;
- (NSInteger)seconds;
- (NSInteger)percentRemaining;
- (NSString *)description;

@end
