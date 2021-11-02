//
//  Album.swift
//  ITunesTestTask
//
//  Created by Кирилл Тарасов on 02.11.2021.
//


import Foundation

class Track: Codable, CustomStringConvertible {
    var description: String {
        return "\nResult - Name: \(trackName ?? "NO BAME")"
    }
    
    var trackName: String? = nil
    var trackTimeMillis: Int? = 0

}

class foundTracks: NSObject, Codable {
    var resultCount = 0
    var results = [Track]()
    
}
