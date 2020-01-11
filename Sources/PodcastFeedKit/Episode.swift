import AEXML

open class Episode {
    
    let title: String
    private var author: String?
    private var subtitle: String?
    private var imageLink: String?
    private var explicit: Bool?
    private var shortSummary: String?
    
    
    init(title: String) {
        self.title = title
    }
    
    func withAuthor(_ author: String?) -> Self {
        self.author = author
        return self
    }
    
    func withSubtitle(_ subtitle: String?) -> Self {
        self.subtitle = subtitle
        return self
    }
    
    func withShortSummary(_ shortSummary: String?) -> Self {
        self.shortSummary = shortSummary
        return self
    }
    
    func withImage(link: String?) -> Self {
        self.imageLink = link
        return self
    }
    
    func containsExplicitMaterial(_ explicit: Bool? = true) -> Self {
        self.explicit = explicit
        return self
    }
    
    internal func getNode() -> AEXMLElement {
        let episodeNode = AEXMLElement(name: "item")
        episodeNode.addChild(name: "title", value: title)
        if let author: String = author {
            episodeNode.addChild(name: "itunes:author", value: author)
        }
        if let subtitle: String = subtitle {
            episodeNode.addChild(name: "itunes:subtitle", value: subtitle)
        }
        if let shortSummary: String = shortSummary {
            episodeNode.addChild(name: "itunes:summary", value: shortSummary)
        }
        if let imageLink: String = imageLink {
            episodeNode.addChild(name: "itunes:image", attributes: ["href": imageLink])
        }
        if let explicit: Bool = explicit {
            if explicit {
                episodeNode.addChild(name: "itunes:explicit", value: "yes")
            } else {
                episodeNode.addChild(name: "itunes:explicit", value: "no")
            }
        }
        return episodeNode
    }
    
}

