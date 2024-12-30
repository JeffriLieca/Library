//
//  Borrower.swift
//  Library
//
//  Created by Jeffri Lieca H on 30/12/24.
//

import Foundation

/// Represents a borrower or user who performs a borrow transaction.
///
/// Use `Borrower` to manage data related to the individuals borrowing items from the library.
///
/// ```swift
/// let borrower = Borrower(id: "123", name: "John Doe")
/// ```
///
/// - Note: This struct conforms to `Codable` and `Hashable`.
struct Borrower: Codable, Hashable {
    /// The unique identifier of the borrower. This value can be `nil` for new borrowers.
    let id: String?
    
    /// The name of the borrower.
    let name: String
    
    /// Coding keys for encoding and decoding JSON data.
    enum CodingKeys: String, CodingKey {
        /// Maps the `id` property to the JSON key `borrower_id`.
        case id = "borrower_id"
        /// Maps the `name` property to the JSON key `borrower_name`.
        case name = "borrower_name"
    }
}
