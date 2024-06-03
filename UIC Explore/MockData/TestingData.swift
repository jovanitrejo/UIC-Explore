//
//  TestingData.swift
//  UIC Explore
//  This file will hold testing data in order to play with our views accordingly
//  Created by Jovani Trejo on 6/1/24.
//

import Foundation
import MapKit

let testPlacesInBuilding = [Place(name: "Starbucks", description: "A Coffee Shop", buildingID: "438219472398", image: "arcstarbucks.jpg"),
                            Place(name: "Dunkin", description: "Another Coffeeshop", buildingID: "438219472398", image: "scedunkin.jpeg")
                            ]

let testBuilding = Building(id: "way/664275388", name: "Academic and Residential Complex", address: "940 West Harrison St", coordinates: CLLocationCoordinate2D(latitude: 41.8747701, longitude: -87.6511207), type: "Mixed-Use", image: "arcimage.jpg")

let testPlacesByCategory = [PlacesOrganizedByCategory(category: "Food", places: testPlacesInBuilding), PlacesOrganizedByCategory(category: "Housing", places: [Place(name: "Campus Housing", description: "People Live Here!", buildingID: "438219472398", image: "arcimage.jpg")])]
