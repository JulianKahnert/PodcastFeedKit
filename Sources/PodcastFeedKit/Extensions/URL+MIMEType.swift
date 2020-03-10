/**
 URL+MIMEType.swift
 Copyright (c) 2020 Callum Kerr-Edwards
 Licensed under the MIT license.
 */

import CoreServices
import Foundation

extension URL {
    var attributes: [FileAttributeKey: Any]? {
        do {
            return try FileManager.default.attributesOfItem(atPath: path)
        } catch let error as NSError {
            print("FileAttribute error: \(error)")
        }
        return nil
    }

    var fileSize: String {
        String(Int64(attributes?[.size] as? UInt64 ?? UInt64(0)))
    }

    func mimeType() -> String {
        let pathExtension = self.pathExtension
        if let uti = UTTypeCreatePreferredIdentifierForTag(kUTTagClassFilenameExtension, pathExtension as NSString, nil)?.takeRetainedValue() {
            if let mimetype = UTTypeCopyPreferredTagWithClass(uti, kUTTagClassMIMEType)?.takeRetainedValue() {
                let mime = mimetype as String
                if mime == "audio/x-m4a" {
                    return "audio/mp4a-latm"
                } else {
                    return mime
                }
            }
            if (uti as String).starts(with: "com.apple.protected-mpeg-4-audio") {
                return "audio/mp4a-latm"
            }
        }
        return "application/octet-stream"
    }

    var containsAudio: Bool {
        let mimeType = self.mimeType()
        guard let uti = UTTypeCreatePreferredIdentifierForTag(kUTTagClassMIMEType, mimeType as CFString, nil)?.takeRetainedValue() else {
            return false
        }
        return UTTypeConformsTo(uti, kUTTypeAudio)
    }
}
