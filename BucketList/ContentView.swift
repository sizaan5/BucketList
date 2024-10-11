//
//  ContentView.swift
//  BucketList
//
//  Created by Izaan Saleem on 07/10/2024.
//

import SwiftUI
import MapKit
import LocalAuthentication

struct ContentView: View {
    let startPosition = MapCameraPosition.region(MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 30.3753, longitude: 69.3451), span: MKCoordinateSpan(latitudeDelta: 10, longitudeDelta: 10)))
    
    @State private var locations: [Location] = []
    @State private var selectedPlace: Location?
    
    var body: some View {
        MapReader { proxy in
            Map(initialPosition: startPosition) {
                ForEach(locations) { location in
                    Annotation(location.name, coordinate: location.coordinate) {
                        Image(systemName: "star.circle")
                            .resizable()
                            .foregroundStyle(.red)
                            .frame(width: 24, height: 24)
                            .background(.white)
                            .clipShape(.circle)
                            .onTapGesture {
                                selectedPlace = location
                            }
                    }
                }
            }
            .onTapGesture { position in
                if let coordinate = proxy.convert(position, from: .local) {
                    let newLocation = Location(id: UUID(), name: "New location", description: "", latitude: coordinate.latitude, longitude: coordinate.longitude)
                    locations.append(newLocation)
                }
            }
            .sheet(item: $selectedPlace) { place in
                EditView(location: place) { newLocation in
                    if let index = locations.firstIndex(of: place) {
                        locations[index] = newLocation
                    }
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
