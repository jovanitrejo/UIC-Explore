//
//  DetailsView.swift
//  UIC Explore
//
//  Created by Jovani Trejo on 6/1/24.
//

import SwiftUI

struct DetailsView: View {
    @Binding var selectedBuilding: Building
    var imageURLBucket = "https://uiinfo-public-data-bucket.s3.amazonaws.com/UICImages/"
    var allPlaces: [PlacesOrganizedByCategory]? // Will be used if building was searched for or tapped on
    var similarPlaces: [Place]? // Will be used if place was searched for
    var body: some View {
        VStack {
            
        }
    }
}

#Preview {
    DetailsView(selectedBuilding: .constant(testBuilding))
}
