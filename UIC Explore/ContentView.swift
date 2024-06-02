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
    @State var isLoading = true
    // All building data loaded from JSON
    @State var buildings: [String: Building]? = nil
    
    // Optional selectedBuilding based on if user taps on directoryItem or Marker
    @State var selectedBuilding: Building? = nil
    
    // Places organized by category
    @State var allPlacesOrganizedByCategory: [PlacesOrganizedByCategory]? = nil
    var body: some View {
        if isLoading {
            ProgressView()
                .onAppear(perform: {
                    loadData()
                    configureTabBar()
                })
        } else {
            TabView(selection: $selectedTabView,
                    content:  {
                MapTabView(buildingsAsDict: buildings!, isSearching: $isSearching, selectedBuilding: $selectedBuilding).tabItem { Image(systemName: "map")
                    Text("Map")
                }.tag(1)
                Text("Directory Under Construction").tabItem {
                    Image(systemName: "mappin.circle")
                    Text("Directory")
                }.tag(2)
                Text("News Under Construction").tabItem {
                    Image(systemName: "newspaper")
                    Text("News")
                }
            })
            .onChange(of: selectedBuilding, {
                if selectedBuilding != nil {
                    showSheet = true
                }
            })
            .sheet(isPresented: $showSheet, onDismiss: {
                selectedBuilding = nil
            }, content: {
                if isViewingDetails {
                    //DetailsView()
                } else if isSearching {
                    //SearchView()
                }
            })
        }
    }
    func loadData() {
        // Loading building data...
        var loadedBuildings = false
        var loadedPlaces = false
        guard let url = Bundle.main.url(forResource: "mockBuildings", withExtension: "json") else {
            print("Failed to locate mockBuildings in bundle.")
            return
        }
                
        guard let placesURL = Bundle.main.url(forResource: "mockPlacesByCategory", withExtension: "json") else {
            print("Failed to locate mockPlacesByCategory in bundle.")
            return
        }
        
        do {
            let data = try Data(contentsOf: url)
            buildings = loadBuildingsJSON(data: data)
            if buildings != nil {
                loadedBuildings = true
            }
        } catch {
            print("Failed to load and decode buildings.json: \(error)")
        }
        
        do {
            let placesData = try Data(contentsOf: placesURL)
            allPlacesOrganizedByCategory = loadPlacesByCategoryJSON(data: placesData)
            if allPlacesOrganizedByCategory != nil {
                loadedPlaces = true
            }
        } catch {
            print("Failed to load and decode placesByCategory.json: \(error)")
        }
        
        if loadedPlaces && loadedBuildings {
            isLoading = false
        }
    }
    
    func configureTabBar() -> Void {
        let appearance = UITabBarAppearance()
        appearance.configureWithDefaultBackground()
        if #available(iOS 15.0, *) {
            UITabBar.appearance().scrollEdgeAppearance = appearance
            UITabBar.appearance().standardAppearance = appearance
        }
    }
}

#Preview {
    ContentView()
}
