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
        let buildingsDict = Dictionary(uniqueKeysWithValues: buildings.map {($0.id, $0)} )
        return buildingsDict
    } catch {
        return nil
    }
}
