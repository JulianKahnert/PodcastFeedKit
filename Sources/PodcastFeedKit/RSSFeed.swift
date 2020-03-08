/**
 RSSFeed.swift
 Copyright (c) 2020 Callum Kerr-Edwards
 Licensed under the MIT license.
 */

import Foundation

class RSSFeed: XMLElement {
    init(attributes: [String: String] = [:]) {
        super.init(name: "rss", value: nil, attributes: attributes)
        parent = nil
    }

    override var xml: String {
        var xml = "<?xml version=\"1.0\" encoding=\"utf-8\" standalone=\"no\"?>\n"
        xml += super.xml
        return xml
    }
}
