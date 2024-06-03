//
//  Functions.swift
//  UIC Expore
//  This file handles all the functions for loading data from JSON and GeoJSON
//  Created by Jovani Trejo on 6/1/24.
//

import Foundation

func loadBuildingsJSON(data: Data) -> [String: Building]? {
    let decoder = JSONDecoder()
    do {
        let buildings = try decoder.decode([Building].self, from: data)
        let buildingsDict = Dictionary(uniqueKeysWithValues: buildings.map { ($0.id, $0) })
        return buildingsDict
    } catch {
        print("Error decoding JSON: \(error)")
        return nil
    }
}

func loadPlacesByCategoryJSON(data: Data) -> [PlacesOrganizedByCategory]? {
    let decoder = JSONDecoder()
    do {
        let placesByCategory = try decoder.decode([PlacesOrganizedByCategory].self, from: data)
        return placesByCategory
    } catch {
        return nil
    }
}

// Finds all places in building and will return organized by category
func findPlacesInBuilding(allPlaces: [PlacesOrganizedByCategory], buildingID: String) -> [PlacesOrganizedByCategory] {
    var placesInBuilding: [PlacesOrganizedByCategory] = []
    
    for category in allPlaces {
        var placesForOneCategory: [Place] = []
        for place in category.places {
            if place.buildingID == buildingID {
                placesForOneCategory.append(place)
            }
        }
        if !placesForOneCategory.isEmpty {
            placesInBuilding.append(PlacesOrganizedByCategory(category: category.category, places: placesForOneCategory))
        }
    }
    
    return placesInBuilding
}
