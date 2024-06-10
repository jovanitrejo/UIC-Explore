//
//  UIButtonView.swift
//  UIC Expore
//
//  Created by Jovani Trejo on 6/1/24.
//

import SwiftUI

struct UIButtonView: View {
    let image: Image
    let text: String
    var body: some View {
        HStack {
            image
            Text(text)
        }
        .padding(.horizontal, 20.0)
        .padding(.vertical, 5.0)
        .background(.regularMaterial)
        .cornerRadius(20)
        .foregroundStyle(Color(UIColor.systemGray))
    }
}

#Preview {
    UIButtonView(image: Image(systemName: "magnifyingglass"), text: "Search")
}
