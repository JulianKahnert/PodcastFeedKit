/**
 PodcastFeedKitTests.swift
 PodcastFeedKit
 Copyright (c) 2020 Callum Kerr-Edwards
 */
import XCTest
@testable import PodcastFeedKit

final class PodcastFeedKitTests: XCTestCase {
    
    func testFullFeedGeneration() {
        
        let expectedOutput = """
        <?xml version="1.0" encoding="utf-8" standalone="no"?>
        <rss version="2.0" xmlns:content="http://purl.org/rss/1.0/modules/content/" xmlns:itunes="http://www.itunes.com/dtds/podcast-1.0.dtd">
            <channel>
                <title>Test Podcast Title</title>
                <link>https://demo.url/feed.rss</link>
                <language>en</language>
                <copyright>Copyright by Jane Appleseed</copyright>
                <itunes:subtitle>A show about things</itunes:subtitle>
                <itunes:author>Jane Appleseed &amp; Friends</itunes:author>
                <itunes:summary>A really great podcast to listen to.</itunes:summary>
                <description>A really great podcast to listen to.</description>
                <itunes:owner>
                    <itunes:name>Jane Appleseed</itunes:name>
                    <itunes:email>jane.appleseed@example.com</itunes:email>
                </itunes:owner>
                <itunes:image href="http://demo.url/artwork.jpg" />
                <itunes:category text="Technology">
                    <itunes:category text="Gadgets" />
                </itunes:category>
                <itunes:category text="TV &amp; Film" />
                <itunes:category text="Arts" />
                <itunes:explicit>yes</itunes:explicit>
                <item>
                    <title>My first episode</title>
                    <itunes:author>John Doe</itunes:author>
                    <itunes:subtitle>A short episode</itunes:subtitle>
                    <itunes:summary>A short description</itunes:summary>
                    <description>A short description</description>
                    <content:encoded><![CDATA[<h1>A short episode</h1><p>A short description</p>]]></content:encoded>
                    <itunes:image href="http://demo.url/ep1/artwork.jpg" />
                    <enclosure length="46468" type="audio/x-m4a" url="http://demo.url/ep1/file.m4a" />
                    <guid>http://demo.url/ep1/file.m4a</guid>
                    <pubDate>Sun, 11 Jun 2000 08:00:00 +0000</pubDate>
                    <itunes:duration>00:10</itunes:duration>
                    <itunes:explicit>no</itunes:explicit>
                </item>
            </channel>
        </rss>
        """
        do {
            
            let demoMP3URL: URL = try! Resource(name: "demo", type: "m4a").url
            let episodeOne = try Episode(title: "My first episode",
                                         publicationDate: getDemoDate(),
                                         audioFile: demoMP3URL,
                                         fileServerLocation: "http://demo.url/ep1/file.m4a")
                
                .withAuthor("John Doe")
                .withSubtitle("A short episode")
                .withImage(link: "http://demo.url/ep1/artwork.jpg")
                .withShortSummary("A short description")
                .withLongSummary("<h1>A short episode</h1><p>A short description</p>")
                .containsExplicitMaterial(false)
            
            XCTAssertEqual(Podcast(title: "Test Podcast Title",
                                   link: "https://demo.url/feed.rss")
                .containsExplicitMaterial()
                .withLanguageCode(Language.english.rawValue)
                .withAuthor("Jane Appleseed & Friends")
                .withOwner(name: "Jane Appleseed",
                           email: "jane.appleseed@example.com")
                .withImage(link: "http://demo.url/artwork.jpg")
                .withCopyrightInfo("Copyright by Jane Appleseed")
                .withSummary("A really great podcast to listen to.")
                .withCategory(name: "Technology",
                              subcategory: "Gadgets")
                .withCategory(name: "TV & Film")
                .withCategory(name: "Arts")
                .withSubtitle("A show about things")
                .withEpisode(episodeOne)
                .getFeed(), expectedOutput)
            
        } catch let error {
            print(error)
            XCTFail()
        }
    }
    
    static var allTests = [
        ("testFullFeedGeneration", testFullFeedGeneration)
    ]
    
}

private func getDemoDate() -> Date {
    // Specify date components
    var dateComponents = DateComponents()
    dateComponents.year = 2000
    dateComponents.month = 6
    dateComponents.day = 11
    dateComponents.hour = 8
    dateComponents.timeZone = TimeZone(identifier: "UTC")!
    
    return Calendar(identifier: Calendar.Identifier.iso8601)
        .date(from: dateComponents)!
}

struct Resource {
    let name: String
    let type: String
    let url: URL
    
    init(name: String, type: String, sourceFile: StaticString = #file) throws {
        self.name = name
        self.type = type
        
        let testCaseURL = URL(fileURLWithPath: "\(sourceFile)", isDirectory: false)
        let testsFolderURL = testCaseURL.deletingLastPathComponent()
        let resourcesFolderURL = testsFolderURL.deletingLastPathComponent().appendingPathComponent("Resources", isDirectory: true)
        self.url = resourcesFolderURL.appendingPathComponent("\(name).\(type)", isDirectory: false)
        if !FileManager.default.fileExists(atPath: url.path) {
            fatalError("\(url.path) does not exist.")
        }
    }
}
