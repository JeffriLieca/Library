//
//  CartView.swift
//  Library
//
//  Created by Jeffri Lieca H on 30/12/24.
//

import Foundation
import SwiftUI
import PostgREST

struct BorrowListView: View {
    @Environment(ViewModel.self) var viewModel
    @Environment(\.dismiss) var dismiss
    @State var showAlertDelete : Bool = false
    @State var showAlertAdd : Bool = false
    @State var alertTitle : String = ""
    @State var alertMessage : String = ""
    @State var bookWantToDelete : CollectionBookDecode?
    var body: some View {
        NavigationStack {
            VStack {
                if viewModel.cart.isEmpty {
                    VStack {
                        Image(systemName: "tray")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 100, height: 100)
                            .foregroundColor(.gray)
                        Text("Your Borrow List is Empty")
                            .font(.headline)
                            .foregroundColor(.gray)
                            .padding()
                    }
                } else {
                    List {
                        ForEach(viewModel.cart, id: \.self) { book in
                            HStack(alignment: .top) {
                                if let imageName = book.imageName {
                                    Image(imageName)
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 50, height: 70)
                                        .cornerRadius(5)
                                } else {
                                    Image(systemName: "book")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 50, height: 70)
                                        .foregroundColor(.gray)
                                        .cornerRadius(5)
                                }
                                
                                VStack(alignment: .leading, spacing: 5) {
                                    Text(book.name)
                                        .font(.headline)
                                    Text("Edition: \(book.edition.name)")
                                        .font(.subheadline)
                                        .foregroundColor(.secondary)
                                    Text("Publisher: \(book.publisher)")
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                    Text("Qty: \(book.qty)")
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                }
                                
                                Spacer()
                                
                                Button {
                                    bookWantToDelete = book
                                    showAlert(
                                        title: "Delete Borrow List?",
                                        message: "Are you sure you want to delete this borrow list? This action cannot be undone.",
                                        alertAdd: false
                                    )

                                }
                                label: {
                                    Image(systemName: "trash")
                                        .foregroundColor(.red)
                                }
                                .buttonStyle(BorderlessButtonStyle()) // To prevent row swipe conflict
                            }
                            .padding(.vertical, 5)
                        }
                        .onDelete(perform: deleteItems)
                    }
                }
                
                Spacer()
                
                if !viewModel.cart.isEmpty {
                    Button{
                        Task {
                            
                            await confirmBorrow()
                        }
                    } label: {

                        Text("Confirm Borrow (\(viewModel.cart.count) Items)")
                            .fontWeight(.bold)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .foregroundColor(.white)
                            .background(Color.blue)
                            .cornerRadius(10)
                    }
                    .padding(.horizontal)
                }
            }
            .navigationTitle("Borrow List")
//            .toolbar {
//                ToolbarItem(placement: .navigationBarLeading) {
//                    EditButton()
//                }
//            }
        }
        .alert(alertTitle, isPresented: $showAlertDelete) {
            Button("Cancel", role: .cancel) {
                
            }
            Button("Delete", role: .destructive) {
                if let bookWantToDelete{
                    viewModel.deleteFromCart(book: bookWantToDelete)
//                    bookWantToDelete = nil
                }
                else {
                    print("Book not found")
                }
                bookWantToDelete = nil
//                dismiss()
            }
        }
        message: {
            Text(alertMessage)
        }
        .alert(alertTitle, isPresented: $showAlertAdd) {
          
        }
        message: {
            Text(alertMessage)
        }
    }
    
    // MARK: - Actions
    func removeBookFromCart(book: CollectionBookDecode) {
        if let index = viewModel.cart.firstIndex(of: book) {
            viewModel.cart.remove(at: index)
        }
    }
    
    func deleteItems(at offsets: IndexSet) {
        viewModel.cart.remove(atOffsets: offsets)
    }
    
    func confirmBorrow() async {
        // Handle confirmation logic
        print("Borrow confirmed for \(viewModel.cart.count) items.")
        do {
            try await viewModel.addBorrowFromBorrowList()
            
            dismiss()
        }
        catch let error as PostgrestError {
            showAlert(title: "Error Code : \(String(describing: error.code))", message: error.message, alertAdd: true)
            print("Error: \(error.message)")
        }
        catch {
            print("Error adding borrow: \(error)")
        }
    }
    
    func showAlert(title: String, message: String, alertAdd : Bool) {
        alertTitle = title
        alertMessage = message
        if alertAdd {
            showAlertAdd = true
        }
        else {
            showAlertDelete = true
        }
    }
    
    
}
