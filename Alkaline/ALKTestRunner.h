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

typedef void(^ALKTestResultHandler)(id<ALKMetric> metric, NSUInteger idx, ALKTestResult *result);


/*!
 @class ALKTestRunner
 @abstract 
*/
 
@interface ALKTestRunner : NSObject


#pragma mark - Initialisation

/*!
 @method initWithMetrics:
 Create a test runner to test the provided battery of metrics. If metrics is nil,
 the test runner will be created with all objects conforming to the ALKMetric
 protocol.
 */
- (id) initWithMetrics:(NSArray *)metrics;


// The metrics this test runner will test when run.
@property (readonly) NSArray * metrics;


#pragma mark - Running tests

/*!
 @method beginTestsWithResultHandler:
 Starts testing the test runner's metrics. The result handler block will be called 
 after each metric has finished its test, including the result. Test results can also 
 be fetched using the resultForMetric: method.
 
 Calling beginTestsWithResultHandler: while testing is already in progress will cause
 an exception to be thrown. Once testing has completed, beginning tests again will 
 */
- (void) beginTestsWithResultHandler:(ALKTestResultHandler)block;

/*!
 @property active
 YES when tests are in progress.
 */
@property (readonly, getter = isActive) BOOL active;

/*!
 @method cancelTests
 Stops test execution.
 */
- (void) cancelTests;


#pragma mark - Test Results

/*!
 @method resultForMetric:
 Returns the result for the current metric as an ALKResult object, or nil if the metric
 does not currently have a result (ie. the metric has not been tested yet)
 */
- (ALKTestResult *) resultForMetric:(id<ALKMetric>)metric;


/*!
 @method results
 Returns all the results of the most recent test as an array of ALKTestResult objects
*/
- (NSArray *) results;

@end
