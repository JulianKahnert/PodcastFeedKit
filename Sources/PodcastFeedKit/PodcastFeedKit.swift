import AEXML

struct Podcast {
    let title: String
    let link: String
    let blockFromITunes: Bool?
    var explicit: Bool?
    
    
    init(title: String, 
        link: String, 
        explicit: Bool? = nil,
        blockFromITunes: Bool? = nil) {
        self.title = title
        self.link = link
        self.explicit = explicit
        self.blockFromITunes = blockFromITunes
    }
    
    func getFeed() -> String{
        let podcastFeed = AEXMLDocument()
        let attributes = ["xmlns:itunes" : "http://www.itunes.com/dtds/podcast-1.0.dtd", "version" : "2.0"]
        let rss = podcastFeed.addChild(name: "rss", attributes : attributes)
        let channel = rss.addChild(name: "channel")
        channel.addChild(name: "title", value : title)
        channel.addChild(name: "link", value : link)
        if let explicit: Bool = explicit {
            if explicit {
                channel.addChild(name: "itunes:explicit", value : "yes")
            } else {
                channel.addChild(name: "itunes:explicit", value : "no")
            }
        }
        if let blockFromITunes: Bool = blockFromITunes {
            if blockFromITunes {
                channel.addChild(name: "itunes:block", value : "Yes")
            }
        }
        return podcastFeed.xml.replacingOccurrences(of: "\t", with: "    ")
    }
}