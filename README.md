# PodcastFeedKit
A Swift library for building a podcast feed from metadata and some media.

## Usage

```swift  
import PodcastFeedKit

let podcast = Podcast(title: "Test Podcast Title",
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
              .withEpisode(Episode(title: "My first episode")
                          .withAuthor("John Doe")
                          .withSubtitle("A short episode")
                          .withImage(link: "http://demo.url/ep1/artwork.jpg")
                          .containsExplicitMaterial(false))
print(podcast.getFeed())
```
would produce the string
```xml
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
            <itunes:image href="http://demo.url/ep1/artwork.jpg" />
            <itunes:explicit>no</itunes:explicit>
        </item>
    </channel>
</rss>
```

## Installation

- [Swift Package Manager](https://swift.org/package-manager/):

	```swift
    .package(url: "https://github.com/CallumKerrEdwards/PodcastFeedKit.git", from: "0.0.9")
	```
