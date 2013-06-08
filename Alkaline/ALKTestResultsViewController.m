//
//  ALKTestResultsViewController.m
//  Alkaline
//
//  Created by Stuart Sharpe on 04/06/2013.
//  Copyright (c) 2013 sshrpe. All rights reserved.
//

#import "ALKTestResultsViewController.h"
#import "ALKTestRunner.h"
#import "ALKMetricBase.h"
#import "ALKTestResult.h"
#import "ALKMetricCell.h"


@interface ALKTestResultsViewController ()

@property (strong) ALKTestRunner *testRunner;

@end

@implementation ALKTestResultsViewController


- (id)initWithTestRunner:(ALKTestRunner *)testRunner
{
    self = [super initWithStyle:UITableViewStylePlain];
    if (self) {
        if (testRunner) {
            _testRunner = testRunner;
        } else {
            _testRunner = [[ALKTestRunner alloc] init];
        }
    }
    return self;
}


- (id)initWithStyle:(UITableViewStyle)style
{
    return [self initWithTestRunner:[[ALKTestRunner alloc] init]];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.tableView registerClass:[ALKMetricCell class] forCellReuseIdentifier:@"MetricCell"];
    
    self.title = NSLocalizedString(@"Test Results", @"View Title");
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Run", @"Button Title")
                                                                              style:UIBarButtonItemStyleBordered
                                                                             target:self action:@selector(runTests:)];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Running Tests


- (void) runTests:(id)sender
{
    [self.testRunner beginTestsWithResultHandler:^(ALKMetricBase *metric, NSUInteger idx, ALKTestResult *result) {
        NSLog(@"Completed %@ in %f", metric.name, result.testTime);
        NSIndexPath *cellPath = [NSIndexPath indexPathForRow:idx inSection:0];
        [self.tableView reloadRowsAtIndexPaths:@[cellPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    }];
    [self.tableView reloadData];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [[self.testRunner metrics] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"MetricCell";
    ALKMetricCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    ALKMetricBase *metric = [[self.testRunner metrics] objectAtIndex:indexPath.row];
    ALKTestResult *result = [self.testRunner resultForMetric:metric];
    [cell displayMetric:metric withResult:result];
    
    return cell;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [[tableView cellForRowAtIndexPath:indexPath] setSelected:NO];
}

@end
