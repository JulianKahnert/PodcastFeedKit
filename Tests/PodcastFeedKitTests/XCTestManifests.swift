/**
 XCTestManifests.swift
 Copyright (c) 2020 Callum Kerr-Edwards
 Licensed under the MIT license.
 */

import XCTest

#if !canImport(ObjectiveC)
    public func allTests() -> [XCTestCaseEntry] {
        [
            testCase(PodcastTests.allTests),
            testCase(PodcastFeedKitTests.allTests),
        ]
    }
#endif
