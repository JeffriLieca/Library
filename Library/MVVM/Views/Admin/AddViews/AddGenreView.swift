//
//  AddGenreView.swift
//  Library
//
//  Created by Jeffri Lieca H on 30/12/24.
//

import Foundation
import SwiftUI


struct AddGenreView : View , Alertable{
    @Environment(ViewModel.self) var viewModel
    @State var name : String = ""
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
               
            }
            .navigationTitle("Add Genre")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar{
                ToolbarItem(placement: .topBarLeading){
                    Button {
                        //                        dismiss()
                        showAlert(title: "Exit Without Adding?", message: "Are you sure you want to exit? Your changes will not be saved.", alertAdd: false)
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
                                
                                try await viewModel.addGenre(name: name)
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
