//
//  ContentView.swift
//  UIC Expore
//
//  Created by Jovani Trejo on 6/1/24.
//

import SwiftUI

struct ContentView: View {
    @State var showSheet = false
    @State var isSearching = false
    @State var isViewingDetails = false
    @State var selectedTabView = 1
    var body: some View {
        TabView(selection: $selectedTabView,
                content:  {
            Text("Tab Content 1").tabItem { Image(systemName: "map")
                Text("Map")
            }.tag(1)
            Text("Tab Content 2").tabItem {
                Image(systemName: "mappin.circle")
                Text("Directory")
            }.tag(2)
            Text("Tab Content 3").tabItem {
                Image(systemName: "newspaper")
                Text("News")
            }
        })
    }
}

#Preview {
    ContentView()
}
