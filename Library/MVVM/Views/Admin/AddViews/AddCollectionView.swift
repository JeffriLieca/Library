//
//  AddCollectionView.swift
//  Library
//
//  Created by Jeffri Lieca H on 30/12/24.
//

import Foundation
import SwiftUI

struct AddCollectionView : View , Alertable {
    @Environment(ViewModel.self) var viewModel
    @State var bookID : String
    @State var name : String = ""
    @State var qty : Int?
    @State var isbn : Int?
    //    @State var author : String
    @State var publisher : String = ""
    //    @State var description : String
    @State var publishYear : Int?
    //    @State var publishYear : Date
    @State var image : String = ""
    @Environment(\.dismiss) var dismiss
    @State var showAlertCancel : Bool = false
    @State var showAlertAdd : Bool = false
    @State var alertTitle : String = ""
    @State var alertMessage : String = ""
    @State private var editionSelected : String = ""
    @State private var showAddEdition : Bool = false
    
    var body: some View {
        NavigationStack{
            VStack{
                Form{
                    Section("Name"){
                        TextField("Name", text: $name)
                            .autocorrectionDisabled()
                    }
                    
                    Section {
                        Picker("Edition", selection: $editionSelected){

                            if viewModel.editions.isEmpty {
                                Text("No Edition").tag("")
                            }
                            else{
                                ForEach(viewModel.editions, id: \.self) { edition in
                                    Text(edition.name)
                                        .tag(edition.id ?? "")
                                }
                            }
                        }
                        
                    } header: {
                        HStack{
                            Text("Edition")
                            Spacer()
                            Button{
                                print("bisa")
                                showAddEdition = true
                            }
                            label :
                            {
                                Label("Add", systemImage: "plus")
                            }
                            .font(.caption)
                        }
                       
                    }

                    
                    Section("Quantity"){
                        TextField("0", value: $qty, format: .number)
                            .keyboardType(.numberPad)
                    }
                    Section("ISBN"){
                        TextField("9786028519939", value: $isbn, format: .number)
                            .keyboardType(.numberPad)
                    }
                    Section("Publisher"){
                        TextField("Publisher", text: $publisher)
                            .autocorrectionDisabled()
                    }
                    
                    Section("Publish Year"){
                       
                        TextField("Publish Year", value: $publishYear, format: .number)
                            .keyboardType(.numberPad)
                    }
                   
                    
                }
                
                
            }
            .navigationTitle("Add New Collection")
            //            .toolbar
            //            .navigationBarLeading
            .toolbar{
                //                Text("Add")
                ToolbarItem(placement: .topBarLeading){
                    Button {
                        if !name.isEmpty || qty != nil ||  isbn != nil ||  !publisher.isEmpty || publishYear != nil {
                            
                            
                            showAlert(title: "Exit Without Adding?", message: "Are you sure you want to exit? Your changes will not be saved.", alertAdd: false)
                        }
                        else {
                            dismiss()
                        }
                    
                        
                        
                    } label: {
                        Text("Cancel")
                        //                        Label("Cancel", systemImage: "plus")
                    }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button{
                        print("coba Add")
                        Task{
                            do {
                                
                                
                                try await viewModel.addCollection(
                                    bookId: bookID,
                                    editionId: editionSelected,
                                    name: name,
                                    qty: qty ?? 0,
                                    isbn: isbn?.description ?? "",
                                    publisher: publisher,
                                    publishYear: publishYear ?? 0
                                )
//                                print(viewModel.editions.first!)
//                                
//                                let newCollection = CollectionBookDecode(id: book!.id, name: name, imageName: nil, qty: qty ?? 0, edition: viewModel.editions.first(where: {editionSelected == $0.id})! , isbn: isbn?.description ?? "", publisher: publisher, publishYear: publishYear ?? 0)
//                                viewModel.fetchBooks()
//                                book?.collections.append(newCollection)
//                                viewModel.books.first(where: $0 == book!)?.collection?.append(newCollection)
                                
//                                    book!.collections.append(newCollection)
//                                viewModel.books.first(where: $0 == book!)?.collections?.append(newCollection)
//                                book?.collections?.append(newCollection)
//                                viewModel.books.first(where: $0 == book)?.collections?
//                                    .append(newCollection)
//                                print(newCollection)
//                                book.collections.append(CollectionBookDecode(id: book.id, name: name, imageName: nil, qty: qty ?? 0, edition: viewModel.editions.first(where: $0.id == editionSelected.id), isbn: isbn?.description ?? "", publisher: publisher, publishYear: publishYear ?? 0))
//                                

                                dismiss()
                            }
                            catch let error as InsertError {
                                // Tangani InsertError dengan rawValue yang sesuai
                                showAlert(title: "Invalid Input", message: error.rawValue, alertAdd: true)
                                print("Error: \(error.rawValue)")
                            }
                            catch {
                                // Tangani error lainnya yang tidak terduga
                                showAlert(title: "Unexpected Error", message: error.localizedDescription, alertAdd: true)
                                print("Unexpected Error: \(error.localizedDescription)")
                            }
                        }
                    } label: {
                        Text("Add")
                    }
                }
            }
            
        }
        .sheet(isPresented: $showAddEdition, onDismiss: {
            print("ondismiss")
            Task{
//                await loadEditions()
            }
        }, content: {
            AddEditionView()
        })
        .alert(alertTitle, isPresented: $showAlertCancel) {
            Button("Cancel", role: .cancel) {
                
            }
            Button("Exit", role: .destructive) {
                dismiss()
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
        .task {
            await loadEditions()
        }
        
    }
    
    func loadEditions() async {
        do {
            try await viewModel.fetchEditions()
            editionSelected = viewModel.editions.first?.id ?? ""
        }
        catch {
            print(error)
        }
    }
    
    func showAlert(title: String, message: String, alertAdd : Bool) {
        alertTitle = title
        alertMessage = message
        if alertAdd {
            showAlertAdd = true
        }
        else {
            showAlertCancel = true
        }
    }
}
