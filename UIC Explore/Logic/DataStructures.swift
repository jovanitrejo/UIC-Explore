//
//  DataStructures.swift
//  UIC Expore
//
//  Created by Jovani Trejo on 6/1/24.
//

import Foundation
import MapKit

class Building: Decodable, Identifiable {
    internal let id: String
    private let name: String
    private let description: String
    private let coordinates: CLLocationCoordinate2D
    private let address: String
    
    init(id: String, name: String, description: String, coordinates: CLLocationCoordinate2D, address: String) {
        self.id = id
        self.name = name
        self.description = description
        self.coordinates = coordinates
        self.address = address
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case properties
        case geometry
    }
    
    enum PropertyKeys: String, CodingKey {
        case name
        case description
        case houseNumber = "addr:housenumber"
        case street  = "addr:street"
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        let propertiesContainer = try container.nestedContainer(keyedBy: PropertyKeys.self, forKey: .properties)
        name = try propertiesContainer.decode(String.self, forKey: .name)
        description = try propertiesContainer.decode(String.self, forKey: .description)
        let houseNumber = try propertiesContainer.decode(String.self, forKey: .houseNumber)
        let streetName = try propertiesContainer.decode(String.self, forKey: .street)
        address = houseNumber + " " + streetName + "\nChicago, IL"
        let way = try container.decode([[[Double]]].self, forKey: .geometry)
        
        let flatCoordinates = way.flatMap { $0 }

        var sumLatitude: CLLocationDegrees = 0
        var sumLongitude: CLLocationDegrees = 0

        for coordinate in flatCoordinates {
            sumLatitude += coordinate[1]
            sumLongitude += coordinate[0]
        }

        let centroidLatitude = sumLatitude / Double(flatCoordinates.count)
        let centroidLongitude = sumLongitude / Double(flatCoordinates.count)

        coordinates = CLLocationCoordinate2D(latitude: centroidLatitude, longitude: centroidLongitude)
    }
}
