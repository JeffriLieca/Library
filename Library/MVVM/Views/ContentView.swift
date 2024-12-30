//
//  ContentView.swift
//  Library
//
//  Created by Jeffri Lieca H on 29/12/24.
//

import SwiftUI

class User {
    static var isAdmin: Bool = false
}




struct ContentView : View {
    enum PagesName {
        case login
        case admin
        case user
    }
    @State var page: PagesName = .login
    @Environment(ViewModel.self) var viewModel
    @State var books: [BookDecode] = []
    var body: some View {
        VStack{
            switch page {
            case .login:
                LoginView(page: $page)
            case .admin:
                AdminView(page: $page).environment(viewModel)
            case .user:
               
                UserView(page: $page).environment(viewModel)
            }
        }
        .task{
            do {
                try await viewModel.fetchBooks()
            }
            catch{
                fatalError(error.localizedDescription)
            }
        }
    }
}



#Preview {
    ContentView().environment(ViewModel())
}
