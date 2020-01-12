/**
 *  https://github.com/tadija/AEXML
 *  Copyright (c) Marko Tadić 2014-2019
 *  Licensed under the MIT license. See LICENSE file.
 */

import Foundation

/**
 This is base class for holding XML structure.
 */
internal class AEXMLElement {
    
    // MARK: - Properties
    
    /// Every `AEXMLElement` should have its parent element instead of `AEXMLDocument` which parent is `nil`.
    internal weak var parent: AEXMLElement?
    
    /// Child XML elements.
    internal var children = [AEXMLElement]()
    
    /// XML Element name.
    internal var name: String
    
    /// XML Element value.
    internal var value: String?
    
    /// XML Element attributes.
    internal var attributes: [String: String]
    
    // MARK: - Init
    
    /**
     Designated initializer - all parameters are optional.
     
     - parameter name: XML element name.
     - parameter value: XML element value (defaults to `nil`).
     - parameter attributes: XML element attributes (defaults to empty dictionary).
     
     - returns: An initialized `AEXMLElement` object.
     */
    public init(name: String, value: String? = nil, attributes: [String: String] = [:]) {
        self.name = name
        self.value = value
        self.attributes = attributes
    }
    
    // MARK: - XML Write
    
    /**
     Adds child XML element to `self`.
     
     - parameter child: Child XML element to add.
     
     - returns: Child XML element with `self` as `parent`.
     */
    @discardableResult
    internal func addChild(_ child: AEXMLElement) -> AEXMLElement {
        child.parent = self
        children.append(child)
        return child
    }
    
    /**
     Adds child XML element to `self`.
     
     - parameter name: Child XML element name.
     - parameter value: Child XML element value (defaults to `nil`).
     - parameter attributes: Child XML element attributes (defaults to empty dictionary).
     
     - returns: Child XML element with `self` as `parent`.
     */
    @discardableResult
    internal func addChild(name: String,
                           value: String? = nil,
                           attributes: [String: String] = [:]) -> AEXMLElement {
        let child = AEXMLElement(name: name, value: value, attributes: attributes)
        return addChild(child)
    }
    
    /**
     Adds an array of XML elements to `self`.
     
     - parameter children: Child XML element array to add.
     
     - returns: Child XML elements with `self` as `parent`.
     */
    @discardableResult
    internal func addChildren(_ children: [AEXMLElement]) -> [AEXMLElement] {
        children.forEach { addChild($0) }
        return children
    }
    
    /// Removes `self` from `parent` XML element.
    internal func removeFromParent() {
        if let index = parent?.children.firstIndex(where: { $0 === self }) {
            parent?.children.remove(at: index)
        }
    }
    
    /// Complete hierarchy of `self` and `children` in **XML** escaped and formatted String
    internal var xml: String {
        var xml = String()
        
        // internal element
        xml += indent(withDepth: parentsCount)
        xml += "<\(name)"
        
        if attributes.count > 0 {
            // insert attributes
            for (key, value) in attributes.sorted(by: { $0.key < $1.key }) {
                xml += " \(key)=\"\(value.xmlEscaped)\""
            }
        }
        
        if value == nil && children.count == 0 {
            // close element
            xml += " />"
        } else {
            if children.count > 0 {
                // add children
                xml += ">\n"
                for child in children {
                    xml += "\(child.xml)\n"
                }
                // add indentation
                xml += indent(withDepth: parentsCount)
                xml += "</\(name)>"
            } else {
                // insert string value and close element
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
    
    /// String representation of self with XML special characters escaped.
    var xmlEscaped: String {
        // we need to make sure "&" is escaped first. Not doing this may break escaping the other characters
        var escaped = replacingOccurrences(of: "&", with: "&amp;", options: .literal)
        
        // replace the other four special characters
        let escapeChars = ["<": "&lt;", ">": "&gt;", "'": "&apos;", "\"": "&quot;"]
        for (char, echar) in escapeChars {
            escaped = escaped.replacingOccurrences(of: char, with: echar, options: .literal)
        }
        
        return escaped
    }
    
}
