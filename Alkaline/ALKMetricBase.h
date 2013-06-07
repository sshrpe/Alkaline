//
//  ALKMetric.h
//  Alkaline
//
//  Created by Stuart Sharpe on 04/06/2013.
//  Copyright (c) 2013 sshrpe. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ALKMetric.h"



/*!
 Defines a base class which implements the ALKMetric protocol and returns 
 sensible default values for all methods. Subclass ALKMetricBase to quickly
 create performance tests.
 */
@interface ALKMetricBase : NSObject <ALKMetric>



@end
