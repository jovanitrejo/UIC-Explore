//
//  MapTabView.swift
//  UIC Expore
//  This section represents the entire map tab for UIC Expore.
//  Created by Jovani Trejo on 6/1/24.
//

import SwiftUI

struct MapTabView: View {
    @Binding var isSearching: Bool
    @State var Buildings = [String: Building]? = nil
    var body: some View {
        ZStack {
            UIKitMapView()
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

#Preview {
    MapTabView(isSearching: .constant(false))
}
