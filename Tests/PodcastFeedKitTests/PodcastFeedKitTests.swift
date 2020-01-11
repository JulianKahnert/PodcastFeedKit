import XCTest
@testable import PodcastFeedKit

final class PodcastFeedKitTests: XCTestCase {

    func testFullFeedGeneration() {

        let expectedOutput = """
        <?xml version="1.0" encoding="utf-8" standalone="no"?>
        <rss version="2.0" xmlns:itunes="http://www.itunes.com/dtds/podcast-1.0.dtd">
            <channel>
                <title>Test Podcast Title</title>
                <link>https://demo.url/feed.rss</link>
                <itunes:explicit>yes</itunes:explicit>
                <language>en</language>
                <itunes:author>Jane Appleseed &amp; Friends</itunes:author>
                <copyright>Copyright by Jane Appleseed</copyright>
                <itunes:summary>A really great podcast to listen to.</itunes:summary>
                <description>A really great podcast to listen to.</description>
            </channel>
        </rss>
        """
        XCTAssertEqual(Podcast(title: "Test Podcast Title",
                               link: "https://demo.url/feed.rss")
                                .containsExplicitMaterial()
                                .withLanguageCode(Language.english.rawValue)
                                .withAuthor("Jane Appleseed & Friends")
                                .withCopyrightInfo("Copyright by Jane Appleseed")
                                .withSummary("A really great podcast to listen to.")
                                .getFeed(), expectedOutput)
    }

    static var allTests = [
        ("testFullFeedGeneration", testFullFeedGeneration)
    ]

}
