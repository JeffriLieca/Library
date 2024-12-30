//
//  Borrow.swift
//  Library
//
//  Created by Jeffri Lieca H on 30/12/24.
//

import Foundation

/// Represents a decoded borrow transaction retrieved from a backend or API.
///
/// Use `BorrowDecode` to handle data received from a backend or API
/// related to borrowing transactions.
///
/// ```swift
/// let borrow = BorrowDecode(
///     id: "123",
///     borrowDate: Date(),
///     dueDate: Calendar.current.date(byAdding: .day, value: 14, to: Date())!,
///     qty: 2,
///     borrower: Borrower(id: "1", name: "John Doe")
/// )
/// ```
///
/// - Note: This struct conforms to `Decodable` and `Identifiable`.
struct BorrowDecode: Decodable, Identifiable {
    /// The unique identifier of the borrow transaction.
    let id: String
    
    /// The date the book was borrowed.
    let borrowDate: Date
    
    /// The date the book is due to be returned.
    let dueDate: Date
    
    /// The quantity of books borrowed in this transaction.
    let qty: Int
    
    /// The borrower associated with the transaction.
    let borrower: Borrower
    
    /// Coding keys for decoding JSON data into the `BorrowDecode` struct.
    ///
    /// Maps JSON keys to Swift properties. For example, `borrow_id` is mapped to `id`.
    enum CodingKeys: String, CodingKey {
        case id = "borrow_id"
        case borrowDate = "borrow_date"
        case dueDate = "borrow due_date"
        case qty = "borrow_qty"
        case borrower
    }
}

/// Represents an encoded borrow transaction for sending data to a backend or API.
///
/// Use `BorrowEncode` when creating or updating borrowing transactions
/// that need to be sent to a backend or API.
///
/// ```swift
/// let borrow = BorrowEncode(
///     id: nil,
///     borrowDate: Date(),
///     dueDate: Calendar.current.date(byAdding: .day, value: 14, to: Date())!,
///     qty: 2,
///     borrowerId: "1"
/// )
/// ```
///
/// - Note: This struct conforms to `Encodable`.
struct BorrowEncode: Encodable {
    /// The unique identifier of the borrow transaction, optional for newly created transactions.
    let id: String?
    
    /// The date the book was borrowed.
    let borrowDate: Date
    
    /// The date the book is due to be returned.
    let dueDate: Date
    
    /// The quantity of books borrowed in this transaction.
    let qty: Int
    
    /// The unique identifier of the borrower associated with the transaction.
    let borrowerId: String
    
    /// Coding keys for encoding Swift properties into JSON data.
    ///
    /// Maps Swift properties to JSON keys. For example, `borrow_id` is mapped to `id`.
    enum CodingKeys: String, CodingKey {
        case id = "borrow_id"
        case borrowDate = "borrow_date"
        case dueDate = "borrow due_date"
        case qty = "borrow_qty"
        case borrowerId = "borrowerborrower_id"
    }
}
