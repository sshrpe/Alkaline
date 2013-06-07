//
//  ALKMetricCell.h
//  Alkaline
//
//  Created by Stuart Sharpe on 05/06/2013.
//  Copyright (c) 2013 sshrpe. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ALKTestResult, ALKMetricBase;

@interface ALKMetricCell : UITableViewCell

- (void) displayMetric:(ALKMetricBase *)metric withResult:(ALKTestResult *)result;

@end
