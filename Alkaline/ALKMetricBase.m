//
//  ALKMetric.m
//  Alkaline
//
//  Created by Stuart Sharpe on 04/06/2013.
//  Copyright (c) 2013 sshrpe. All rights reserved.
//

#import "ALKMetricBase.h"

@implementation ALKMetricBase


- (id)init
{
    self = [super init];
    if (self) {
        self.repetitions = 1;
        self.name = NSStringFromClass([self class]);
    }
    return self;
}

- (void) setUp
{
    if (self.setUpBlock) {
        self.setUpBlock();
    }
}


- (void) runTest:(ALKMetricCompletionHandler)completed;
{
    // The superclass will run the test block
    if (self.runTestBlock) {
        self.runTestBlock();
    }

    if (completed) {
        if (!self.cancelled) {
            completed();
        }
    }
}


- (void) tearDown
{
    if (self.tearDownBlock) {
        self.tearDownBlock();
    }
}


- (void) cancel;
{
}


@end
