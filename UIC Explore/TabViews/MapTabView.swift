//
//  MapTabView.swift
//  UIC Expore
//  This section represents the entire map tab for UIC Expore.
//  Created by Jovani Trejo on 6/1/24.
//

import SwiftUI

struct MapTabView: View {
    @Binding var isSearching: Bool
    @Binding var selectedBuilding: Building?
    var buildingsAsDict: [String: Building]
    init(buildingsAsDict: [String: Building], isSearching: Binding<Bool>, selectedBuilding: Binding<Building?>) {
        self.buildingsAsDict = buildingsAsDict
        self._isSearching = isSearching
        self._selectedBuilding = selectedBuilding
    }
    var body: some View {
        ZStack {
            UIKitMapView(buildings: buildingsAsDict, selectedBuilding: $selectedBuilding)
                .ignoresSafeArea()
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    Button(action: {
                        isSearching = true
                    }, label: {
                        UIButtonView(image: Image(systemName: "magnifyingglass"), text: "Search")
                    })
                    .buttonStyle(PlainButtonStyle())
                }
                .padding(.trailing)
            }
            .padding(.bottom)
        }
    }
}
