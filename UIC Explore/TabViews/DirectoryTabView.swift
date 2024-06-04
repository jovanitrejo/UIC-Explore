//
//  DirectoryTabView.swift
//  UIC Explore
//
//  Created by Jovani Trejo on 6/3/24.
//

import SwiftUI

struct DirectoryTabView: View {
    var allPlacesByCategory: [PlacesOrganizedByCategory]
    var allBuildings: [String: Building]
    @Binding var selectedBuilding: Building?
    @Binding var selectedPlace: Place?
    @Binding var selectedTab: Int
    var body: some View {
        VStack(content: {
            ScrollView(content: {
                VStack(content: {
                    HStack {
                        Text("Points of Interests")
                            .font(.title)
                        Spacer()
                    }
                    .padding(.all)
                    HStack {
                        Text("Buildings")
                            .font(.headline)
                            .padding(.leading)
                        Spacer()
                    }
                    ScrollView(.horizontal, content: {
                        LazyHStack(content: {
                            ForEach(Array(allBuildings.values.enumerated()), id: \.element.id) { index, building in
                                Button(action: {
                                    selectedBuilding = building
                                    selectedTab = 1
                                }, label: {
                                    PlaceCardView(image: building.image, title: building.name)
                                        .padding(.leading, index == 0 ? 16 : 0)
                                        .padding(.trailing, index == allBuildings.count - 1 ? 16 : 0)
                                })
                                .buttonStyle(PlainButtonStyle())
                            }
                        })
                    })
                    ForEach(allPlacesByCategory) { category in
                        HStack {
                            Text(category.category)
                                .font(.headline)
                                .padding(.leading)
                            Spacer()
                        }
                        ScrollView(.horizontal, showsIndicators: false, content: {
                            HStack(content: {
                                ForEach(Array(category.places.enumerated()), id: \.element.id) { index, place in
                                    Button(action: {
                                        selectedPlace = place
                                        selectedTab = 1
                                    }, label: {
                                        PlaceCardView(image: place.image, title: place.name)
                                            .padding(.leading, index == 0 ? 16 : 0)
                                            .padding(.trailing, index == category.places.count - 1 ? 16 : 0)
                                    })
                                    .buttonStyle(PlainButtonStyle())
                                }
                            })
                        })
                    }
                    Spacer()
                })
            })
        })
        .background(.thickMaterial)
    }
}

#Preview {
    DirectoryTabView(allPlacesByCategory: testPlacesByCategory, allBuildings: testBuildingAsDict, selectedBuilding: .constant(nil), selectedPlace: .constant(nil), selectedTab: .constant(2))
}
