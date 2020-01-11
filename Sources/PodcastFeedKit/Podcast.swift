import AEXML

class Podcast {
    let title: String
    let link: String
    private var block: Bool?
    private var explicit: Bool?
    private var languageCode: String?
    private var author: String?
    private var copyright: String?
    private var summary: String?

   init(title: String,
        link: String) {
       self.title = title
       self.link = link
   }

    func blockFromITunes(_ block: Bool? = true) -> Self {
        self.block = block
        return self
    }

    func containsExplicitMaterial(_ explicit: Bool? = true) -> Self {
        self.explicit = explicit
        return self
    }

    func withLanguageCode(_ code: String?) -> Self {
        self.languageCode = code
        return self
    }

    func withAuthor(_ author: String?) -> Self {
    	self.author = author
	return self
    }

    func withCopyrightInfo(_ copyright: String?) -> Self {
	self.copyright = copyright
        return self
    }

    func withSummary(_ summary: String?) -> Self {
        self.summary = summary
        return self
    }

    func getFeed() -> String {
        let podcastFeed = AEXMLDocument()
        let attributes = ["xmlns:itunes": "http://www.itunes.com/dtds/podcast-1.0.dtd", "version": "2.0"]
        let rss = podcastFeed.addChild(name: "rss", attributes: attributes)
        let channel = rss.addChild(name: "channel")
        channel.addChild(name: "title", value: title)
        channel.addChild(name: "link", value: link)
        if let explicit: Bool = explicit {
            if explicit {
                channel.addChild(name: "itunes:explicit", value: "yes")
            } else {
                channel.addChild(name: "itunes:explicit", value: "no")
            }
        }
	if let block: Bool = block {
            if block {
                channel.addChild(name: "itunes:block", value: "Yes")
            }
	}
        if let languageCode: String = languageCode {
            channel.addChild(name: "language", value: languageCode)
        }
        if let author: String = author {
            channel.addChild(name: "itunes:author", value: author)
        }
	if let copyright: String = copyright {
	    channel.addChild(name: "copyright", value: copyright)
	}
        if let summary: String = summary {
            channel.addChild(name: "itunes:summary", value: summary)
            channel.addChild(name: "description", value: summary)
        }
        return podcastFeed.xml.replacingOccurrences(of: "\t", with: "    ")
    }
}
