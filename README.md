# PodcastFeedKit
A Swift library for building a podcast feed from metadata and some media.

## Usage

```swift  
import PodcastFeedKit

let podcast = Podcast(title : "My New Podcast", link : "https://my-new-podcast.dummy/feed.rss")
print(podcast.getFeed())
```
would produce the string
```
<?xml version="1.0" encoding="utf-8" standalone="no"?>
<rss version="2.0" xmlns:itunes="http://www.itunes.com/dtds/podcast-1.0.dtd">
    <channel>
        <title>My New Podcast</title>
        <link>https://my-new-podcast.dummy/feed.rss</link>
    </channel>
</rss>
```

## Installation

- [Swift Package Manager](https://swift.org/package-manager/):

	```swift
    .package(url: "https://github.com/CallumKerrEdwards/PodcastFeedKit.git", from: "0.0.1")
	```
