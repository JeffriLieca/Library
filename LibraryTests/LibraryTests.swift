//
//  LibraryTests.swift
//  LibraryTests
//
//  Created by Jeffri Lieca H on 30/12/24.
//

import Testing

struct LibraryTests {

    @Test(.tags(.emptyString)) func example2() async throws {
        #expect(1==1)
        
        
       
        // Write your test here and use APIs like `#expect(...)` to check expected conditions.
    }
    
    @Test("nyoba") func baru() async throws {
        let mau = 10
        #expect(mau == 10)
    }
    
    

}

struct LoginViewTests {
    
//    let viewModel = ViewModel()
    
    @Test
    func example() throws {
        
    }
}

extension Tag {
    @Tag static var emptyString: Self
}
