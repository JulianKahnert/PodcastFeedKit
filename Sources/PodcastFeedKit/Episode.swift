import Foundation

open class Episode {
    
    let title: String
    let publicationDate: String
    let fileLink: String
    let rfcDateFormat = DateFormatter()
    private var author: String?
    private var subtitle: String?
    private var imageLink: String?
    private var explicit: Bool?
    private var shortSummary: String?
    private var longSummary: String?
    
    convenience init(title: String, publicationDate: Date, fileLink: String) {
        self.init(title: title,
                  publicationDate: publicationDate,
                  timeZone: TimeZone(identifier: "UTC")!,
                  fileLink: fileLink)
    }
    
    init(title: String,
         publicationDate: Date,
         timeZone: TimeZone,
         fileLink: String) {
        self.title = title
        rfcDateFormat.timeZone = timeZone
        rfcDateFormat.dateFormat = "EEE, dd MMM yyyy HH:mm:ss Z"
        let dateString = rfcDateFormat.string(from: publicationDate)
        self.publicationDate = dateString
        self.fileLink = fileLink
    }
    
    @discardableResult
    func withAuthor(_ author: String?) -> Self {
        self.author = author
        return self
    }
    
    @discardableResult
    func withSubtitle(_ subtitle: String?) -> Self {
        self.subtitle = subtitle
        return self
    }

    /*
    The short summary must be html escape
    */
    @discardableResult
    func withShortSummary(_ shortSummary: String?) -> Self {
        self.shortSummary = shortSummary
        return self
    }
    
    /*
     The long summary can include html tags
     */
    @discardableResult
    func withLongSummary(_ longSummary: String?) -> Self {
        self.longSummary = longSummary
        return self
    }
    
    @discardableResult
    func withImage(link: String?) -> Self {
        self.imageLink = link
        return self
    }
    
    @discardableResult
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
            episodeNode.addChild(name: "description", value: shortSummary)
        }
        if let longSummary: String = longSummary {
            episodeNode.addChild(name: "content:encoded", value: longSummary)
        }
        if let imageLink: String = imageLink {
            episodeNode.addChild(name: "itunes:image", attributes: ["href": imageLink])
        }
        episodeNode.addChild(name: "pubDate", value: publicationDate)
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

