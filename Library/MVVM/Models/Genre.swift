//
//  Genre.swift
//  Library
//
//  Created by Jeffri Lieca H on 29/12/24.
//

import Foundation

struct Genre : Codable, Hashable {
    let id : String?
    let name : String
    
    enum CodingKeys : String, CodingKey {
        case id = "genre_id"
        case name = "genre_name"
    }
}


struct GenreSelection {
    let genre : Genre
    let isSelected : Bool = false
}
