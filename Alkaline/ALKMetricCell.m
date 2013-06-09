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

@interface ALKMetricCell ()

@property (strong) UIActivityIndicatorView *activityIndicator;

@end

@implementation ALKMetricCell


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.textLabel.backgroundColor = [UIColor clearColor];
        self.detailTextLabel.backgroundColor = [UIColor clearColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
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
    // Displaying a new metric causes the cell to no longer be active.
    self.active = NO;
    
    self.textLabel.text = metric.name;
    if (result) {
        switch(result.resultStatus) {
            case kALKTestResultStatusFailed:
                self.contentView.backgroundColor = [UIColor redColor];
                self.detailTextLabel.text = [NSString stringWithFormat:@"%fs", result.testTime];
                break;
            case kALKTestResultStatusWarning:
                self.contentView.backgroundColor = [UIColor yellowColor];
                self.detailTextLabel.text = [NSString stringWithFormat:@"%fs", result.testTime];
                break;
            case kALKTestResultStatusSucceeded:
                self.contentView.backgroundColor = [UIColor greenColor];
                self.detailTextLabel.text = [NSString stringWithFormat:@"%fs", result.testTime];
                break;
        }
    } else {
        self.contentView.backgroundColor = [UIColor whiteColor];
        self.detailTextLabel.text = @"";
    }
}


- (void) setActive:(BOOL)active
{
    if (_active == active) {
        return;
    }
    
    if (active) {
        self.activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        [self.activityIndicator setCenter:CGPointMake(CGRectGetMaxX(self.contentView.frame)-20, CGRectGetMidY(self.contentView.frame))];
        [self.contentView addSubview:self.activityIndicator];
        [self.activityIndicator startAnimating];
    } else {
        [self.activityIndicator removeFromSuperview];
        self.activityIndicator = nil;
        [self setNeedsLayout];
    }
}



@end

