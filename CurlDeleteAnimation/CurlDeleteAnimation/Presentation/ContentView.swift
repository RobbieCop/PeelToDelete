//
//  ContentView.swift
//  CurlDeleteAnimation
//
//  Created by Rob Copping on 02/05/2023.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationStack {
            HomeView()
                .navigationTitle("Peel Effect")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
