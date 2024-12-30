//
//  AdminAccountView.swift
//  Library
//
//  Created by Jeffri Lieca H on 30/12/24.
//


import Foundation
import SwiftUI

struct AdminAccountView: View {
    @Environment(ViewModel.self) var viewModel
    @State private var user: User? // Model untuk data pengguna
    @State private var borrowList: [BorrowCollection] = [] // Model untuk daftar pinjaman
    @State private var isLoading = false
    @State private var errorMessage: String?
    
    var totalBorrow: Int {
            borrowList.count
        }
        
        var totalBorrowedCollections: Int {
            borrowList.reduce(0) { $0 + $1.quantity }
        }
        
        var totalBorrowers: Int {
            // Assuming `BorrowCollection` has a `borrowerId` field
            Set(borrowList.map { $0.borrowerId }).count
        }
    var body: some View {
        //        NavigationView {
        NavigationStack{
            VStack {
                
                if isLoading {
                    ProgressView("Loading user data...")
                }
                else {
                    
                    VStack(spacing: 16) {
                        // Data User
                        Text("Summary")
                            .font(.title)
                            .bold()
                        
                        HStack {
                            Text("Total Borrow\t\t:")
                                .fontWeight(.semibold)
                            Spacer()
                            Text("\(totalBorrow)")
                            Text("Transaction")
                                .frame(width: 100)
                                .multilineTextAlignment(.trailing)

                        }
                        
                        HStack {
                            Text("Total Borrower\t:")
                                .fontWeight(.semibold)
                            Spacer()
                            Text("\(totalBorrowers)")
                            Text("People")
                                .frame(width: 100)
                                .multilineTextAlignment(.trailing)
                        }
                        
                        HStack {
                            Text("Total Borrowed\t:")
                                .fontWeight(.semibold)
                            Spacer()
                            Text("\(totalBorrowedCollections)")
                            Text("Collection")
                                .frame(width: 100)
                                .multilineTextAlignment(.trailing)

                            //                            Text(user.joinDate, style: .date)
                        }
                    }
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 10).fill(Color(.systemGray6)))
                    .padding(.horizontal)
                }
                //                Text(errorMessage ?? "No user data found.")
                //                    .foregroundColor(.red)
                //                    .multilineTextAlignment(.center)
                //                    .padding()
                //            }
                
                Divider()
                
                // Daftar Peminjaman
                if isLoading {
                    ProgressView("Loading borrow list...")
                } else if borrowList.isEmpty {
                    Text("No borrow records found.")
                        .foregroundColor(.gray)
                        .padding()
                } else {
                    List(borrowList, id: \.self) { borrow in
                        NavigationLink(destination:
                                        BorrowDetailView(borrow: borrow))
                        {
                            HStack {
                                VStack(alignment: .leading) {
                                    Text("Borrow ID: \(borrow.id)")
                                        .fontWeight(.bold)
                                    Text("Date: \(borrow.borrowDate, style: .date)")
                                        .font(.subheadline)
                                        .foregroundColor(.gray)
                                }
                                Spacer()
                                // Tentukan warna berdasarkan kondisi koleksi yang belum dikembalikan
                                let hasUnreturnedItems = borrow.collectionBorrowed.contains { $0.returnedDate == nil }
                                Text("\(borrow.quantity) Items")
                                    .font(.subheadline)
                                    .foregroundColor(hasUnreturnedItems ? .red : .green)
                                
                            }
                            .padding(.vertical, 4)
                        }
                    }
                }
            }
        }
        .task {
            do {
                borrowList = try await viewModel.fetchAllBorrowedBooks()
            } catch {
                print(error)
            }
        }
    }
}
