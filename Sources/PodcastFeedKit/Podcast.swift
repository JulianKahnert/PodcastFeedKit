/**
 Podcast.swift
 PodcastFeedKit
 Copyright (c) 2020 Callum Kerr-Edwards
 */

open class Podcast {
    
    // MARK: - Properties
    let title: String
    let link: String
    private var block: Bool?
    private var explicit: Bool?
    private var languageCode: String?
    private var author: String?
    private var copyright: String?
    private var summary: String?
    private var subtitle: String?
    private var owner: (String, String)?
    private var imageLink: String?
    private var categories: [(name: String, subcategory: String?)] = []
    private var episodes: [Episode] = []
    
    // MARK: - init
    
    init(title: String, link: String) {
        self.title = title
        self.link = link
    }
    
    // MARK: - builder functions
    
    @discardableResult
    func blockFromITunes(_ block: Bool? = true) -> Self {
        self.block = block
        return self
    }
    
    @discardableResult
    func containsExplicitMaterial(_ explicit: Bool? = true) -> Self {
        self.explicit = explicit
        return self
    }
    
    @discardableResult
    func withLanguageCode(_ code: String?) -> Self {
        self.languageCode = code
        return self
    }
    
    @discardableResult
    func withLanguage(_ language: Language?) -> Self {
        self.withLanguageCode(language?.rawValue)
        return self
    }
    
    @discardableResult
    func withAuthor(_ author: String?) -> Self {
        self.author = author
        return self
    }
    
    @discardableResult
    func withCopyrightInfo(_ copyright: String?) -> Self {
        self.copyright = copyright
        return self
    }
    
    @discardableResult
    func withSummary(_ summary: String?) -> Self {
        self.summary = summary
        return self
    }
    
    @discardableResult
    func withSubtitle(_ subtitle: String?) -> Self {
        self.subtitle = subtitle
        return self
    }
    
    @discardableResult
    func withOwner(name: String, email: String) -> Self {
        self.owner = (name, email)
        return self
    }
    
    @discardableResult
    func withImage(link: String?) -> Self {
        self.imageLink = link
        return self
    }
    
    @discardableResult
    func withCategory(name: String, subcategory: String? = nil) -> Self {
        self.categories.append((name: name, subcategory: subcategory))
        return self
    }
    
    @discardableResult
    func withCategory(_ category: Category) -> Self {
        return self.withCategory(name: category.parent, subcategory: category.subcategory)
    }
    
    @discardableResult
    func withEpisode(_ episode: Episode) -> Self {
        self.episodes.append(episode)
        return self
    }
    
    @discardableResult
    func withEpisodes(_ episodes: Episode...) -> Self {
        for episode in episodes {
            self.withEpisode(episode)
        }
        return self
    }
    
    // MARK: - Building RSS Feed
    func getFeed() -> String {
        let attributes = ["xmlns:itunes": "http://www.itunes.com/dtds/podcast-1.0.dtd",
                          "xmlns:content": "http://purl.org/rss/1.0/modules/content/",
                          "version": "2.0"]
        let podcastFeed = AEXMLDocument(name: "rss", attributes: attributes)
        let channel = podcastFeed.addChild(name: "channel")
        channel.addChild(name: "title", value: title)
        channel.addChild(name: "link", value: link)
        if let languageCode: String = languageCode {
            channel.addChild(name: "language", value: languageCode)
        }
        if let copyright: String = copyright {
            channel.addChild(name: "copyright", value: copyright)
        }
        if let subtitle: String = subtitle {
            channel.addChild(name: "itunes:subtitle", value: subtitle)
        }
        if let author: String = author {
            channel.addChild(name: "itunes:author", value: author)
        }
        if let summary: String = summary {
            channel.addChild(name: "itunes:summary", value: summary)
            channel.addChild(name: "description", value: summary)
        }
        if let owner: (name: String, email: String) = owner {
            let ownerNode = channel.addChild(name: "itunes:owner")
            ownerNode.addChild(name: "itunes:name", value: owner.name)
            ownerNode.addChild(name: "itunes:email", value: owner.email)
        }
        if let imageLink: String = imageLink {
            channel.addChild(name: "itunes:image", attributes: ["href": imageLink])
        }
        for category in categories {
            if channel.hasChild(name: "itunes:category", attributes: ["text": category.name]) {
                if let subcategory: String = category.subcategory {
                    channel.getChild(name: "itunes:category", attributes: ["text": category.name])!
                        .addChild(name: "itunes:category",
                                  attributes: ["text": subcategory])
                }
            } else {
                let categoryNode = channel.addChild(name: "itunes:category",
                                                    attributes: ["text": category.name])
                if let subcategory: String = category.subcategory {
                    categoryNode.addChild(name: "itunes:category",
                                          attributes: ["text": subcategory])
                }
            }
        }
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
        for episode in episodes.sorted(by: { $0.publicationDate > $1.publicationDate }) {
            channel.addChild(episode.getNode())
        }
        return podcastFeed.xml
    }
}
