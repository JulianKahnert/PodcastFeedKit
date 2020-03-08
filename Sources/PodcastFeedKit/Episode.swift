/**
 Episode.swift
 Copyright (c) 2020 Callum Kerr-Edwards
 Licensed under the MIT license.
 */

import AVFoundation
import Foundation

open class Episode {
    // MARK: - Properties

    let title: String
    let publicationDate: Date
    let timeZone: TimeZone
    let fileServerLocation: String
    let rfcDateFormat = DateFormatter()
    let fileSizeInBytes: String
    let fileMIMEType: String
    let fileDuration: String
    private var author: String?
    private var subtitle: String?
    private var imageLink: String?
    private var explicit: Bool?
    private var shortSummary: String?
    private var longSummary: String?
    private var guid: String?

    // MARK: - Init

    public init(title: String,
                publicationDate: Date,
                timeZone: TimeZone,
                audioFile: URL,
                fileServerLocation: String) throws {
        self.title = title
        self.publicationDate = publicationDate
        self.timeZone = timeZone
        self.fileServerLocation = fileServerLocation
        if !audioFile.containsAudio {
            throw EpisodeError.fileIsNotAudio(filepath: audioFile.path)
        }
        fileSizeInBytes = audioFile.fileSize
        fileMIMEType = audioFile.mimeType()
        fileDuration = formatMinuteSeconds(Int(CMTimeGetSeconds(AVURLAsset(url: audioFile).duration)))
    }

    public convenience init(title: String,
                            publicationDate: Date,
                            audioFile: URL,
                            fileServerLocation: String) throws {
        do {
            try self.init(title: title,
                          publicationDate: publicationDate,
                          timeZone: TimeZone(identifier: "UTC")!,
                          audioFile: audioFile,
                          fileServerLocation: fileServerLocation)
        } catch {
            throw error
        }
    }

    // MARK: - Builder functions

    @discardableResult
    open func withAuthor(_ author: String?) -> Self {
        self.author = author
        return self
    }

    @discardableResult
    open func withSubtitle(_ subtitle: String?) -> Self {
        self.subtitle = subtitle
        return self
    }

    /*
     The short summary must be html escape
     */
    @discardableResult
    open func withShortSummary(_ shortSummary: String?) -> Self {
        self.shortSummary = shortSummary
        return self
    }

    /*
     The long summary can include html tags
     */
    @discardableResult
    open func withLongSummary(_ longSummary: String?) -> Self {
        self.longSummary = longSummary
        return self
    }

    @discardableResult
    open func withImage(link: String?) -> Self {
        imageLink = link
        return self
    }

    @discardableResult
    open func containsExplicitMaterial(_ explicit: Bool? = true) -> Self {
        self.explicit = explicit
        return self
    }

    @discardableResult
    open func withGUID(_ guid: String?) -> Self {
        self.guid = guid
        return self
    }

    // MARK: - Build XML

    internal func getNode() -> XMLElement {
        let episodeNode = XMLElement(name: "item")
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
        episodeNode.addChild(name: "enclosure", attributes: ["length": fileSizeInBytes,
                                                             "type": fileMIMEType,
                                                             "url": fileServerLocation])
        if let guid: String = guid {
            episodeNode.addChild(name: "guid", value: guid, attributes: ["isPermaLink": "false"])
        } else {
            episodeNode.addChild(name: "guid", value: fileServerLocation)
        }

        rfcDateFormat.timeZone = timeZone
        rfcDateFormat.dateFormat = "EEE, dd MMM yyyy HH:mm:ss Z"
        let dateString = rfcDateFormat.string(from: publicationDate)
        episodeNode.addChild(name: "pubDate", value: dateString)

        episodeNode.addChild(name: "itunes:duration", value: fileDuration)
        if let explicit: Bool = explicit {
            if explicit {
                episodeNode.addChild(name: "itunes:explicit", value: "yes")
            } else {
                episodeNode.addChild(name: "itunes:explicit", value: "no")
            }
        }
        return episodeNode
    }

    open func getXml() -> String {
        getNode().xml
    }
}

// MARK: - Helper

internal func formatMinuteSeconds(_ totalSeconds: Int) -> String {
    let hours: Int = totalSeconds / 3600
    let minutes: Int = totalSeconds / 60
    let seconds: Int = totalSeconds % 60

    if hours > 0 {
        return String(format: "%02d:%02d:%02d", hours, minutes % 60, seconds)
    } else {
        return String(format: "%02d:%02d", minutes, seconds)
    }
}

enum EpisodeError: Error {
    case fileIsNotAudio(filepath: String)
}
