//
//  Album.swift
//  ITunesTestTask
//
//  Created by Кирилл Тарасов on 02.11.2021.
//


import Foundation

class Album: Codable, CustomStringConvertible {
    var collectionName = ""
    var collectionId: Int = 0
    var artistName = ""
    var copyright: String? = ""
    var artworkUrl100: String? = ""
    var trackCount = 0
    var releaseDate: String? = nil
     
    var description: String {
        return "\nResult - Name: \(collectionName), Artist Name: \(artistName)"
    }
}

class foundAlbums: NSObject, Codable  {
    var resultCount = 0
    var results = [Album]()
}
