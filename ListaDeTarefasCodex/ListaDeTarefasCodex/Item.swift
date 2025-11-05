//
//  Item.swift
//  ListaDeTarefasCodex
//
//  Created by Gustavo Cosme on 05/11/25.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
