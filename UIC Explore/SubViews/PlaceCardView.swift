//
//  PlaceCardView.swift
//  UIC Explore
//
//  Created by Jovani Trejo on 6/2/24.
//

import SwiftUI
import Foundation

struct PlaceCardView: View {
    var place: Place
    var imageURLBucket = "https://uiinfo-public-data-bucket.s3.amazonaws.com/UICImages/"
    var body: some View {
        VStack(content: {
            AsyncImage(url: URL(string: imageURLBucket + place.image), content: { image in
                Rectangle()
                    .aspectRatio(1, contentMode: .fill)
                    .overlay(content: {
                        image
                            .resizable()
                            .scaledToFill()
                    })
                    .frame(width: 200, height: 200)
                    .cornerRadius(10)
            }, placeholder: {
                ProgressView()
            })
            HStack {
                Text(place.name)
                Spacer()
            }
        })
        .frame(width: 200)
        .padding()
        .background(.regularMaterial)
        .cornerRadius(10)
    }
}

#Preview {
    PlaceCardView(place: testPlacesInBuilding[0])
}
