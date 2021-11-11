//
//  ContentView.swift
//  Omega
//
//  Created by Gavin Marler on 11/5/21.
//

import SwiftUI

struct ContentView: View {
    var samples = Samples()
    
    var body: some View {
        TabView(){
            SamplesView(filter: .new)
                .tabItem {
                    Image(systemName: "plus.circle")
                    Text("New Sample")
                }
            
            SamplesView(filter: .open)
                .tabItem {
                    Image(systemName: "pencil.circle")
                    Text("Open Samples")
                }
            
            SamplesView(filter: .complete)
                .tabItem {
                    Image(systemName: "book.circle")
                    Text("Sample History")
                }
        }
        .environmentObject(samples)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
