//
//  SearchRequest.swift
//  ITunesTestTask
//
//  Created by Кирилл Тарасов on 02.11.2021.
//


import Foundation
import CoreData


extension SearchRequest {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<SearchRequest> {
        return NSFetchRequest<SearchRequest>(entityName: "SearchRequest")
    }

    @NSManaged public var text: String?

}

extension SearchRequest : Identifiable {

}
