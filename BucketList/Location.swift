//
//  Location.swift
//  BucketList
//
//  Created by Izaan Saleem on 10/10/2024.
//

import Foundation
import MapKit

struct Location: Codable, Equatable, Identifiable {
    let id: UUID
    let name: String
    var description: String
    let latitude: Double
    let longitude: Double
    
    var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
    
    static func == (lhs: Location, rhs: Location) -> Bool {
        lhs.id == rhs.id
    }
    
    #if DEBUG
    static let example = Location(
        id: UUID(),
        name: "Example Location",
        description: "This is an example location.",
        latitude: 40.7127837,
        longitude: -74.005941
    )
    #endif
}
