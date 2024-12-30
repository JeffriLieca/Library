//
//  ViewModelTest.swift
//  LibraryTests
//
//  Created by Jeffri Lieca H on 30/12/24.
//

import Testing
import SwiftUI
import Supabase


@Suite("Check Duration Time",.serialized,.timeLimit(.minutes(1)))
struct ViewModelTest {
    
    @State var profile: Borrower?
    
    let supabase = SupabaseClient(supabaseURL: Secrets.apiUrl, supabaseKey: Secrets.apiKey)
    
    @Test("Check Login User",.serialized,.timeLimit(.minutes(1)), arguments: ["BOR001"])
    func checkLogin(id: String) async throws  {
        let borrower: [Borrower]? = try await supabase
            .from("borrower")
            .select("*")
            .eq("borrower_id", value: id)
            .execute()
            .value
        
        let borrowerValue = try #require(borrower)
        let name = try #require(borrowerValue[0].name)
        #expect(name == "Jeffri")
        
        self.profile = borrowerValue[0]

        
//        return borrowerValue[0]
    }
    
    
    
//    @Test("Fetch Borrowed Books For User",.serialized ,arguments: ["BOR001"])
    func fetchBorrowedBooks(for userId: String) async throws  {
        
        let supabase = SupabaseClient(supabaseURL: Secrets.apiUrl, supabaseKey: Secrets.apiKey)
        
        let firstRespone: BorrowCollection = try await supabase
                .from("borrowed_books_view_array")
                .select("*")
                .eq("borrower_id", value: userId)
                .order("borrow_id", ascending: true)
                .single()
                .execute()
                .value
            
            let quantity = firstRespone.quantity
//            let bookId = firstRespone.borrowerId
//            let bookName = firstRespone.borrowerName
//            let bookAuthor = firstRespone.borrowerName
//            let bookPublisher = firstRespone.borrowerName
//            let bookCategory = firstRespone.borrowerName
//            let bookStatus = firstRespone.borrowerName
//            #expect(1 == 1)
      
    
    
    
        
    }
    
    

}


