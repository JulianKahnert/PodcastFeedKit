import XCTest
@testable import PodcastFeedKit

final class PodcastFeedKitTests: XCTestCase {
    func testFeedGeneratesWithMinimalAttributes() {

        let expectedOutput = """
        <?xml version="1.0" encoding="utf-8" standalone="no"?>
        <rss version="2.0" xmlns:itunes="http://www.itunes.com/dtds/podcast-1.0.dtd">
            <channel>
                <title>Test Podcast Title</title>
                <link>https://demo.url/feed.rss</link>
            </channel>
        </rss>
        """
        XCTAssertEqual(Podcast(title: "Test Podcast Title", link: "https://demo.url/feed.rss").getFeed(), expectedOutput)
    }

    func testFeedGeneratesWithCleanAttribute() {

        let expectedOutput = """
        <?xml version="1.0" encoding="utf-8" standalone="no"?>
        <rss version="2.0" xmlns:itunes="http://www.itunes.com/dtds/podcast-1.0.dtd">
            <channel>
                <title>Test Podcast Title</title>
                <link>https://demo.url/feed.rss</link>
                <itunes:explicit>no</itunes:explicit>
            </channel>
        </rss>
        """
        XCTAssertEqual(Podcast(title: "Test Podcast Title",
                               link: "https://demo.url/feed.rss")
                               .containsExplicitMaterial(false)
                               .getFeed(), expectedOutput)
    }

    func testFeedGeneratesWithExplicitAttribute() {

        let expectedOutput = """
        <?xml version="1.0" encoding="utf-8" standalone="no"?>
        <rss version="2.0" xmlns:itunes="http://www.itunes.com/dtds/podcast-1.0.dtd">
            <channel>
                <title>Test Podcast Title</title>
                <link>https://demo.url/feed.rss</link>
                <itunes:explicit>yes</itunes:explicit>
            </channel>
        </rss>
        """
        XCTAssertEqual(Podcast(title: "Test Podcast Title",
                               link: "https://demo.url/feed.rss")
                               .containsExplicitMaterial()
                               .getFeed(), expectedOutput)
    }

   func testFeedGeneratesWithBlockAttribute() {

       let expectedOutput = """
       <?xml version="1.0" encoding="utf-8" standalone="no"?>
       <rss version="2.0" xmlns:itunes="http://www.itunes.com/dtds/podcast-1.0.dtd">
           <channel>
               <title>Test Podcast Title</title>
               <link>https://demo.url/feed.rss</link>
               <itunes:block>Yes</itunes:block>
           </channel>
       </rss>
       """
       XCTAssertEqual(Podcast(title: "Test Podcast Title",
                              link: "https://demo.url/feed.rss")
                              .blockFromITunes()
                              .getFeed(), expectedOutput)
   }

   func testFeedGeneratesWithLanguageCode() {

       let expectedOutput = """
       <?xml version="1.0" encoding="utf-8" standalone="no"?>
       <rss version="2.0" xmlns:itunes="http://www.itunes.com/dtds/podcast-1.0.dtd">
           <channel>
               <title>Test Podcast Title</title>
               <link>https://demo.url/feed.rss</link>
               <language>en-gb</language>
           </channel>
       </rss>
       """
       XCTAssertEqual(Podcast(title: "Test Podcast Title",
                              link: "https://demo.url/feed.rss")
                              .withLanguageCode(Language.english_uk.rawValue)
                              .getFeed(), expectedOutput)
   }

    static var allTests = [
        ("testFeedGeneratesWithMinimalAttributes", testFeedGeneratesWithMinimalAttributes),
        ("testFeedGeneratesWithCleanAttribute", testFeedGeneratesWithCleanAttribute),
        ("testFeedGeneratesWithExplicitAttribute", testFeedGeneratesWithExplicitAttribute),
        ("testFeedGeneratesWithBlockAttribute", testFeedGeneratesWithBlockAttribute),
        ("testFeedGeneratesWithLanguageCode", testFeedGeneratesWithLanguageCode)
    ]
}
