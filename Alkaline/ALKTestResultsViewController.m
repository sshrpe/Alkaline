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
    [sender setEnabled:NO];
    [self.testRunner beginTestingMetricsUsingBlock:^(ALKMetricBase *metric, NSUInteger idx, ALKTestResult *result) {
        NSLog(@"Completed %@ in %f", metric.title, result.testTime);
        ALKMetricCell *cell = (ALKMetricCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:idx inSection:0]];
        [cell displayMetric:metric withResult:result];
    }];
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
    
    [cell displayMetric:metric withResult:[self.testRunner resultForMetric:metric]];
    
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

@end
