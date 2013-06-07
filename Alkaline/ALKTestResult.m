//
//  ALKTestResult.m
//  Alkaline
//
//  Created by Stuart Sharpe on 05/06/2013.
//  Copyright (c) 2013 sshrpe. All rights reserved.
//

#import "ALKTestResult.h"

@implementation ALKTestResult

- (id) initWithMetric:(id<ALKMetric>)metric;
{
    self = [super init];
    if (self) {
        _metric = metric;
    }
    return self;
}

@end
