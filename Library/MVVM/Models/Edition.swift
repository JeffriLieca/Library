//
//  Edition.swift
//  Library
//
//  Created by Jeffri Lieca H on 29/12/24.
//

import Foundation

/// Represents an edition of a book.
///
/// Use `Edition` to define details about a specific edition of a book in the library collection.
///
/// ```swift
/// let edition = Edition(
///     id: "1",
///     name: "First Edition",
///     description: "This is the first edition of the book."
/// )
/// ```
///
/// - Note: This struct conforms to `Codable`, `Identifiable`, and `Hashable`.
struct Edition: Codable, Identifiable, Hashable {
    /// The unique identifier of the edition.
    let id: String?
    
    /// The name of the edition.
    let name: String
    
    /// A description of the edition, if available.
    let description: String?
    
    /// Coding keys for mapping properties to JSON keys.
    enum CodingKeys: String, CodingKey {
        case id = "edition_id"
        case name = "edition_name"
        case description = "edition_desc"
    }
}
