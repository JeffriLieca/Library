//
//  Collection_Book.swift
//  Library
//
//  Created by Jeffri Lieca H on 29/12/24.
//

import Foundation

/// Represents the decoded data of a book collection.
///
/// Use `CollectionBookDecode` to manage data related to book collections retrieved from the database.
/// This model supports decoding full edition objects.
///
/// ```swift
/// let collectionBook = CollectionBookDecode(
///     id: "123",
///     name: "The Great Book",
///     imageName: "great_book.png",
///     qty: 10,
///     edition: Edition(id: "1", name: "First Edition"),
///     isbn: "978-1234567890",
///     publisher: "Famous Publisher",
///     publishYear: 2020
/// )
/// ```
///
/// - Note: This struct conforms to `Decodable`, `Identifiable`, and `Hashable`.
struct CollectionBookDecode: Decodable, Identifiable, Hashable {
    /// The unique identifier of the book collection.
    let id: String
    
    /// The name of the book.
    let name: String
    
    /// The name of the image representing the book, if available.
    let imageName: String?
    
    /// The quantity of this book in the collection.
    let qty: Int
    
    /// The edition of the book.
    let edition: Edition
    
    /// The ISBN of the book.
    let isbn: String
    
    /// The publisher of the book.
    let publisher: String
    
    /// The year the book was published.
    let publishYear: Int
    
    /// Coding keys for mapping properties to JSON keys.
    enum CodingKeys: String, CodingKey {
        case id = "collection_id"
        case name = "collection_name"
        case imageName = "collection_image"
        case qty = "collection_qty"
        case edition = "edition" // Decode as full object
        case isbn
        case publisher
        case publishYear = "publish_year"
    }
}

/// Represents the encoded data of a book collection.
///
/// Use `CollectionBookEncode` to send data about a book collection to the server.
///
/// ```swift
/// let collectionBook = CollectionBookEncode(
///     bookId: "123",
///     editionId: "1",
///     name: "The Great Book",
///     imageName: "great_book.png",
///     qty: 10,
///     isbn: "978-1234567890",
///     publisher: "Famous Publisher",
///     publishYear: 2020
/// )
/// ```
///
/// - Note: This struct conforms to `Encodable` and `Hashable`.
struct CollectionBookEncode: Encodable, Hashable {
    /// The unique identifier of the book being encoded.
    let bookId: String
    
    /// The unique identifier of the edition being encoded.
    let editionId: String
    
    /// The name of the book.
    let name: String
    
    /// The name of the image representing the book, if available.
    let imageName: String?
    
    /// The quantity of this book in the collection.
    let qty: Int
    
    /// The ISBN of the book.
    let isbn: String
    
    /// The publisher of the book.
    let publisher: String
    
    /// The year the book was published.
    let publishYear: Int
    
    /// Coding keys for mapping properties to JSON keys.
    enum CodingKeys: String, CodingKey {
        case bookId = "bookbook_id"
        case editionId = "editionedition_id"
        case name = "collection_name"
        case imageName = "collection_image"
        case qty = "collection_qty"
        case isbn
        case publisher
        case publishYear = "publish_year"
    }
}
