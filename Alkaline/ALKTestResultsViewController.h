//
//  ALKTestResultsViewController.h
//  Alkaline
//
//  Created by Stuart Sharpe on 04/06/2013.
//  Copyright (c) 2013 sshrpe. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ALKTestRunner;

@interface ALKTestResultsViewController : UITableViewController

- (id) initWithTestRunner:(ALKTestRunner *)testRunner;

@end
