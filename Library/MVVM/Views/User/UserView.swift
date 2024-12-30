//
//  UserView.swift
//  Library
//
//  Created by Jeffri Lieca H on 30/12/24.
//

import Foundation
import SwiftUI

struct UserView : View {
    @Binding var page: ContentView.PagesName
    @State private var isAuthorized: Bool = false
    @State private var username: String = ""
    @State private var selectedTab: Int = 0 // Melacak tab yang aktif
    @Environment(ViewModel.self) var viewModel
    var body: some View {
        if !isAuthorized {
            NavigationStack{
                Spacer()
                VStack (alignment: .center) {
                    
                    TextField("Username (BOR001)", text: $username)
                        .frame(maxWidth: .infinity)
                        .padding()
                    
                        .multilineTextAlignment(.center)
                        .autocorrectionDisabled()
                    Divider()
                    Button("Login"){
                        Task {
                            isAuthorized = try await checkLogin(id: username)
                        }
                    }
                    .padding()
                }
                .font(.title2.bold())
                .background(.gray.opacity(0.5))
                //            }
                
                //            .background(Color.blue)
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .padding()
                Spacer()
                    .toolbar {
                        ToolbarItem(placement: .topBarLeading) {
                            Button("Back") {
                                page = .login
                            }
                        }
                    }
            }
            
            
        }
        else {
            
            TabView(selection: $selectedTab) {
                NavigationStack{
                    BookView()
                        .environment(viewModel)
                        .navigationTitle("Books") // Ganti judul berdasarkan tab
                        .toolbar {
                            ToolbarItem(placement: .topBarLeading) {
                                Button("Logout") {
                                    page = .login
                                }
                            }
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
                .tabItem {
                    Label("Books", systemImage: "book")
                }
                .tag(0) // Identifikasi tab
                
                NavigationStack{
                    MyAccountView()
                    //                        .environment(viewModel)
                        .navigationTitle("My Account") // Ganti judul berdasarkan tab
                        .toolbar {
                            ToolbarItem(placement: .topBarLeading) {
                                Button("Logout") {
                                    page = .login
                                }
                            }
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
                .tabItem {
                    Label("Account", systemImage: "person.circle")
                }
                .tag(1) // Identifikasi tab
               
                
                
                
                
            }
            //        .onAppear{
            //            User.isAdmin = false
            //        }
        }
    }
    
    func checkLogin(id: String) async throws -> Bool {
        do {
            let authorize = try await viewModel.checkLogin(id: id)
            if authorize != nil {
                return true
            }
            return false
        }
        catch{
            print(error)
            return false
        }
    }
}
