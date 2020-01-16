/**
 *  https://github.com/tadija/AEXML
 *  Copyright (c) Marko Tadić 2014-2019
 *  Licensed under the MIT license. See LICENSE file.
 */

import Foundation

/**
 This class is inherited from `AEXMLElement` and has a few addons to represent **XML Document**.

 XML Parsing is also done with this object.
 */
internal class AEXMLDocument: AEXMLElement {
    // MARK: - Lifecycle

    public init(name: String, attributes: [String: String] = [:]) {
        super.init(name: name, value: nil, attributes: attributes)
        parent = nil
    }

    // MARK: - Override

    /// Override of `xml` property of `AEXMLElement` - it just inserts XML Document header at the beginning.
    internal override var xml: String {
        var xml = "<?xml version=\"1.0\" encoding=\"utf-8\" standalone=\"no\"?>\n"
        xml += super.xml
        return xml
    }
}
