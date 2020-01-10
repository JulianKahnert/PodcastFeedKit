import AEXML

class Podcast {
    let title: String
    let link: String
    private var block = false
    private var explicit: Bool?
    private var languageCode: String?
    
    
   init(title: String, 
       link: String) {
       self.title = title
       self.link = link
   }

    func blockFromITunes()  -> Self {
        self.block = true
        return self
    }
    
    func containsExplicitMaterial(_ explicit: Bool? = true)  -> Self {
        self.explicit = explicit
        return self
    }
    
    func withLanguageCode(_ code: String?) -> Self {
        self.languageCode = code
        return self
    }
    
    func getFeed() -> String {
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
        if block {
            channel.addChild(name: "itunes:block", value : "Yes")
        }
        if let languageCode: String = languageCode {
            channel.addChild(name: "language", value: languageCode)
        }
        return podcastFeed.xml.replacingOccurrences(of: "\t", with: "    ")
    }
}