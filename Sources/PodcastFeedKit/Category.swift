/**
 Category.swift
 PodcastFeedKit
 Copyright (c) 2020 Callum Kerr-Edwards
 */

import Foundation

public struct Category {
    let name: String
    let subcategory: String?
    
    init(name: String, subcategory: String? = nil) {
        self.name = name
        self.subcategory = subcategory
    }
}
