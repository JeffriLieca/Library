//
//  BorrowCollection.swift
//  Library
//
//  Created by Jeffri Lieca H on 30/12/24.
//

import Foundation

/// Represents a detailed borrow transaction including the borrower and the borrowed collections.
///
/// Use `BorrowCollection` to handle detailed borrow transaction data that includes information
/// about the borrower and the list of collections borrowed.
///
/// ```swift
/// let borrowCollection = BorrowCollection(
///     id: "123",
///     borrowDate: Date(),
///     dueDate: Calendar.current.date(byAdding: .day, value: 14, to: Date())!,
///     quantity: 2,
///     borrowerId: "1",
///     borrowerName: "John Doe",
///     collectionBorrowed: [
///         CollectionBorrow(
///             id: "456",
///             collectionName: "Fiction",
///             returnedDate: nil
///         )
///     ]
/// )
/// ```
///
/// - Note: This struct conforms to `Decodable`, `Identifiable`, and `Hashable`.
struct BorrowCollection: Decodable, Identifiable, Hashable {
    /// The unique identifier of the borrow transaction.
    let id: String
    
    /// The date the books were borrowed.
    let borrowDate: Date
    
    /// The date the books are due to be returned.
    let dueDate: Date
    
    /// The total quantity of collections borrowed in this transaction.
    let quantity: Int
    
    /// The unique identifier of the borrower.
    let borrowerId: String
    
    /// The name of the borrower.
    let borrowerName: String
    
    /// The list of collections borrowed in this transaction.
    var collectionBorrowed: [CollectionBorrow]
    
    /// Coding keys for decoding JSON data into the `BorrowCollection` struct.
    enum CodingKeys: String, CodingKey {
        case id = "borrow_id"
        case borrowDate = "borrow_date"
        case dueDate = "borrow_due_date"
        case quantity = "borrow_qty"
        case borrowerId = "borrower_id"
        case borrowerName = "borrower_name"
        case collectionBorrowed = "collection_borrowed"
    }
    
    /// Custom initializer to handle date decoding with a specific date format.
    /// If decoding fails, default values are used for the dates.
    ///
    /// - Parameters:
    ///   - decoder: The decoder used to decode JSON data.
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        id = try container.decode(String.self, forKey: .id)
        quantity = try container.decode(Int.self, forKey: .quantity)
        borrowerId = try container.decode(String.self, forKey: .borrowerId)
        borrowerName = try container.decode(String.self, forKey: .borrowerName)
        
        // Use a custom date formatter for decoding.
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        
        let borrowDateString = try container.decode(String.self, forKey: .borrowDate)
        borrowDate = dateFormatter.date(from: borrowDateString) ?? Date()
        
        let dueDateString = try container.decode(String.self, forKey: .dueDate)
        dueDate = dateFormatter.date(from: dueDateString) ?? Date()
        
        collectionBorrowed = try container.decode([CollectionBorrow].self, forKey: .collectionBorrowed)
    }
}

/// Represents a borrowed collection item within a borrow transaction.
///
/// Use `CollectionBorrow` to handle data for each collection borrowed in a transaction.
///
/// ```swift
/// let collectionBorrow = CollectionBorrow(
///     id: "456",
///     collectionName: "Fiction",
///     returnedDate: nil
/// )
/// ```
///
/// - Note: This struct conforms to `Decodable`, `Identifiable`, and `Hashable`.
struct CollectionBorrow: Decodable, Identifiable, Hashable {
    /// The unique identifier of the borrowed collection.
    let id: String
    
    /// The name of the borrowed collection.
    let collectionName: String
    
    /// The date the collection was returned, if applicable.
    var returnedDate: Date?
    
    /// Coding keys for decoding JSON data into the `CollectionBorrow` struct.
    enum CodingKeys: String, CodingKey {
        case id = "collection_id"
        case collectionName = "collection_name"
        case returnedDate = "returned_date"
    }
    
    /// Custom initializer to handle optional date decoding with a specific date format.
    ///
    /// - Parameters:
    ///   - decoder: The decoder used to decode JSON data.
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        id = try container.decode(String.self, forKey: .id)
        collectionName = try container.decode(String.self, forKey: .collectionName)
        
        // Use a custom date formatter for decoding.
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        
        if let returnedDateString = try? container.decode(String.self, forKey: .returnedDate) {
            returnedDate = dateFormatter.date(from: returnedDateString)
        } else {
            returnedDate = nil
        }
    }
}
