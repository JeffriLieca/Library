//
//  Book.swift
//  Library
//
//  Created by Jeffri Lieca H on 29/12/24.
//

import Foundation

/// Represents a decoded book object retrieved from a backend or API.
///
/// Use `BookDecode` to handle data received from a backend or API when decoding
/// book-related information.
///
/// ```swift
/// let book = BookDecode(
///     id: "1",
///     title: "Swift Programming",
///     authors: ["Author A", "Author B"],
///     genres: [.fiction],
///     collections: []
/// )
/// ```
///
/// - Note: This struct conforms to `Decodable`, `Identifiable`, and `Hashable`.
 struct BookDecode: Decodable, Identifiable, Hashable {
    /// The unique identifier of the book.
    let id: String
    
    /// The title of the book.
    let title: String
    
    /// An array of authors who wrote the book.
    let authors: [String]
    
    /// An array of genres that classify the book.
    let genres: [Genre]
    
    /// A collection of related information about the book.
    var collections: [CollectionBookDecode]
    
    /// Coding keys for decoding JSON data into the `BookDecode` struct.
    ///
    /// Maps JSON keys to Swift properties. For example, `book_id` is mapped to `id`.
    enum CodingKeys: String, CodingKey {
        case id = "book_id"
        case title = "book_name"
        case authors
        case genres = "genre"
        case collections = "collection" // Must match the table name.
    }
}

/// Represents an encoded book object for sending data to a backend or API.
///
/// Use `BookEncode` when creating or updating book-related information
/// that needs to be sent to a backend or API.
///
/// ```swift
/// let book = BookEncode(
///     id: "1",
///     title: "Swift Programming",
///     authors: ["Author A", "Author B"]
/// )
/// ```
///
/// - Note: This struct conforms to `Encodable`, `Identifiable`, and `Hashable`.
struct BookEncode: Encodable, Identifiable, Hashable {
    /// The unique identifier of the book, optional for newly created books.
    let id: String?
    
    /// The title of the book.
    let title: String
    
    /// An array of authors who wrote the book.
    let authors: [String]
    
    /// Coding keys for encoding Swift properties into JSON data.
    ///
    /// Maps Swift properties to JSON keys. For example, `id` is mapped to `book_id`.
    enum CodingKeys: String, CodingKey {
        case id = "book_id"
        case title = "book_name"
        case authors
    }
}
