# Alkaline

## A performance testing framework for iOS.

- Test performance of your code in isolation.
- Run performance tests on any device.
- Run tests whilst using Instruments to isolate parts of your application for in-depth performance and memory analysis.

## Defining Test Metrics

Metrics are defined as objects which conform to the `ALKMetric` protocol. The class `ALKMetricBase` provides a basic metric which can be subclassed to add test code. To create a simple metric, implement the `runTest:` method, which runs the code being measured by the test. `setUp` and `tearDown` methods can also be subclassed provided to allow setup code which should not be included in the test (for instance, fetching objects from Core Data to be processed in the `runTest` method). Metrics can also provide a `name` to be displayed in the UI, and a number of `repetitions` if it is desired to include multiple iterations of the test in the final result (this is advised to provide better result averaging).

```objc

@interface MyMetric : ALKMetricBase

@end

@implementation

- (void) setUp
{
    // Load any data or application state required for the test
}


- (void) runTest:(ALKMetricCompletionHandler)completed;
{
    // Any code in this method is timed. Call the completed block once the test is finished.
    completed();
}


- (void) tearDown
{
    // Clear up any state or data created in setUp
}

@end

```

## Methods of Running Tests

Different situations and metrics require different kinds of tests. Alkaline will (eventually) support three methods of running performance tests:

- **In-app tests** - include the Alkaline library in your app, push an `ALKTestResultsViewController` to the screen, hit the run button and you're done.
- **Standalone test bed app** - run tests on a device in isolation from the rest of the app. Requires creating a new application target in Xcode including the Alkaline library and the code to be tested. An example of this approach called `AlkalineRunner` is included in the Alkaline project.
- **Command line utility** *(coming soon)* - run tests from the command line or integrate with CI server

## Test Result Output

Currently test results have minimum basic output through `NSLogs` and the `ALKTestResultsViewController`. You can also build your own UI if desired, using the methods in `ALKTestRunner`

- Standalone test bed app (AlkalineRunner)
- Default output UI within app (`ALKTestResultsViewController`)
- Build-your-own UI within app (you're on your own for this)
- Command line output *(coming soon)*
- CSV/XML/JSON results report *(coming soon)*

## Feature Ideas

These are ideas for things Alkaline might support in the future.

- Simpler method for definining and running multiple test suites.
- Support for running metrics with A/B comparisons.
- Benchmarking against previous test runs.
- CocoaPods integration

## Contact

- [@stuartsharpe](http://twitter.com/stuartsharpe) on Twitter
- [@sshrpe](http://alpha.app.net/sshrpe) on App.Net

