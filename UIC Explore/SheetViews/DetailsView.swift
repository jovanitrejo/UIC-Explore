//
//  DetailsView.swift
//  UIC Explore
//
//  Created by Jovani Trejo on 6/1/24.
//

import SwiftUI

struct DetailsView: View {
    //@Binding var selectedBuilding: Building
    var allPlaces: [PlacesOrganizedByCategory]? // Will be used if building was searched for or tapped on
    var similarPlaces: [Place]? // Will be used if place was searched for
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

#Preview {
    DetailsView()
}
