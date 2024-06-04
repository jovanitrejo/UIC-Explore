//
//  DetailsView.swift
//  UIC Explore
//
//  Created by Jovani Trejo on 6/1/24.
//

import SwiftUI

struct DetailsView: View {
    var selectedBuilding: Building
    var imageURLBucket = "https://uiinfo-public-data-bucket.s3.amazonaws.com/UICImages/"
    var allPlaces: [PlacesOrganizedByCategory]? // Will be used if building was searched for or tapped on
    @Binding var selectedPlace: Place?
    
    var body: some View {
        ScrollViewReader { scrollViewProxy in
            ScrollView(showsIndicators: false) {
                VStack {
                    VStack {
                        HStack {
                            VStack {
                                HStack {
                                    Text(selectedPlace != nil ? selectedPlace!.name : selectedBuilding.name)
                                        .font(.title)
                                    Spacer()
                                }
                                HStack {
                                    Text(selectedPlace != nil ? "at \(selectedBuilding.name)" : selectedBuilding.address)
                                        .font(.footnote)
                                    Spacer()
                                }
                            }
                        }
                        Spacer()
                        AsyncImage(url: URL(string: imageURLBucket + (selectedPlace != nil ? selectedPlace!.image : selectedBuilding.image)), content: { image in
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
                        .padding(.bottom)
                        VStack {
                            HStack {
                                Text("About")
                                    .font(.title3)
                                    .fontWeight(.bold)
                                Spacer()
                            }
                            .frame(maxWidth: .infinity)
                            HStack {
                                Text(selectedPlace != nil ? selectedPlace!.description : selectedBuilding.description)
                                Spacer()
                            }
                            .padding()
                            .background(Color(UIColor.systemBackground))
                            .cornerRadius(10)
                            .frame(maxWidth: .infinity)
                        }
                    }
                    .padding(.top)
                    if allPlaces != nil && !allPlaces!.isEmpty { // Building was selected
                        HStack {
                            Text(selectedPlace != nil ? "Other places in this building" : "Places in this building")
                                .font(.title3)
                                .fontWeight(.bold)
                            Spacer()
                        }
                        .padding(.top)
                        ForEach(allPlaces!) { category in
                            VStack {
                                HStack {
                                    if selectedPlace == nil {
                                        Text(category.category)
                                        Spacer()
                                    } else {
                                        if category.places.count == 1 && category.places.first!.name == selectedPlace!.name {
                                        } else {
                                            Text(category.category)
                                            Spacer()
                                        }
                                    }
                                }
                                ScrollView(.horizontal, showsIndicators: false, content: {
                                    LazyHStack {
                                        ForEach(Array(category.places.enumerated()), id: \.element.id) { index, place in
                                            if selectedPlace != nil && (selectedPlace!.name == place.name) {
                                                
                                            } else {
                                                Button(action: {
                                                    withAnimation {
                                                        selectedPlace = place
                                                        scrollViewProxy.scrollTo("top", anchor: .top)
                                                    }
                                                }, label: {
                                                    PlaceCardView(image: place.image, title: place.name)
                                                })
                                                .buttonStyle(PlainButtonStyle())
                                            }
                                        }
                                    }
                                })
                            }
                        }
                    }
                }
                .id("top")
            }
            .padding(.horizontal)
            .background(.regularMaterial)
            .transition(.slide)
        }
    }
}

#Preview {
    DetailsView(selectedBuilding: testBuilding, allPlaces: testPlacesByCategory, selectedPlace: .constant(nil))
}
