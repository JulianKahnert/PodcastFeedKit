/**
 LinuxMain.swift
 Copyright (c) 2020 Callum Kerr-Edwards
 Licensed under the MIT license.
 */

import XCTest

import PodcastFeedKitTests

var tests = [XCTestCaseEntry]()
tests += PodcastFeedKitTests.allTests()
XCTMain(tests)
