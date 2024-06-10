import Foundation
import SwiftUI
import MapKit

class BuildingAnnotation: NSObject, MKAnnotation {
    var coordinate: CLLocationCoordinate2D
    var title: String?
    var type: String
    var buildingID: String
    
    init(coordinate: CLLocationCoordinate2D, title: String, type: String, buildingID: String) {
        self.coordinate = coordinate
        self.title = title
        self.type = type
        self.buildingID = buildingID
    }
}

struct UIKitMapView: UIViewRepresentable {
    var buildings: [String: Building]
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
                let pair = determineIconTypeAndColor(type: buildingAnnotation.type)
                annotationView?.glyphImage = UIImage(systemName: pair.0)
                annotationView?.markerTintColor = pair.1
            }

            return annotationView
        }
        
        func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
            if let annotation = view.annotation as? BuildingAnnotation {
                parent.selectedBuilding = parent.buildings[annotation.buildingID]
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
        let annotations = buildings.values.map { building -> BuildingAnnotation in
            return BuildingAnnotation(coordinate: building.coordinates, title: building.name, type: building.type, buildingID: building.id)
        }
        map.addAnnotations(annotations)
        
        map.setRegion(MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 41.8708, longitude: -87.6505), span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)), animated: true)
        
        return map
    }

    func updateUIView(_ uiView: MKMapView, context: Context) {
        if selectedBuilding != nil {
            uiView.setRegion(MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: selectedBuilding!.coordinates.latitude - 0.0005, longitude: selectedBuilding!.coordinates.longitude), latitudinalMeters: 250, longitudinalMeters: 250), animated: true)
            if let annotation = uiView.annotations.first(where: {
                guard let buildingAnnotation = $0 as? BuildingAnnotation else {return false}
                return buildingAnnotation.buildingID == selectedBuilding!.id
            }) {
                uiView.selectAnnotation(annotation, animated: true)
            }
        } else {
            context.coordinator.deselectAnnotation(uiView)
        }
    }
}
