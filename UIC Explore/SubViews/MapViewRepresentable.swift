import Foundation
import SwiftUI
import MapKit

class BuildingAnnotation: NSObject, MKAnnotation {
    var coordinate: CLLocationCoordinate2D
    var title: String?
    var type: String
    var buildingData: Building
    
    init(coordinate: CLLocationCoordinate2D, title: String, type: String, buildingData: Building) {
        self.coordinate = coordinate
        self.title = title
        self.type = type
        self.buildingData = buildingData
    }
}

struct UIKitMapView: UIViewRepresentable {
    var buildings: [Building]
    @Binding var selectedBuilding: Building?
    class Coordinator: NSObject, MKMapViewDelegate {
        var parent: UIKitMapView

        init(parent: UIKitMapView) {
            self.parent = parent
        }

        func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
            if annotation is MKUserLocation {
                return nil
            }

            let identifier = "BuildingAnnotation"
            var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKMarkerAnnotationView

            if annotationView == nil {
                annotationView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            } else {
                annotationView?.annotation = annotation
            }

            // Customize the pin color based on the building type
            if let buildingAnnotation = annotation as? BuildingAnnotation {
                switch buildingAnnotation.type {
                case "housing":
                    annotationView?.markerTintColor = .systemBlue
                case "type2":
                    annotationView?.markerTintColor = .green
                default:
                    annotationView?.markerTintColor = .red
                }
            }

            return annotationView
        }
        
        func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
            if let annotation = view.annotation as? BuildingAnnotation {
                parent.selectedBuilding = annotation.buildingData
            }
        }
        
        func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView) {
            parent.selectedBuilding = nil
        }
        
        func deselectAnnotation(_ mapView: MKMapView) {
            mapView.selectedAnnotations.forEach { mapView.deselectAnnotation($0, animated: true) }
        }
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }

    func makeUIView(context: Context) -> MKMapView {
        let map = MKMapView()
        map.pointOfInterestFilter = MKPointOfInterestFilter.excludingAll
        map.delegate = context.coordinator

        // Add custom annotations
        let annotations = buildings.map { building -> BuildingAnnotation in
            return BuildingAnnotation(coordinate: building.coordinates, title: building.name, type: building.type, buildingData: building)
        }
        map.addAnnotations(annotations)
        
        map.setRegion(MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 41.87082, longitude: -87.65919), span: MKCoordinateSpan(latitudeDelta: 0.03, longitudeDelta: 0.03)), animated: true)
        
        return map
    }

    func updateUIView(_ uiView: MKMapView, context: Context) {
        if selectedBuilding != nil {
            uiView.setRegion(MKCoordinateRegion(center: selectedBuilding!.coordinates, latitudinalMeters: 500, longitudinalMeters: 500), animated: true)
        } else {
            context.coordinator.deselectAnnotation(uiView)
        }
    }
}
