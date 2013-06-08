//
//  ALKMetric.h
//  Alkaline
//
//  Created by Stuart Sharpe on 04/06/2013.
//  Copyright (c) 2013 sshrpe. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ALKMetric.h"


typedef void(^ALKMetricExecutionBlock)(void);

/*!
 @class ALKMetricBase
 Defines a base class which implements the ALKMetric protocol and returns
 sensible default values for all methods. Subclass ALKMetricBase to quickly
 create a battery of repeatable performance tests, or create instances and 
 use the execution blocks to define and create metrics at runtime.
 */
@interface ALKMetricBase : NSObject <ALKMetric>

/// Repetitions defaults to one on initialisation.
@property (assign) NSUInteger repetitions;

/// Name defaults to the name of the metric class on initialisation.
@property (strong) NSString * name;


// Use these properties to add test code to a metric instance.
@property (copy) ALKMetricExecutionBlock setUpBlock;
@property (copy) ALKMetricExecutionBlock runTestBlock;
@property (copy) ALKMetricExecutionBlock tearDownBlock;

@property (getter = isCancelled) BOOL cancelled;

@end
