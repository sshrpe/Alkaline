//
//  ALKTestResult.h
//  Alkaline
//
//  Created by Stuart Sharpe on 05/06/2013.
//  Copyright (c) 2013 sshrpe. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    kALKTestResultStatusFailed = 1000,
    kALKTestResultStatusWarning,
    kALKTestResultStatusSucceeded
} ALKTestResultStatus;

@protocol ALKMetric;


@interface ALKTestResult : NSObject

- (id) initWithMetric:(id<ALKMetric>)metric;

@property (readonly) id<ALKMetric> metric;

@property ALKTestResultStatus resultStatus;

@property (assign) BOOL timedOut;

@property (assign) NSTimeInterval testTime;

@end
