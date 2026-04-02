//
//  Item.swift
//  firusya-app
//
//  Created by Рева Георгий Александрович on 02.04.2026.
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
