//
//  LoginView.swift
//  Library
//
//  Created by Jeffri Lieca H on 30/12/24.
//

import Foundation
import SwiftUI

struct LoginView : View {
    @Binding var page: ContentView.PagesName
    var body: some View {
        NavigationStack{
            VStack{
                Button {
//                    AdminView()
                    User.isAdmin = true

                    
                    page = .admin
                    print("pencet Admin")
                } label: {
                    ZStack{
                        Color.gray.opacity(0.5)
                        Label("Admin", systemImage: "person.badge.key")
                            .font(.largeTitle.bold())
                            .foregroundStyle(Color.white)
                    }
                    .frame(maxWidth: .infinity, maxHeight: 80)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .padding()
                }
                Button {
//                    UserView()
                    User.isAdmin = false
                    page = .user
                } label: {
                    ZStack{
                        Color.gray.opacity(0.5)
                        Label("User", systemImage: "person")
                            .font(.largeTitle.bold())
                            .foregroundStyle(Color.white)
                    }
                    .frame(maxWidth: .infinity, maxHeight: 80)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .padding()
                }
            }
        }
    }
}



