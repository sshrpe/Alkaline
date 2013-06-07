//
//  ALKAppDelegate.h
//  AlkalineRunner
//
//  Created by Stuart Sharpe on 04/06/2013.
//  Copyright (c) 2013 sshrpe. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ALKTestResultsViewController;

@interface ALKAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) ALKTestResultsViewController *viewController;

@end
