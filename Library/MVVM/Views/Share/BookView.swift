//
//  BookView.swift
//  Library
//
//  Created by Jeffri Lieca H on 30/12/24.
//

import Foundation
import SwiftUI


struct BookView : View {
    @Environment(ViewModel.self) var viewModel
    
    var body: some View {
        NavigationStack{
            VStack{
                if viewModel.books.isEmpty {
                    ProgressView()
                }
                else {
                    List {
                        ForEach(viewModel.books) { book in
                            NavigationLink {
//                                NavigationLink("Details"){
                                CollectionBookView(bookID: book.id)
//                                }
                            } label: {
                                HStack{
                                    Image("harry")
                                        .resizable()
                                        .scaledToFill()
                                        .frame(maxWidth: 50, maxHeight: 50)
                                        .clipShape(RoundedRectangle(cornerRadius: 10))
                                    VStack (alignment: .leading){
                                        Text(book.title)
                                            .font(.subheadline.bold())
                                        Text( book.authors.joined(separator: " | "))
                                            .font(.caption)
                                            .foregroundStyle(.gray)
                                        
                                    }
                                }
                            }
//                            .navigationSplitViewStyle(.automatic)
                        }
                        .onDelete {_ in
                            print("daaqui")
                        }
                    }
                    .refreshable{
                        Task{
                            try await viewModel.fetchBooks()
                        }
                    }
                }
            }
            .navigationTitle("Books")
            .toolbar{
                if User.isAdmin {
                    ToolbarItem(placement: .topBarTrailing){
                        NavigationLink{
                            AddBookView().environment(viewModel)
                        } label: {
                            Label("Add Book", systemImage: "plus.square")
                                .font(.largeTitle)
                        }
                    }
                }
            }
        }
//        .task{
//            do {
//                try await viewModel.fetchBooks()
////                try await viewModel.fetchEditions()
//            }
//            catch{
//                fatalError(error.localizedDescription)
//            }
//        }
    }
}


