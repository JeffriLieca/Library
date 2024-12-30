//
//  AdminView.swift
//  Library
//
//  Created by Jeffri Lieca H on 30/12/24.
//

import Foundation
import SwiftUI


struct AdminView: View {
    @Binding var page: ContentView.PagesName
    @State private var selectedTab: Int = 0
    @Environment(ViewModel.self) var viewModel

    var body: some View {
        TabView(selection: $selectedTab) {
            NavigationStack {
                BookView()
                    .environment(viewModel)
                    .navigationTitle("Books (Admin)")
                    .toolbar {
                        ToolbarItem(placement: .topBarLeading) {
                            Button("Logout") {
                                page = .login
                            }
                        }
                    }
            }
            .tabItem {
                Label("Books", systemImage: "book.and.wrench")
            }
            .tag(0)

            NavigationStack {
                AdminAccountView()
                    .navigationTitle("Borrower")
                    .toolbar {
                        ToolbarItem(placement: .topBarLeading) {
                            Button("Logout") {
                                page = .login
                            }
                        }
                    }
            }
            .tabItem {
                Label("Borrower", systemImage: "person.3")
            }
            .tag(1)
        }
    }
}
