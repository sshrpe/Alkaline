//
//  ALKMetric.h
//  Alkaline
//
//  Created by Stuart Sharpe on 07/06/2013.
//  Copyright (c) 2013 sshrpe. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef void(^ALKMetricCompletionHandler)(void);


/*!
 @protocol ALKMetric
 @abstract
 A metric defines a single performance criterium for your code. All objects conforming to
 ALKMetric
 */
@protocol ALKMetric <NSObject>


/*!
 @method title
 The title to use for the test. If this method is not implemented, the class name will
 be used as the test title.
 */
- (NSString *) title;


/*!
 @method repetitions
 @abstract The number of times the test should be run. The setUp and tearDown methods
 will be before and after each repetition, but only the length of time taken by the
 runTest method will be included in the result. By default, repetitions is 1.
 */
- (NSUInteger) repetitions;


/*!
 @method timeout
 @abstract The timeout value determines the longest time the test should run for before
 cancelling and failing. The default timeout value is 30 seconds. Note, the timeout refers
 to the amount of time a single repetition of the test should take.
 */
- (NSTimeInterval) timeout;


/*!
 @method setUp
 Any pre-test setup which should not be included in the result should be performed in
 the setUp method. This might include opening and loading sample data or creating objects
 which will be processed in the test, for example.
 */
- (void) setUp;


/*!
 @method tearDown
 Use the tearDown method to clear any artifacts left from the test (files, database objects,
 etc). Like setUp, this should include any operations which are not intended to be included
 in the result.
 */
- (void) tearDown;


/*!
 @method runTest
 In this method the performance test will be run. The time taken between the runTest method
 being called and the completed block being invoked will determine the test result time. The
 runTest: method will be called on a background thread. The test runner will wait for the
 completion handler to be called - it is fine to spawn asynchronous processes during the test.
 */
- (void) runTest:(ALKMetricCompletionHandler)completed;


/*!
 @method cancel
 In the event of the a timeout, the cancel method will be called to allow the test to be cancelled
 part way through. If the cancel method is called you should clear up any currently running operations.
 tearDown will be called after the cancel method.
 */
- (void) cancel;


@end
