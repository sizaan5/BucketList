//
//  ContentView.swift
//  BucketList
//
//  Created by Izaan Saleem on 07/10/2024.
//

import SwiftUI
import MapKit

struct ContentView: View {
    let startPosition = MapCameraPosition.region(MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 30.3753, longitude: 69.3451), span: MKCoordinateSpan(latitudeDelta: 10, longitudeDelta: 10)))
    
    @State private var viewModel = ViewModel()
    
    var body: some View {
        ZStack {
            LinearGradient(colors: [.blue, .cyan], startPoint: .topLeading, endPoint: .topTrailing)
                .ignoresSafeArea()
            if viewModel.isUnlocked {
                MapReader { proxy in
                    Picker("", selection: $viewModel.mapType) {
                        Text("Standard").tag(0)
                        Text("Hybrid").tag(1)
                        Text("Satellite").tag(2)
                    }
                    .pickerStyle(.segmented)
                    .padding(EdgeInsets(top: 12, leading: 12, bottom: 0, trailing: 12))
                    
                    Map(initialPosition: startPosition) {
                        ForEach(viewModel.locations) { location in
                            Annotation(location.name, coordinate: location.coordinate) {
                                Image(systemName: "star.circle")
                                    .resizable()
                                    .foregroundStyle(.red)
                                    .frame(width: 24, height: 24)
                                    .background(.white)
                                    .clipShape(.circle)
                                    .onLongPressGesture {
                                        viewModel.selectedPlace = location
                                    }
                            }
                        }
                    }
                    .mapStyle(viewModel.selectedMapStyle)
                    .clipShape(.rect(cornerRadius: 20))
                    .shadow(radius: 20)
                    .padding()
                    .onTapGesture { position in
                        if let coordinate = proxy.convert(position, from: .local) {
                            viewModel.alertMessage = self.viewModel.addLocation(at: coordinate)
                            if viewModel.alertMessage != "" {
                                viewModel.isPresented = true
                            }
                        }
                    }
                    .sheet(item: $viewModel.selectedPlace) { place in
                        EditView(location: place) { newLocation in
                            viewModel.alertMessage = self.viewModel.updateLocation(location: newLocation)
                            if viewModel.alertMessage != "" {
                                viewModel.isPresented = true
                            }
                        }
                    }
                    .alert("Oops!!!", isPresented: $viewModel.isPresented) {
                        //
                    } message: {
                        Text(viewModel.alertMessage)
                    }
                }
            } else {
                Button() {
                    Task {
                        if let authenticationResult = await viewModel.authenticate() {
                            viewModel.alertMessage = authenticationResult
                            viewModel.isPresented = true
                        }
                    }
                } label: {
                    Text("Unlock Place")
                }
                .padding()
                .background(.black)
                .foregroundStyle(.white)
                .clipShape(.capsule)
            }
        }
    }
}

#Preview {
    ContentView()
}
