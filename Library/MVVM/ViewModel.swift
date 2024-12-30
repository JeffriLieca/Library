//
//  sad.swift
//  Library
//
//  Created by Jeffri Lieca H on 30/12/24.
//

import Foundation
import Supabase


/**
 # ViewModel
 A class responsible for managing the application's data and business logic for a library management system.

 This class interacts with Supabase for fetching, adding, and updating records such as books, genres, editions, borrow transactions, and user profiles. It also provides functionality for managing a cart system for book borrowing.
 */
@Observable final class ViewModel {
    
    // MARK: - Properties
    
    /**
     An array of books available in the library.
     */
    var books: [BookDecode] = [BookDecode]()
    
    /**
     An array of editions available in the library.
     */
    var editions: [Edition] = [Edition]()
    
    /**
     The profile of the currently logged-in borrower.
     */
    var profile: Borrower?
    
    /**
     A list of books borrowed by the current user.
     */
    var borrowedBooks: [BorrowCollection] = []
    
    /**
     A cart containing books selected for borrowing.
     */
    var cart: [CollectionBookDecode] = []
    
    /**
     The Supabase client for interacting with the database.
     */
    let supabase = SupabaseClient(supabaseURL: Secrets.apiUrl, supabaseKey: Secrets.apiKey)
    
    // MARK: - Cart Management
    
    /**
     Clears all items from the cart.
     */
    func clearCart() {
        cart.removeAll()
    }
    
    /**
     Adds a book to the cart.
     
     - Parameter book: The book to add to the cart.
     */
    func addToCart(book: CollectionBookDecode) {
        cart.append(book)
    }
    
    /**
     Removes a book from the cart.
     
     - Parameter book: The book to remove from the cart.
     */
    func deleteFromCart(book: CollectionBookDecode) {
        if let index = cart.firstIndex(where: { $0.id == book.id }) {
            cart.remove(at: index)
        }
    }
    
    // MARK: - Data Fetching
    
    /**
     Fetches all borrowed books for a specific user.
     
     - Parameter userId: The ID of the user.
     - Returns: An array of borrowed books.
     - Throws: An error if the fetch operation fails.
     */
    func fetchBorrowedBooks(for userId: String) async throws -> [BorrowCollection] {
        let response: [BorrowCollection] = try await supabase
            .from("borrowed_books_view_array")
            .select("*")
            .eq("borrower_id", value: userId)
            .order("borrow_id", ascending: false)
            .execute()
            .value
        
        print("Borrowed books fetched: \(response)")
        return response
    }
    
    /**
     Fetches all borrowed books.
     
     - Returns: An array of all borrowed books.
     - Throws: An error if the fetch operation fails.
     */
    func fetchAllBorrowedBooks() async throws -> [BorrowCollection] {
        let response: [BorrowCollection] = try await supabase
            .from("borrowed_books_view_array")
            .select("*")
            .order("borrow_id", ascending: false)
            .execute()
            .value
        
        print("All borrowed books fetched: \(response)")
        return response
    }
    
    /**
     Fetches all editions in the library.
     
     - Throws: An error if the fetch operation fails.
     */
    func fetchEditions() async throws {
        let response: [Edition] = try await supabase
            .from(Table.edition)
            .select()
            .execute()
            .value
        
        self.editions = response
    }
    
    /**
     Fetches all books in the library.
     
     - Throws: An error if the fetch operation fails.
     */
    func fetchBooks() async throws {
        do {
            let response: [BookDecode] = try await supabase
                .from(Table.book)
                .select(
            """
                \(BookDecode.CodingKeys.id.rawValue),
                \(BookDecode.CodingKeys.title.rawValue),
                \(BookDecode.CodingKeys.authors.rawValue),
                \(Table.genre) (
                    \(Genre.CodingKeys.id.rawValue),
                    \(Genre.CodingKeys.name.rawValue)
                    ),
                \(Table.collection) (
                    \(CollectionBookDecode.CodingKeys.id.rawValue),
                    \(CollectionBookDecode.CodingKeys.name.rawValue),
                    \(CollectionBookDecode.CodingKeys.imageName.rawValue),
                    \(CollectionBookDecode.CodingKeys.qty.rawValue),
                    \(Table.edition) (
                        \(Edition.CodingKeys.id.rawValue),
                        \(Edition.CodingKeys.name.rawValue),
                        \(Edition.CodingKeys.description.rawValue)
                        ),
                    \(CollectionBookDecode.CodingKeys.isbn.rawValue),
                    \(CollectionBookDecode.CodingKeys.publisher.rawValue),
                    \(CollectionBookDecode.CodingKeys.publishYear.rawValue)
                )
            """
                )
                .order(" \(BookDecode.CodingKeys.id.rawValue)", ascending: false)
                .execute()
                .value
            
            self.books = response
        } catch {
            print(error)
            fatalError(error.localizedDescription)
        }
    }
    
    // MARK: - Data Insertion
    
    /**
     Adds a new collection to the library.
     
     - Parameters:
     - bookId: The ID of the book.
     - editionId: The ID of the edition.
     - name: The name of the collection.
     - imageName: An optional image name for the collection.
     - qty: The quantity of the collection.
     - isbn: The ISBN of the book.
     - publisher: The publisher of the book.
     - publishYear: The year the book was published.
     - Throws: An error if validation fails or the insert operation fails.
     */
    func addCollection(bookId: String, editionId: String?, name: String, imageName: String? = nil, qty: Int, isbn: String, publisher: String, publishYear: Int) async throws {
        guard !bookId.isEmpty, !name.isEmpty, !isbn.isEmpty, !publisher.isEmpty, let editionId else {
            throw InsertError.emptyValue
        }
        guard qty > 0, publishYear > 0 else {
            throw InsertError.zeroValue
        }
        guard publishYear >= 1900, publishYear <= Calendar.current.component(.year, from: Date()) else {
            throw InsertError.invalidYear
        }
        
        let newCollection = CollectionBookEncode(bookId: bookId, editionId: editionId, name: name, imageName: imageName, qty: qty, isbn: isbn, publisher: publisher, publishYear: publishYear)
        
        try await supabase.from(Table.collection).insert(newCollection).execute()
        try await fetchBooks()
    }
    
    /**
     Adds a new edition to the library.
     
     - Parameters:
     - name: The name of the edition.
     - desc: An optional description of the edition.
     - Throws: An error if the insert operation fails.
     */
    func addEdition(name: String, desc: String?) async throws {
        guard !name.isEmpty else { throw InsertError.emptyValue }
        
        let newEdition = Edition(id: nil, name: name, description: desc)
        try await supabase.from(Table.edition).insert(newEdition).execute()
        try await fetchEditions()
    }
    
    /**
     Adds a new genre to the library.
     
     - Parameter name: The name of the genre.
     - Throws: An error if the insert operation fails.
     */
    func addGenre(name: String) async throws {
        guard !name.isEmpty else { throw InsertError.emptyValue }
        
        let newGenre = Genre(id: nil, name: name)
        try await supabase.from(Table.genre).insert(newGenre).execute()
    }
    
    /**
     Adds a new book to the library.
     
     - Parameters:
     - name: The name of the book.
     - authors: A list of authors for the book.
     - Throws: An error if the insert operation fails.
     */
    func addBook(name: String, authors: [String]) async throws {
        let authorsReal = authors.filter { !$0.isEmpty }
        
        guard !name.isEmpty, authorsReal.count > 0, !authorsReal[0].isEmpty else { throw InsertError.emptyValue }
        
        let newBook = BookEncode(id: nil, title: name, authors: authors)
        try await supabase.from(Table.book).insert(newBook).execute()
        
        try await fetchBooks()
    }
    
    
    
    
    // MARK: - Borrow Transactions
    
    struct BorrowTransactionParams: Encodable {
        let borrower_id: String
        let borrow_qty: Int
        let collections: [[String: String]]
    }
    
    /**
     Adds a borrow transaction from the borrow list to the system.
     
     - Throws: An error if the transaction or fetching fails.
     */
    func addBorrowFromBorrowList() async throws {
        guard cart.count > 0, let profileID = profile?.id else { throw InsertError.emptyValue }
        
        guard cart.filter({ ($0.qty > 0) }).count == cart.count else { throw InsertError.quantityZero }
        
        let qty = cart.count
        let params = BorrowTransactionParams(
            borrower_id: profileID,
            borrow_qty: qty,
            collections: cart.map { ["collection_id": $0.id] }
        )
        
        do {
            try await supabase
                .rpc("add_borrow_transaction", params: params)
                .execute()
            
            print("Transaction successful!")
            clearCart()
            
            try await fetchBooks()
            
        } catch {
            print("Transaction failed: \(error)")
            throw error
        }
    }
    
    // MARK: - User Management
    
    /**
     Checks if a user is logged in and returns the associated `Borrower` object.
     
     - Parameter id: The ID of the borrower.
     - Returns: A `Borrower` object if found, otherwise nil.
     - Throws: An error if the fetch operation fails.
     */
    func checkLogin(id: String) async throws -> Borrower? {
        let borrower: [Borrower]? = try await supabase
            .from(Table.user)
            .select("*")
            .eq("borrower_id", value: id)
            .execute()
            .value
        
        guard let borrower, borrower.count > 0 else { return nil }
        print(borrower[0])
        self.profile = borrower[0]
        return borrower[0]
    }
    
    // MARK: - Update Statement

    /// A struct that represents the parameters used to update the returned dates for borrowed collections.
    ///
    /// This struct contains the borrow ID, a list of collection IDs, and a list of corresponding statuses
    /// indicating whether each collection has been returned or not.
    ///
    /// - Note: This struct conforms to the `Codable` protocol for easy encoding and decoding between
    ///         your app and Supabase or other network services.
    ///
    /// - Example:
    ///   ```swift
    ///   let params = ReturnDateUpdateParams(borrowId: "12345", collectionIds: ["col1", "col2"], statuses: [true, false])
    ///   ```
    struct ReturnDateUpdateParams: Codable {
        /// The ID of the borrow transaction to update.
        let borrowId: String
        
        /// A list of collection IDs to be updated.
        let collectionIds: [String]
        
        /// A list of boolean values indicating whether each respective collection has been returned.
        let statuses: [Bool]
        
        /// Custom coding keys to map the struct properties to specific JSON keys.
        enum CodingKeys: String, CodingKey {
            case borrowId = "borrow_id"
            case collectionIds = "collection_ids"
            case statuses
        }
    }

    /// Updates the returned dates for borrowed collections based on the given borrow ID and collection statuses.
    ///
    /// This function makes an RPC (Remote Procedure Call) to the Supabase server to update the `returned_date`
    /// for the specified collections based on their current status (i.e., whether they have been returned).
    ///
    /// - Parameters:
    ///   - borrowId: The ID of the borrow transaction to update.
    ///   - collectionIds: A list of collection IDs for which the returned date needs to be updated.
    ///   - statuses: A list of boolean values indicating whether the respective collections have been returned.
    ///     Each element corresponds to a `collectionId` in the same order.
    ///
    /// - Throws:
    ///   - An error if the RPC call to update the returned dates fails.
    ///   - Any other error thrown by the Supabase client during the execution.
    ///
    /// - Example:
    ///   ```swift
    ///   do {
    ///       try await updateReturnedDates(borrowId: "12345", collectionIds: ["col1", "col2"], statuses: [true, false])
    ///   } catch {
    ///       print("Failed to update returned dates: \(error)")
    ///   }
    ///   ```
    ///
    /// - Note:
    ///   This function assumes that the `update_returned_dates` RPC is already defined in the Supabase backend.
    ///   The RPC should handle the necessary updates to the database.
    func updateReturnedDates(borrowId: String, collectionIds: [String], statuses: [Bool]) async throws {
        do {
            // Create a parameter object to pass to the RPC
            let params = ReturnDateUpdateParams(borrowId: borrowId, collectionIds: collectionIds, statuses: statuses)
            
            // Make the RPC call to update the returned dates
            let response = try await supabase
                .rpc("update_returned_dates", params: [
                    params
                ])
                .execute()
            
            // Log the response from Supabase (optional, for debugging purposes)
            print("Response from Supabase: \(response)")
            
        } catch {
            // Log any errors that occur during the RPC call
            print("Error updating returned dates: \(error)")
            throw error  // Rethrow the error to propagate it up the call stack
        }
    }


}


/// Enum defining the table names used in the Supabase database.
enum Table {
    /// Represents the 'book' table in the database.
    static let book = "book"
    
    /// Represents the 'collection' table in the database.
    static let collection = "collection"
    
    /// Represents the 'genre' table in the database.
    static let genre = "genre"
    
    /// Represents the 'edition' table in the database.
    static let edition = "edition"
    
    /// Represents the 'borrower' table in the database.
    static let user = "borrower"
    
    /// Represents the 'borrow' table in the database.
    static let borrow = "borrow"
    
    /// Represents the 'collection_borrow' table in the database.
    static let borrowCollection = "collection_borrow"
}

/// Enum for custom error handling during data insertion.
enum InsertError: String, Error {
    /// The value cannot be null.
    case nullValue = "Value cannot be null"
    
    /// The value cannot be empty.
    case emptyValue = "Value cannot be empty"
    
    /// The value cannot be zero.
    case zeroValue = "Value cannot be zero"
    
    /// The year must be between 1900 and the current year.
    case invalidYear = "Year must be between 1900 and Current Year"
    
    /// The quantity cannot be zero.
    case quantityZero = "Quantity cannot be zero"
}
