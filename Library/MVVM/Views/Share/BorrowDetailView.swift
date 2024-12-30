//
//  BorrowDetailView.swift
//  Library
//
//  Created by Jeffri Lieca H on 30/12/24.
//

import Foundation
import SwiftUI

struct BorrowDetailView: View {
//    let borrow: BorrowCollection
//    let isChecked : [Bool]
//
    @Environment(ViewModel.self) var viewModel
    @State private var isEdit : Bool = false
    @State private var borrow: BorrowCollection // Menggunakan @State agar bisa diubah
    @State private var isChecked: [Bool] // Menyimpan status checkbox
    
    init(borrow: BorrowCollection) {
        self._borrow = State(initialValue: borrow)
        
//        print("hasil map \(borrow.collectionBorrowed.map{$0.returnedDate != nil })")
        self._isChecked = State(initialValue: borrow.collectionBorrowed.map { $0.returnedDate != nil })
//        print("init \(isChecked)")
    }
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Borrow ID: \(borrow.id)")
                .font(.headline)
            
            if User.isAdmin {
                Text("Name: \(borrow.borrowerName)")
                    .font(.headline)
                    .padding(.bottom, 4)
            }
            
            Text("Borrow Date: \(formattedDate(borrow.borrowDate))")
                .font(.subheadline)
            
            Text("Due Date: \(formattedDate(borrow.dueDate))")
                .font(.subheadline)
            
            List {
                
                ForEach(borrow.collectionBorrowed.indices, id: \.self) { index in
                    let collection = borrow.collectionBorrowed[index]
                    
                    VStack(alignment: .leading) {
                        Text("Collection ID: \(collection.id)")
                            .font(.subheadline)
                        
                        Text("Collection Name: \(collection.collectionName)")
                            .font(.headline)
                        
                        Text("Return Status: \(isChecked[index] ? "Returned" : "Not Returned")")
                            .font(.subheadline)
                            .foregroundColor(isChecked[index] ? .green : .red)
                    }
                    .onTapGesture {
                        if User.isAdmin && isEdit{
                            toggleReturnStatus(at: index)
                        }
                    }
                }
            }
        }
        //            .padding()
        .navigationBarTitle("Borrow Detail", displayMode: .inline)
        .toolbar{
            if User.isAdmin {
                ToolbarItem(placement: .topBarTrailing){
                    if isEdit{
                        Button{
                            saveChanges()
                        } label: {
                            
                            Label("Save", systemImage: "square.and.arrow.down")
                                .font(.largeTitle)
                            
                        }
                    }
                    else {
                        Button{
                            isEdit = true
                        } label: {
                            
                            Label("Edit", systemImage: "pencil.and.scribble")
                                .font(.largeTitle)
                            
                        }
                    }
                }
            }
        }
        .padding()
    }
    
    private func saveChanges() {
        let statues = isChecked.map(\.self)
        let collectionIds = borrow.collectionBorrowed.map(\.id)
        print("collection ids \(collectionIds)")
        print("status \(statues)")
        Task{
            do {
                try await viewModel.updateReturnedDates(borrowId: borrow.id, collectionIds: collectionIds, statuses: statues)
                isEdit = false
            }
            catch {
                print(error)
            }
        }
    }
    
    private func toggleReturnStatus(at index: Int) {
        // Ubah status isChecked
        isChecked[index].toggle()
        
        // Update nilai returnedDate di collectionBorrowed
        borrow.collectionBorrowed[index].returnedDate = isChecked[index] ? Date() : nil
    }
    
    func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}
