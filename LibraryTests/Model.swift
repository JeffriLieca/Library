//
//  Model.swift
//  LibraryTests
//
//  Created by Jeffri Lieca H on 30/12/24.
//

import Foundation
import SwiftUI

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



enum Secrets {
    /// The base URL of the Supabase API.
    static let apiUrl = URL(string: "https://tzlzckugcjusyuzqzkyl.supabase.co")!
    
    /// The API key for authenticating with the Supabase service.
    static let apiKey = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InR6bHpja3VnY2p1c3l1enF6a3lsIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MzU0NDM4NDQsImV4cCI6MjA1MTAxOTg0NH0.gDE-E3QxfZiQYjaV0WDkv7W3gZBioTrhGOKYT9U57kk"
}
