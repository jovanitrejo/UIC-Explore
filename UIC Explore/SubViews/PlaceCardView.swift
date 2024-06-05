//
//  PlaceCardView.swift
//  UIC Explore
//
//  Created by Jovani Trejo on 6/2/24.
//

import SwiftUI
import Foundation

struct PlaceCardView: View {
    var image: String
    var title: String
    var imageURLBucket = "https://d27l1b6hp7elrj.cloudfront.net/UICImages/"
    var body: some View {
        VStack(content: {
            AsyncImage(url: URL(string: imageURLBucket + image), content: { image in
                Rectangle()
                    .aspectRatio(1, contentMode: .fill)
                    .overlay(content: {
                        image
                            .resizable()
                            .scaledToFill()
                    })
                    .frame(width: 200, height: 200)
                    
            }, placeholder: {
                ProgressView()
                    .frame(width: 200, height: 200)
            })
            HStack(alignment: .center, content: {
                Text(title)
                    .padding([.horizontal, .bottom], 5)
                Spacer()
            })
        })
        .frame(width: 200, height: 235)
        .background(Color(UIColor.systemBackground))
        .cornerRadius(5)
    }
}

#Preview {
    PlaceCardView(image: testPlacesInBuilding.first!.image, title: testPlacesInBuilding.first!.name)
}
