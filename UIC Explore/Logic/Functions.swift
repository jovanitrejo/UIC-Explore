//
//  Functions.swift
//  UIC Expore
//  This file handles all the functions for loading data from JSON and GeoJSON
//  Created by Jovani Trejo on 6/1/24.
//

import Foundation
import SwiftUI

// Takes in JSON data and decodes an array building classes
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

// Takes in JSON data and decodes an array of places organized by category
func loadPlacesByCategoryJSON(data: Data) -> [PlacesOrganizedByCategory]? {
    let decoder = JSONDecoder()
    do {
        let placesByCategory = try decoder.decode([PlacesOrganizedByCategory].self, from: data)
        return placesByCategory
    } catch {
        print("Error decoding JSON: \(error)")
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
    print("Function complete!")
    return placesInBuilding
}

// Uses a building or places type to generate an icon and color
func determineIconTypeAndColor(type: String) -> (String, UIColor) {
    switch(type) {
    case "academic":
        return ("graduationcap.circle.fill", UIColor.systemBrown)
    case "office":
        return ("building.2.crop.circle.fill", UIColor.systemBrown)
    case "food":
        return ("fork.knife.circle.fill", UIColor.systemOrange)
    case "housing":
        return ("house.circle.fill", UIColor.systemBlue)
    case "recreation":
        return ("figure.run.circle.fill", UIColor.systemTeal)
    case "research":
        return ("apple.terminal.circle.fill", UIColor.systemGreen)
    case "medical":
        return ("cross.case.circle.fill", UIColor.systemRed)
    case "mixed-use":
        return ("house.lodge.circle.fill", UIColor.systemMint)
    case "cultural center":
        return ("person.2.circle", UIColor.systemPink)
    case "student service":
        return ("paperclip.circle.fill", UIColor.systemIndigo)
    case "study lounge":
        return("pencil.circle.fill", UIColor.systemCyan)
    case "lounge":
        return("pencil.circle.fill", UIColor.systemCyan)
    case "retail":
        return("handbag.circle.fill", UIColor.systemOrange)
    case "banking":
        return("dollarsign.circle.fill", UIColor.systemGreen)
    case "clothing":
        return("tshirt.circle.fill", UIColor.systemYellow)
    case "library":
        return("book.circle.fill", UIColor.systemBrown)
    case "police":
        return("smallcircle.fill.circle.fill", UIColor.systemBlue)
    default:
        return ("questionmark.circle.fill", UIColor.systemGray)
    }
}

// Pulls news articles from RSS feed based on selectedFilter
func fetchUICToday(filter: String, completion: @escaping (Result<Data, Error>) -> Void) {
    var uicNewsURL: String
    switch(filter) {
    case "Campus News":
        uicNewsURL = "https://today.uic.edu/uicnews/section/uic-news/feed"
    case "Academic and Research":
        uicNewsURL = "https://today.uic.edu/news-release/news-release/feed"
    case "Official Communications":
        uicNewsURL = "https://today.uic.edu/category/official/feed"
    case "Announcements":
        uicNewsURL = "https://today.uic.edu/category/announcements/feed"
    case "Events":
        uicNewsURL = "https://today.uic.edu/events/feed"
    default:
        uicNewsURL = "https://today.uic.edu/feed"
    }
    
    guard let url = URL(string: uicNewsURL) else {
        completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])))
        return
    }
    
    URLSession.shared.dataTask(with: url) { data, response, error in
        if let error = error {
            completion(.failure(error))
        } else if let data = data {
            completion(.success(data))
        }
    }.resume()
}

// Formats date to EEE, dd MMM yyyy
func formatDate(dateString: String) -> String {
    let inputFormatter = DateFormatter()
    inputFormatter.dateFormat = "EEE, dd MMM yyyy HH:mm:ss Z"
    inputFormatter.locale = Locale(identifier: "en_US_POSIX")

    // Trim whitespace and newlines
    let trimmedDateString = dateString.trimmingCharacters(in: .whitespacesAndNewlines)

    if let date = inputFormatter.date(from: trimmedDateString) {
        let outputFormatter = DateFormatter()
        outputFormatter.dateFormat = "EEE, dd MMM yyyy"
        return outputFormatter.string(from: date)
    } else {
        print("Date formatting failed for: '\(trimmedDateString)'")
        return dateString
    }
}
