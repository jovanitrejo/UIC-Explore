// This file holds all possible structs that will be used for UIC Explore

import Foundation
import CoreLocation

// Used to act as a container that will hold all possible places
class Building: Decodable, Identifiable, Equatable {
    let id: String
    let name: String
    let address: String
    let coordinates: CLLocationCoordinate2D
    let type: String
    let image: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case properties
        case geometry
    }
    
    enum PropertyKeys: String, CodingKey {
        case name
        case houseNumber = "addr:housenumber"
        case street = "addr:street"
        case type
        case image
    }
    
    enum GeometryKeys: String, CodingKey {
        case coordinates
    }
    
    init(id: String, name: String, address: String, coordinates: CLLocationCoordinate2D, type: String, image: String) {
        self.id = id
        self.name = name
        self.address = address
        self.coordinates = coordinates
        self.type = type
        self.image = image
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        
        let propertiesContainer = try container.nestedContainer(keyedBy: PropertyKeys.self, forKey: .properties)
        name = try propertiesContainer.decode(String.self, forKey: .name)
        let houseNumber = try propertiesContainer.decodeIfPresent(String.self, forKey: .houseNumber) ?? ""
        let street = try propertiesContainer.decodeIfPresent(String.self, forKey: .street) ?? ""
        address = "\(houseNumber) \(street)\nChicago, IL"
        type = try propertiesContainer.decode(String.self, forKey: .type)
        image = try propertiesContainer.decode(String.self, forKey: .image)
        
        let geometryContainer = try container.nestedContainer(keyedBy: GeometryKeys.self, forKey: .geometry)
        let coordinatesArray = try geometryContainer.decode([[[Double]]].self, forKey: .coordinates).flatMap { $0 }
        
        let sumCoordinates = coordinatesArray.reduce((latitude: 0.0, longitude: 0.0)) { (result, coordinate) -> (latitude: Double, longitude: Double) in
            return (latitude: result.latitude + coordinate[1], longitude: result.longitude + coordinate[0])
        }
        
        let centroidLatitude = sumCoordinates.latitude / Double(coordinatesArray.count)
        let centroidLongitude = sumCoordinates.longitude / Double(coordinatesArray.count)
        coordinates = CLLocationCoordinate2D(latitude: centroidLatitude, longitude: centroidLongitude)
    }
    
    static func == (lhs: Building, rhs: Building) -> Bool {
        return lhs.id == rhs.id &&
                lhs.name == rhs.name &&
                lhs.address == rhs.address &&
                lhs.coordinates.latitude == rhs.coordinates.latitude &&
                lhs.coordinates.longitude == rhs.coordinates.longitude &&
                lhs.type == rhs.type
    }
}

class PlacesOrganizedByCategory: Decodable, Identifiable {
    var id: UUID = UUID()
    var category: String
    var places: [Place]
    
    enum CodingKeys: String, CodingKey {
        case category
        case places
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.category = try container.decode(String.self, forKey: .category)
        self.places = try container.decode([Place].self, forKey: .places)
    }
}

class Place: Decodable, Identifiable {
    var id: UUID = UUID()
    var name: String
    var description: String
    var buildingID: String
    
    init(name: String, description: String, buildingID: String) {
        self.name = name
        self.description = description
        self.buildingID = buildingID
    }
    
    enum CodingKeys: String, CodingKey {
        case name
        case description
        case buildingID
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.name = try container.decode(String.self, forKey: .name)
        self.description = try container.decode(String.self, forKey: .description)
        self.buildingID = try container.decode(String.self, forKey: .buildingID)
    }
}
