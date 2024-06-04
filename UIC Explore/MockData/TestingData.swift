//
//  TestingData.swift
//  UIC Explore
//  This file will hold testing data in order to play with our views accordingly
//  Created by Jovani Trejo on 6/1/24.
//

import Foundation
import MapKit

let testPlacesInBuilding = [Place(name: "Starbucks", description: "A Coffee Shop", buildingID: "way/664275388", image: "arcstarbucks.jpg", type: "Food"),
                            Place(name: "Dunkin", description: "Another Coffeeshop", buildingID: "way/664275388", image: "scedunkin.jpeg", type: "Food")
                            ]
let testBuildingAsDict = ["way/664275388": Building(id: "way/664275388", name: "Academic and Residential Complex", address: "940 West Harrison St", coordinates: CLLocationCoordinate2D(latitude: 41.8747701, longitude: -87.6511207), type: "Mixed-Use", image: "arcimage.jpg", description: "Offering private room or shared (2-person) bedrooms in traditional and semi-suite style accommodations, this residence hall is connected to advanced integrated multimedia lectern classrooms. Within the residential component, approximately 16,000 square feet features a fitness center, multiple social and/or gaming lounges, study lounges on each floor, laundry facilities, offices, and a tenth-floor sky lounge. The Academic & Residential Complex is LEED Gold certified by the US Green Building Council. Traditional units share community bathrooms and semi-suite style units provide an in-unit bathroom. Conveniently located near Student Center East, Taylor Street restaurants, and all east campus resources.")]

let testBuilding = Building(id: "way/664275388", name: "Academic and Residential Complex", address: "940 West Harrison St", coordinates: CLLocationCoordinate2D(latitude: 41.8747701, longitude: -87.6511207), type: "Mixed-Use", image: "arcimage.jpg", description: "Offering private room or shared (2-person) bedrooms in traditional and semi-suite style accommodations, this residence hall is connected to advanced integrated multimedia lectern classrooms. Within the residential component, approximately 16,000 square feet features a fitness center, multiple social and/or gaming lounges, study lounges on each floor, laundry facilities, offices, and a tenth-floor sky lounge. The Academic & Residential Complex is LEED Gold certified by the US Green Building Council. Traditional units share community bathrooms and semi-suite style units provide an in-unit bathroom. Conveniently located near Student Center East, Taylor Street restaurants, and all east campus resources.")

let testPlacesByCategory = [PlacesOrganizedByCategory(category: "Food", places: testPlacesInBuilding), PlacesOrganizedByCategory(category: "Housing", places: [Place(name: "Campus Housing", description: "People Live Here!", buildingID: "way/664275388", image: "arcimage.jpg", type: "Housing")])]
