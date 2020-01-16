import XCTest

#if !canImport(ObjectiveC)
    public func allTests() -> [XCTestCaseEntry] {
        [
            testCase(PodcastTests.allTests),
            testCase(PodcastFeedKitTests.allTests),
        ]
    }
#endif
