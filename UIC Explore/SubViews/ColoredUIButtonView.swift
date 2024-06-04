//
//  ColoredUIButtonView.swift
//  UIC Explore
//
//  Created by Jovani Trejo on 6/3/24.
//

import SwiftUI

struct ColoredUIButtonView: View {
    let color: Color
    let text: String
    var body: some View {
        Text(text)
            .frame(maxWidth: .infinity)
            .padding(.vertical)
            .background(color)
            .foregroundColor(Color(UIColor.systemBackground))
            .cornerRadius(10)
    }
}

#Preview {
    ColoredUIButtonView(color: Color.blue, text: "Open in Maps")
}
