//
//  CollectionBookView.swift
//  Library
//
//  Created by Jeffri Lieca H on 30/12/24.
//

import Foundation
import SwiftUI


struct CollectionBookView : View {
    @Environment(ViewModel.self) var viewModel
    @State var bookID : String
//    @State var collectionBooks : [CollectionBookDecode]
    @State var showSheet = false
    var body: some View {
        NavigationStack{
            //            For
            VStack{
                List{
                    if User.isAdmin {
                        
                        Section{
                            Button {
                                //                            print("go to collection")
                                showSheet = true
                            } label: {
                                Label("Add Collection", systemImage: "plus")
                            }
                            .multilineTextAlignment(.center)
                        }
                    }
                    
                    if let book = viewModel.books.first(where: { $0.id == bookID }) {
                        ForEach(book.collections) { collection in
                            Section ("\(collection.edition.name)") {
                                NavigationLink {
                                    //                                NavigationLink("Details"){
                                    DetailCollectionView(collection: collection)
                                    //                            Text("Details of \(collection.name)")
                                    //                                }
                                } label: {
                                    HStack{
                                        Image("harry")
                                            .resizable()
                                            .scaledToFill()
                                            .frame(maxWidth: 50, maxHeight: 50)
                                            .clipShape(RoundedRectangle(cornerRadius: 10))
                                        VStack (alignment: .leading){
                                            Text(collection.name)
                                                .font(.subheadline.bold())
                                            Text("Qty: \(collection.qty)")
                                                .font(.caption)
                                                .foregroundStyle(.gray)
                                            
                                        }
                                    }
                                }
                                //                            .navigationSplitViewStyle(.automatic)
                            }
    //                        .padding(0)
                        }
                    }
                    
                    
                }
                
            }
            
            .toolbar {
                if !User.isAdmin{
                    ToolbarItem(placement: .topBarTrailing) {
                        NavigationLink{
                            BorrowListView()
                        }label: {
                            Image(systemName: "text.book.closed")
                        }
                    }
                }
            }
            
            .navigationTitle("Collections")
            .navigationBarTitleDisplayMode(.inline)
            .sheet(isPresented: $showSheet, content: {
                AddCollectionView(bookID: bookID).environment(viewModel)
            })
        }
    }
}

