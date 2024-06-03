//
//  DetailsView.swift
//  UIC Explore
//
//  Created by Jovani Trejo on 6/1/24.
//

import SwiftUI

struct DetailsView: View {
    @State var selectedBuilding: Building
    var imageURLBucket = "https://uiinfo-public-data-bucket.s3.amazonaws.com/UICImages/"
    var allPlaces: [PlacesOrganizedByCategory]? // Will be used if building was searched for or tapped on
    var similarPlaces: [Place]? // Will be used if place was searched for
    
    init?(selectedBuilding: Binding<Building?>, allPlaces: [PlacesOrganizedByCategory]? = nil, similarPlaces: [Place]? = nil) {
        guard let building = selectedBuilding.wrappedValue else {
            return nil
        }
        _selectedBuilding = State(initialValue: building)
        self.allPlaces = allPlaces
        self.similarPlaces = similarPlaces
    }
    
    var body: some View {
        ScrollView {
            VStack {
                VStack {
                    HStack {
                        VStack {
                            HStack {
                                Text(selectedBuilding.name)
                                    .font(.title)
                                Spacer()
                            }
                            HStack {
                                Text(selectedBuilding.address)
                                    .font(.footnote)
                                Spacer()
                            }
                        }
                    }
                    Spacer()
                    AsyncImage(url: URL(string: imageURLBucket + selectedBuilding.image), content: { image in
                        Rectangle()
                            .aspectRatio(1, contentMode: .fill)
                            .overlay(content: {
                                image
                                    .resizable()
                                    .scaledToFill()
                            })
                            .frame(maxWidth: .infinity)
                            .clipped()
                            .cornerRadius(5)
                    }, placeholder: {
                        ProgressView()
                    })
                }
                .padding([.top, .horizontal])
                if allPlaces != nil { // Building was selected
                    HStack {
                        Text("Places in this building")
                            .font(.title3)
                            .padding(.all)
                        Spacer()
                    }
                    ForEach(allPlaces!) { category in
                        VStack {
                            HStack {
                                Text(category.category)
                                    .padding(.horizontal)
                                Spacer()
                            }
                            ScrollView(.horizontal, showsIndicators: false, content: {
                                HStack {
                                    ForEach(Array(category.places.enumerated()), id: \.element.id) { index, place in
                                                PlaceCardView(place: place)
                                            .padding(.leading, index == 0 ? 16 : 0) // Add padding to the first element
                                            .padding(.trailing, index == category.places.count - 1 ? 16 : 0) // Add padding to the last element
                                    }
                                }
                            })
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    DetailsView(selectedBuilding: .constant(testBuilding), allPlaces: testPlacesByCategory)
}
