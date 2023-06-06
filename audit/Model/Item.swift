//
//  item.swift
//  audit
//
//  Created by LI,JYUN-SIAN on 27/5/23.
//

import Foundation
import UIKit

struct Item: Codable {
    var imageName: String?
    var ischeck: Bool
    var site: String
    var date: String?
    var team: String?
    var Comments: String?
    
    static let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    
    static func saveToFile(items: [Self]) {
        let propertyEncoder = PropertyListEncoder()
        if let data = try? propertyEncoder.encode(items) {
            let url = Self.documentsDirectory.appendingPathComponent("item")
            try? data.write(to: url)
        }
    }
    
    static func readItemsFromFile() -> [Self]? {
        let propertyDecoder = PropertyListDecoder()
        let url = Self.documentsDirectory.appendingPathComponent("item")
        if let data = try? Data(contentsOf: url), let items = try? propertyDecoder.decode([Self].self, from: data) { return items } else { return nil}
    }
    
}

