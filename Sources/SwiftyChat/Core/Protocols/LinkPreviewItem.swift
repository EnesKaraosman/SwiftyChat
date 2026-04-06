//
//  LinkPreviewItem.swift
//
//  Created on 2026-04-06.
//

import Foundation

/// A protocol used to represent the data for a link preview message.
public protocol LinkPreviewItem {

    /// The original URL being previewed.
    var url: URL { get }

    /// The Open Graph title of the page.
    var title: String? { get }

    /// The Open Graph description of the page.
    var description: String? { get }

    /// The Open Graph image URL for the page.
    var imageURL: URL? { get }

    /// The display hostname (e.g. "github.com").
    var host: String? { get }
}
