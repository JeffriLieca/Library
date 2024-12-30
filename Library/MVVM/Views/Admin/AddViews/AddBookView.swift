//
//  AddBookView.swift
//  Library
//
//  Created by Jeffri Lieca H on 30/12/24.
//

import Foundation
import SwiftUI

struct AddBookView : View , Alertable {
    @Environment(ViewModel.self) var viewModel
    @State var name : String = ""
    @State var authors : [String] = [""]
    @State var genres : [GenreSelection] = [GenreSelection]()
    @State var showAlertCancel : Bool = false
    @State var showAlertAdd : Bool = false
    @State var alertTitle : String = ""
    @State var alertMessage : String = ""
    @Environment(\.dismiss) var dismiss
    var body: some View {
        NavigationStack{
            Form {
                
                Section("Name"){
                    TextField("Name", text: $name)
                        .autocorrectionDisabled()
                }
                
                Section {
                    ForEach(authors.indices, id: \.self){ index in
                        TextField("Author \(index+1)", text: $authors[index])
                            .autocorrectionDisabled()
                            .onChange(of: authors[index]){ _ , newValue in
                                if newValue.isEmpty{
                                    authors.remove(at: index)
                                }
                            }
                    }
                    
                }
                header: {
                    HStack{
                        Text("Authors")
                        Spacer()
                        Button {
                            authors.append("")
                        } label: {
                            Label("add author", systemImage: "plus.circle")
                                .font(.subheadline)
                        }
                    }
                }
            }
            .navigationTitle("Add Book")
            .navigationBarBackButtonHidden()
            .navigationBarTitleDisplayMode(.inline)
            .toolbar{
                ToolbarItem(placement: .topBarLeading){
                    Button {
                        showAlert(title: "Exit Without Adding?", message: "Are you sure you want to exit? Your changes will not be saved.", alertAdd: false)
                    } label: {
                        Text("Cancel")
                    }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button{
                        print("coba Add")
                        Task{
                            do {
                                try await viewModel.addBook(name: name, authors: authors)
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
//                        Label("Add", systemImage: "plus")
                    }
                }
            }
        }
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
