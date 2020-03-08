/**
 XMLElement.swift
 Copyright (c) 2020 Callum Kerr-Edwards
 Licensed under the MIT license.
 */

import Foundation

class XMLElement {
    var parent: XMLElement?
    var children = [XMLElement]()
    var name: String
    var value: String?
    var attributes: [String: String]

    public init(name: String, value: String? = nil, attributes: [String: String] = [:]) {
        self.name = name
        self.value = value
        self.attributes = attributes
    }

    @discardableResult
    func addChild(_ child: XMLElement) -> XMLElement {
        child.parent = self
        children.append(child)
        return child
    }

    @discardableResult
    func addChild(name: String,
                  value: String? = nil,
                  attributes: [String: String] = [:]) -> XMLElement {
        let child = XMLElement(name: name, value: value, attributes: attributes)
        return addChild(child)
    }

    func getChild(name: String,
                  value: String? = nil,
                  attributes: [String: String] = [:]) -> XMLElement? {
        getChildren(name: name, value: value, attributes: attributes).first
    }

    func getChildren(name: String,
                     value: String? = nil,
                     attributes: [String: String] = [:]) -> [XMLElement] {
        children.filter { $0.name == name && $0.value == value && $0.attributes == attributes }
    }

    func hasChild(name: String,
                  value: String? = nil,
                  attributes: [String: String] = [:]) -> Bool {
        !getChildren(name: name, value: value, attributes: attributes).isEmpty
    }

    var xml: String {
        var xml = String()

        xml += indent(withDepth: parentsCount)
        xml += "<\(name)"

        if attributes.count > 0 {
            // insert attributes
            for (key, value) in attributes.sorted(by: { $0.key < $1.key }) {
                xml += " \(key)=\"\(value.xmlEscaped)\""
            }
        }

        if value == nil, children.count == 0 {
            // close element
            xml += "/>"
        } else {
            if children.count > 0 {
                xml += ">\n"
                for child in children {
                    xml += "\(child.xml)\n"
                }
                xml += indent(withDepth: parentsCount)
                xml += "</\(name)>"
            } else {
                if let value: String = value {
                    if name == "content:encoded" {
                        xml += "><![CDATA[\(value)]]></\(name)>"
                    } else {
                        xml += ">\(value.xmlEscaped)</\(name)>"
                    }
                }
            }
        }
        return xml
    }

    // MARK: - Helpers

    private var parentsCount: Int {
        var count = 0
        var element = self

        while let parent = element.parent {
            count += 1
            element = parent
        }

        return count
    }

    private func indent(withDepth depth: Int) -> String {
        var count = depth
        var indent = String()

        while count > 0 {
            indent += "    "
            count -= 1
        }

        return indent
    }
}

public extension String {
    var xmlEscaped: String {
        var escaped = replacingOccurrences(of: "&", with: "&amp;", options: .literal)
        let escapeChars = ["<": "&lt;", ">": "&gt;", "'": "&apos;", "\"": "&quot;"]
        for (char, echar) in escapeChars {
            escaped = escaped.replacingOccurrences(of: char, with: echar, options: .literal)
        }

        return escaped
    }
}
