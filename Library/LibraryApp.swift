//
//  LibraryApp.swift
//  Library
//
//  Created by Jeffri Lieca H on 29/12/24.
//

import SwiftUI

@main
struct LibraryApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(ViewModel())
               
//                .environment(try? ViewModel())
        }
    }
}
