//
//  ContentView-ViewModel.swift
//  BucketList
//
//  Created by Izaan Saleem on 14/10/2024.
//

import Foundation
import MapKit
import CoreLocation
import LocalAuthentication
import _MapKit_SwiftUI

extension ContentView {
    @Observable
    class ViewModel {
        private(set) var locations: [Location]
        var selectedPlace: Location?
        var isUnlocked = true
        
        var mapType: Int = 0
        var selectedMapStyle: MapStyle {
            return switch(mapType) {
            case 0: .standard
            case 1: .hybrid
            case 2: .imagery
            default: .standard
            }
        }
        
        var isPresented: Bool = false
        var alertMessage = ""
        
        let savePath = URL.documentsDirectory.appending(path: "SavedPlaces")
        init() {
            do {
                let data = try Data(contentsOf: savePath)
                locations = try JSONDecoder().decode([Location].self, from: data)
            } catch {
                locations = []
            }
        }
        
        func save(completion: @escaping(_ msg: String) -> ()) {
            do {
                let data = try JSONEncoder().encode(locations)
                try data.write(to: savePath, options: [.atomic, .completeFileProtection])
                completion("")
            } catch {
                completion("Unable to save data.")
            }
        }
        
        func addLocation(at point: CLLocationCoordinate2D) -> String {
            var result = ""
            let newLocation = Location(id: UUID(), name: "New location", description: "", latitude: point.latitude, longitude: point.longitude)
            self.locations.append(newLocation)
            self.save { msg in
                result = msg
            }
            return result
        }
        
        func updateLocation(location: Location) -> String {
            guard let selectedPlace else { return "" }
            var result = ""
            
            if let index = locations.firstIndex(of: selectedPlace) {
                locations[index] = location
                self.save { msg in
                    result = msg
                }
            }
            return result
        }
        
        func authenticate() async -> String? {
            let context = LAContext()
            var error: NSError?
            var result: String?
            
            if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
                let reason = "Please authenticate yourself to unlock your places."
                
                context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { success, authenticationError in
                    if success {
                        self.isUnlocked = true
                    } else {
                        //error
                        result = authenticationError?.localizedDescription
                    }
                }
            } else {
                // no biometrics
                result = error?.localizedDescription
            }
            return result
        }
    }
}
