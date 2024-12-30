//
//  MyAccountView.swift
//  Library
//
//  Created by Jeffri Lieca H on 30/12/24.
//

import Foundation
import SwiftUI

struct MyAccountView: View {
    @Environment(ViewModel.self) var viewModel
    @State private var user: User? // Model untuk data pengguna
    @State private var borrowList: [BorrowCollection] = [] // Model untuk daftar pinjaman
    @State private var isLoading = false
    @State private var errorMessage: String?
    
    var body: some View {
        //        NavigationView {
        VStack {
            if let user = viewModel.profile {
                VStack(spacing: 16) {
                    // Data User
                    Text("My Account")
                        .font(.title)
                        .bold()
                    
                    HStack {
                        Text("Name:")
                            .fontWeight(.semibold)
                        Spacer()
                        Text(user.name)
                    }
                    
                    HStack {
                        Text("Email:")
                            .fontWeight(.semibold)
                        Spacer()
                        Text("Email user")
                    }
                    
                    HStack {
                        Text("Member Since:")
                            .fontWeight(.semibold)
                        Spacer()
                        Text("2003")
                        //                            Text(user.joinDate, style: .date)
                    }
                }
                .padding()
                .background(RoundedRectangle(cornerRadius: 10).fill(Color(.systemGray6)))
                .padding(.horizontal)
            } else if isLoading {
                ProgressView("Loading user data...")
            } else {
                Text(errorMessage ?? "No user data found.")
                    .foregroundColor(.red)
                    .multilineTextAlignment(.center)
                    .padding()
            }
            
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
//                                    Text("Borrow Detail")
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
        .task {
            do {
                guard let profileId = viewModel.profile?.id else { return }
                borrowList = try await viewModel.fetchBorrowedBooks(for: profileId)
//                try await viewModel.fetchBorrowedBooks(for: viewModel.profile!.id!)
            } catch {
                print(error)
            }
        }
    }
}
