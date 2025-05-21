//
//  ModelData.swift
//  Redesign Yoohoo
//
//  Created by Amelia Morencia Irena on 15/05/25.
//
//
import SwiftUI
import SwiftData

@Model
class Buddy: Identifiable {
    @Attribute(.unique) var id: UUID
    var name: String
    var image: String
    var experience: String
    var createdAt: Date
    
    init(id: UUID = UUID(), name: String, image: String, experience: String) {
        self.id = id
        self.name = name
        self.image = image
        self.experience = experience
        self.createdAt = Date()
    }
}
