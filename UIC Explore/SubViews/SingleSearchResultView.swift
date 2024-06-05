//
//  SingleSearchResultView.swift
//  UIC Explore
//
//  Created by Jovani Trejo on 6/3/24.
//

import SwiftUI

struct SingleSearchResultView: View {
    var resultName: String
    var iconMaterial: (String, UIColor)
    var body: some View {
        HStack {
            Image(systemName: iconMaterial.0)
                .foregroundStyle(Color(iconMaterial.1))
            Spacer()
            Text(resultName)
                .multilineTextAlignment(.trailing)
        }
        .frame(height: 50)
        .padding(.horizontal, 30)
    }
}

#Preview {
    SingleSearchResultView(resultName: "The ARC", iconMaterial: determineIconTypeAndColor(type: "Housing"))
}
