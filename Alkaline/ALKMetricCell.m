//
//  ALKMetricCell.m
//  Alkaline
//
//  Created by Stuart Sharpe on 05/06/2013.
//  Copyright (c) 2013 sshrpe. All rights reserved.
//

#import "ALKMetricCell.h"
#import "ALKMetricBase.h"
#import "ALKTestResult.h"


@implementation ALKMetricCell


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}


- (void) displayMetric:(ALKMetricBase *)metric withResult:(ALKTestResult *)result;
{
    self.textLabel.text = metric.title;
    if (result) {
        if (!result.timedOut) {
            self.accessoryType = UITableViewCellAccessoryCheckmark;
        } else {
            self.accessoryType = UITableViewCellAccessoryNone;
        }
    } else {
        self.accessoryType = UITableViewCellAccessoryNone;
    }
}


@end

