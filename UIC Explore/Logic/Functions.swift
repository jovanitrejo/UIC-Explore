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

// Finds all places in a building. This function will be used when a building has been tapped on or searched for
func findPlacesInBuidling(buildingID: String, places: [Place]) -> [Place] {return places.filter {$0.buildingID == buildingID}}
