//
//  ALKTestRunner.h
//  Alkaline
//
//  Created by Stuart Sharpe on 04/06/2013.
//  Copyright (c) 2013 sshrpe. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ALKTestResult;
@protocol ALKMetric;

typedef void(^ALKTestCompletionBlock)(id<ALKMetric> metric, NSUInteger idx, ALKTestResult *result);


@interface ALKTestRunner : NSObject


#pragma mark - Initialisation

/*!
 initWithMetrics:
 Create a test runner to test the provided battery of metrics. If metrics is nil,
 the test runner will be created with all objects conforming to the ALKMetric
 protocol
 */
- (id) initWithMetrics:(NSArray *)metrics;

@property (readonly) NSArray * metrics;


#pragma mark - Running tests

- (void) beginTestingMetricsUsingBlock:(ALKTestCompletionBlock)completionBlock;

- (ALKTestResult *) resultForMetric:(id<ALKMetric>)metric;

- (void) cancelTests;

@property (readonly, getter = isActive) BOOL active;

@end
