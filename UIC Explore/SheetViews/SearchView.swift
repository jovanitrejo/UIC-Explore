//
//  SearchView.swift
//  UIC Explore
//
//  Created by Jovani Trejo on 6/3/24.
//

import SwiftUI

struct SearchView: View {
    var allBuildings: [String: Building]
    var allPlaces: [PlacesOrganizedByCategory]
    @State private var searchText: String = ""
    @State private var filteredBuildings: [Building] = []
    @State private var filteredPlaces: [Place] = []
    @Binding var selectedBuilding: Building?
    @Binding var selectedPlace: Place?
    @Binding var isSearching: Bool
    var body: some View {
        VStack {
            TextField("Search", text: $searchText)
                .padding()
                .background(.regularMaterial)
                .cornerRadius(10)
                .frame(height: 80)
                .padding(.horizontal)
                .shadow(radius: 5)
            ScrollView(content: {
                ForEach(filteredBuildings, id: \.id) { building in
                    Button(action: {
                        selectedBuilding = building
                        isSearching = false
                    }, label: {
                        SingleSearchResultView(resultName: building.name, iconMaterial: determineIconTypeAndColor(type: building.type))
                    })
                    .buttonStyle(PlainButtonStyle())
                    Divider()
                }
                ForEach(filteredPlaces, id: \.id) { place in
                    Button(action: {
                        selectedPlace = place
                        isSearching = false
                    }, label: {
                        SingleSearchResultView(resultName: place.name, iconMaterial: determineIconTypeAndColor(type: place.type))
                    })
                    .buttonStyle(PlainButtonStyle())
                    Divider()
                }
            })
            Spacer()
        }
        .onAppear(perform: {
            filterResults()
        })
        .onChange(of: searchText, {
            filterResults()
        })
    }
    func filterResults() {
        if searchText.isEmpty {
            filteredBuildings = allBuildings.values.map {$0}
            filteredPlaces = allPlaces.flatMap({$0.places})
        } else {
            let lowercasedSearchText = searchText.lowercased()
            filteredBuildings = allBuildings.values.filter { $0.name.lowercased().contains(lowercasedSearchText) }
            filteredPlaces = allPlaces.flatMap {$0.places}.filter {$0.name.lowercased().contains(lowercasedSearchText)}
        }
    }
}

#Preview {
    SearchView(allBuildings: ["way/664275388": testBuilding], allPlaces: testPlacesByCategory, selectedBuilding: .constant(nil), selectedPlace: .constant(nil), isSearching: .constant(true))
}
