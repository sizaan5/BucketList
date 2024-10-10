//
//  Location.swift
//  BucketList
//
//  Created by Izaan Saleem on 10/10/2024.
//

import Foundation

struct Location: Codable, Equatable, Identifiable {
    let id: UUID
    let name: String
    var description: String
    let latitude: Double
    let longitude: Double
}
