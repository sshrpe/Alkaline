//
//  RenderGraphicsMetric.m
//  Alkaline
//
//  Created by Stuart Sharpe on 04/06/2013.
//  Copyright (c) 2013 sshrpe. All rights reserved.
//

#import "RenderGraphicsMetric.h"

@implementation RenderGraphicsMetric


- (NSString *)name
{
    return @"Render 500 green squares";
}

- (NSUInteger)repetitions
{
    return 500;
}

- (void) runTest:(ALKMetricCompletionHandler)completed
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        UIGraphicsBeginImageContext(CGSizeMake(1000, 1000));
        
        [[UIColor greenColor] set];
        UIRectFill(CGRectMake(0, 0, 1000, 1000));
        
        UIGraphicsGetImageFromCurrentImageContext();
        
        UIGraphicsEndImageContext();
        completed();
    });
    
}

@end
