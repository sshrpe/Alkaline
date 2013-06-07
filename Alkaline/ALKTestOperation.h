//
//  ALKTestOperation.h
//  Alkaline
//
//  Created by Stuart Sharpe on 04/06/2013.
//  Copyright (c) 2013 sshrpe. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ALKMetric;
@class ALKTestResult;


@interface ALKTestOperation : NSOperation


- (id) initWithMetric:(id<ALKMetric>)metric;


@property (readonly, strong) id<ALKMetric> metric;


@property (readonly, strong) ALKTestResult *result;


@property (readonly, strong) NSError *error;


@end

