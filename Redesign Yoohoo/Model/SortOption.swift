//
//  SortOption.swift
//  Redesign Yoohoo
//
//  Created by Amelia Morencia Irena on 15/05/25.
//

import Foundation

enum SortOption: String, CaseIterable, Identifiable {
    case az = "A-Z"
    case za = "Z-A"
    case latest = "Latest"
    case earliest = "Earliest"
    
    var id: String { self.rawValue }
}
