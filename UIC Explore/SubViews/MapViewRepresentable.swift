//
//  MapViewRepresentable.swift
//  UIC Expore
//
//  Created by Jovani Trejo on 6/1/24.
//

import Foundation
import SwiftUI
import MapKit

struct UIKitMapView: UIViewRepresentable {
    func makeUIView(context: Context) -> MKMapView {
        let map = MKMapView()
        return map
    }
    
    func updateUIView(_ uiView: MKMapView, context: Context) {
        
    }
}
