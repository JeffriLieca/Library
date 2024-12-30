//
//  DetailCollectionView.swift
//  Library
//
//  Created by Jeffri Lieca H on 30/12/24.
//

import Foundation
import SwiftUI

struct DetailCollectionView : View {
    @Environment(ViewModel.self) var viewModel
    @State var collection : CollectionBookDecode
    var body: some View {
        ZStack{
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.gray)
                .opacity(0.5)
            
            VStack{
            
                VStack {
                    Image("harry")
                        .resizable()
                        .scaledToFill()
                }
                .frame(maxWidth: .infinity, maxHeight: 300)
                .background(.red)
                .clipShape(RoundedRectangle(cornerRadius: 10))
//                .background(.red)
                .padding()
                
//                Spacer()
                VStack(alignment: .leading){
                    Text(collection.name)
                        .font(.title3.bold())
                        .frame(maxWidth: .infinity)
                        .multilineTextAlignment(.center)
                        .padding(.bottom)
                    VStack(alignment: .leading){
                        Text("Edition \t: \(collection.edition.name)")
                        Text("Publisher \t: \(collection.publisher)")
                        Text("Year \t\t: \(String(collection.publishYear))")
                        Text("Quantity \t: \(collection.qty)")
//                        Text("sadsadsa dhasidhsad asdisaid sahdiasidhas diashi dsadiashd isa sadhais hd")
                    }
                }
                .padding(.horizontal)
                Spacer()
                if !User.isAdmin{
                    
                    
                    Button {
                        viewModel.addToCart(book: collection)
                    } label: {
                        Label("Add to Borrow List", systemImage: "plus.circle")
                      
                    }
                    .font(.title)
                    .buttonStyle(.borderedProminent)
                    .tint(.green)
                    .padding()
                }
            }
        }
        .padding()
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
    }
}


