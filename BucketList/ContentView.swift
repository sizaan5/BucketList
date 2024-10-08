//
//  ContentView.swift
//  BucketList
//
//  Created by Izaan Saleem on 07/10/2024.
//

import SwiftUI

struct LoadingView: View {
    var body: some View {
        ZStack {
            LinearGradient(colors: [.yellow, .gray], startPoint: .topLeading, endPoint: .bottomTrailing)
            Text("Loading...")
                .font(.largeTitle)
        }
        .ignoresSafeArea()
    }
}

struct SuccessView: View {
    var body: some View {
        ZStack {
            LinearGradient(colors: [.green, .blue], startPoint: .topLeading, endPoint: .bottomTrailing)
            Text("Success!")
                .font(.largeTitle)
        }
        .ignoresSafeArea()
    }
}

struct FailedView: View {
    var body: some View {
        ZStack {
            LinearGradient(colors: [.red, .pink], startPoint: .topLeading, endPoint: .bottomTrailing)
            Text("Failed.")
                .font(.largeTitle)
        }
        .ignoresSafeArea()
    }
}

struct ContentView: View {
    enum LoadingState {
        case loading
        case success
        case failed
    }
    
    @State var loadingState: LoadingState = .success
    
    var body: some View {
        switch loadingState {
        case .loading:
            LoadingView()
        case .success:
            SuccessView()
        case .failed:
            FailedView()
        }
    }
}

#Preview {
    ContentView()
}
