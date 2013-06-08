//
//  ALKTestRunner.m
//  Alkaline
//
//  Created by Stuart Sharpe on 04/06/2013.
//  Copyright (c) 2013 sshrpe. All rights reserved.
//

#import "ALKTestRunner.h"
#import "ALKMetricBase.h"
#import "ALKTestOperation.h"
#import <objc/runtime.h>
#import "ALKTestResult.h"

@interface ALKTestRunner ()

@property (strong) NSOperationQueue *testQueue;

@property (strong) NSMutableDictionary *testResults;

@property (strong) NSMutableDictionary *metricsByUUID;

@property (strong) NSArray *metrics;

@property (assign) BOOL active;

@end


static NSArray * __allMetrics = nil;


@implementation ALKTestRunner 


- (id) init
{
    // initialiser returns a test runner with every available metric listed.
    return [self initWithMetrics:nil];
}


- (id) initWithMetrics:(NSArray *)metrics
{
    self = [super init];
    if (self) {
        
        self.metricsByUUID = [NSMutableDictionary dictionary];
        self.testResults = [NSMutableDictionary new];
        
        if (!metrics) {
            metrics = [ALKTestRunner allMetrics];
        }
        _metrics = metrics;
        
        for (id<ALKMetric>metric in metrics) {
            // Assign each metric in the suite a UUID to allow results to be keyed by metric
            NSString *uuid = [[NSUUID UUID] UUIDString];
            [self.metricsByUUID setObject:metric forKey:uuid];
        }
    }
    return self;
}


#pragma mark - Loading Metrics

+ (NSArray *) allMetrics
{
    if (__allMetrics) {
        return __allMetrics;
    }
    
    NSMutableArray *metrics = [NSMutableArray array];
    
    // Get a list of all the classes available in the current runtime
    NSInteger numberOfClasses = objc_getClassList(NULL, 0);
    Class *classes = NULL;
    classes = (__unsafe_unretained Class *)malloc(numberOfClasses * sizeof(Class));
    numberOfClasses = objc_getClassList(classes, numberOfClasses);
    
    for (NSInteger idx = 0; idx < numberOfClasses; idx++) {
        Class class = classes[idx];
        // Find all clases implementing the ALKMetric, ignoring the abstract superclasses
        if (class_getClassMethod(class, @selector(conformsToProtocol:)) &&
            [class conformsToProtocol:@protocol(ALKMetric)] &&
            class != [ALKMetricBase class]) {
            
            NSLog(@"%@", NSStringFromClass(class));
            
            id metric = [[class alloc] init];
            [metrics addObject:metric];
        }
    }
    free(classes);
    
    __allMetrics = [NSArray arrayWithArray:metrics];
    return __allMetrics;
}


#pragma mark - Running Tests

- (void) beginTestsWithResultHandler:(ALKTestResultHandler)completionBlock;
{
    NSAssert(!self.active, @"Call to beginTestsWithResultHandler when test runner is already active");
    
    __weak ALKTestRunner *blockSelf = self;    
    
    self.testQueue = [[NSOperationQueue alloc] init];
    self.testQueue.maxConcurrentOperationCount = 1;
    self.testQueue.suspended = YES;
    
    [self.testResults removeAllObjects];
    
    for (NSString *metricID in [self.metricsByUUID allKeys]) {
        
        id<ALKMetric> metric = [self.metricsByUUID objectForKey:metricID];
        
        ALKTestOperation *testOperation = [[ALKTestOperation alloc] initWithMetric:metric];
        
        __weak ALKTestOperation *weakOperation = testOperation;
        [testOperation setCompletionBlock:^{
            dispatch_async(dispatch_get_main_queue(), ^{
                [blockSelf setResult:(weakOperation.result) forMetric:metric];
                if (completionBlock) {
                    completionBlock(metric, [[self.metricsByUUID allKeys] indexOfObject:metricID], weakOperation.result);
                }
            });
        }];
        
        [self.testQueue addOperation:testOperation];
    }
    
    [self.testQueue addOperationWithBlock:^{
        blockSelf.active = NO;
    }];
    [self.testQueue setSuspended:NO];
    self.active = YES;
}

- (void) cancelTests;
{
    NSAssert(self.active, @"Tests cancelled when no tests were running");
    
    // Cancel all operations, suspend the queue and mark as not active
    [self.testQueue cancelAllOperations];
    [self.testQueue setSuspended:YES];
    self.testQueue = nil;
    self.active = NO;
}


#pragma mark - Results


- (void) setResult:(ALKTestResult *)result forMetric:(id<ALKMetric>)metric;
{
    // Metrics are currently keyed by their class name. Only one test of each class is permitted per
    NSString *keyForMetric = [[self.metricsByUUID allKeysForObject:metric] lastObject];
    if (keyForMetric) {
        [self.testResults setObject:result forKey:keyForMetric];
    }
}


- (ALKTestResult *) resultForMetric:(ALKMetricBase *)metric;
{
    NSString *keyForMetric = [[self.metricsByUUID allKeysForObject:metric] lastObject];
    if (!keyForMetric) {
        return nil;
    }
    return [self.testResults objectForKey:keyForMetric];
}


- (NSArray *) results;
{
    return [self.testResults allValues];
}

@end
