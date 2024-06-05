//
//  ContentView.swift
//  UIC Explore
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
    @State var buildings: [String: Building]? = nil {
        didSet {
            if selectedBuilding != nil {
                showSheet = true
                isViewingDetails = true
            }
        }
    }
    
    // Optional selectedBuilding based on if user taps on directoryItem or Marker
    @State var selectedBuilding: Building? = nil
    @State var selectedPlace: Place? = nil
    
    // Places organized by category
    @State var allPlacesOrganizedByCategory: [PlacesOrganizedByCategory]? = nil
    var body: some View {
        if isLoading {
            ProgressView()
                .onAppear(perform: {
                    loadDataSecurely()
                    configureTabBar()
                })
        } else {
            TabView(selection: $selectedTabView,
                    content:  {
                MapTabView(buildingsAsDict: buildings!, isSearching: $isSearching, selectedBuilding: $selectedBuilding).tabItem { Image(systemName: "map")
                    Text("Map")
                }.tag(1)
                if let buildings = buildings {
                    if let places = allPlacesOrganizedByCategory {
                        DirectoryTabView(allPlacesByCategory: places, allBuildings: buildings, selectedBuilding: $selectedBuilding, selectedPlace: $selectedPlace, selectedTab: $selectedTabView)
                            .tabItem {
                                Image(systemName: "mappin.circle")
                                Text("Directory")
                            }.tag(2)
                            
                    }
                }
                NewsTabView().tabItem {
                    Image(systemName: "newspaper")
                    Text("News")
                }.tag(3)
            })
            .onChange(of: isSearching, {
                if isSearching {
                    showSheet = true
                } else {
                    if !isSearching && selectedBuilding != nil {
                        isViewingDetails = true
                    }
                }
            })
            .onChange(of: selectedPlace == nil, {
                if selectedPlace != nil {
                    selectedBuilding = buildings![selectedPlace!.buildingID]
                    isViewingDetails = true
                }
            })
            .onChange(of: selectedBuilding, {
                if selectedBuilding != nil {
                    showSheet = true
                } else if selectedBuilding == nil && showSheet == true {
                    showSheet = false
                }
            })
            .onChange(of: showSheet, {
                if selectedBuilding != nil && showSheet {
                    isViewingDetails = true
                }
            })
            .sheet(isPresented: $showSheet, onDismiss: {
                selectedPlace = nil
                selectedBuilding = nil
                isViewingDetails = false
                isSearching = false
            }, content: {
                if selectedBuilding != nil {
                    if isViewingDetails {
                        if let nonOptionalBinding = selectedBuilding {
                            DetailsView(selectedBuilding: nonOptionalBinding, allPlaces: findPlacesInBuilding(allPlaces: allPlacesOrganizedByCategory!, buildingID: selectedBuilding!.id), selectedPlace: $selectedPlace)
                                .presentationDetents([.medium, .large])
                                .presentationBackgroundInteraction(.enabled(upThrough: .medium))
                        }
                    }
                } else {
                    SearchView(allBuildings: buildings!, allPlaces: allPlacesOrganizedByCategory!, selectedBuilding: $selectedBuilding, selectedPlace: $selectedPlace, isSearching: $isSearching)
                        .presentationBackgroundInteraction(.enabled(upThrough: .medium))
                }
            })
        }
    }
    func loadData() {
        // Loading building data...
        var loadedBuildings = false
        var loadedPlaces = false
        guard let url = Bundle.main.url(forResource: "uicBuildings", withExtension: "json") else {
            print("Failed to locate mockBuildings in bundle.")
            return
        }
                
        guard let placesURL = Bundle.main.url(forResource: "uicPlaces", withExtension: "json") else {
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
        
        print(loadedBuildings)
        print(loadedPlaces)
        
        if loadedPlaces && loadedBuildings {
            isLoading = false
        }
    }
    
    func loadDataSecurely() {
        var loadedBuildings = false
        var loadedPlaces = false
        
        let dispatchGroup = DispatchGroup()
        
        let buildingsURLString = getJSONURL(filename: "uicBuildings.json")
        guard let buildingsURL = URL(string: buildingsURLString) else {
            print("Invalid Buildings URL")
            return
        }
        
        let placesURLString = getJSONURL(filename: "uicPlaces.json")
        guard let placesURL = URL(string: placesURLString) else {
            print("Invalid Buildings URL")
            return
        }
        
        dispatchGroup.enter()
        URLSession.shared.dataTask(with: buildingsURL) { data, response, error in
            defer { dispatchGroup.leave() }
            
            if let error = error {
                print("Error fetching buildings JSON: \(error)")
                return
            }
            
            guard let data = data else {
                print("No data received for buildings")
                return
            }
            
            buildings = loadBuildingsJSON(data: data)
            if buildings != nil {
                loadedBuildings = true
            }
        }.resume()
        
        dispatchGroup.enter()
        URLSession.shared.dataTask(with: placesURL) { data, response, error in
            defer { dispatchGroup.leave() }
            
            if let error = error {
                print("Error fetching places JSON: \(error)")
                return
            }
            
            guard let data = data else {
                print("No data received for places")
                return
            }
            
            allPlacesOrganizedByCategory = loadPlacesByCategoryJSON(data: data)
            if allPlacesOrganizedByCategory != nil {
                loadedPlaces = true
            }
        }.resume()
        
        dispatchGroup.notify(queue: .main) {
            print(loadedBuildings)
            print(loadedPlaces)
            
            if loadedPlaces && loadedBuildings {
                isLoading = false
                print("Data loading complete")
            }
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
