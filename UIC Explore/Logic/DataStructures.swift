// This file holds all possible structs that will be used for UIC Explore

import Foundation
import CoreLocation
import SwiftSoup

// Used to act as a container that will hold all possible places
class Building: Decodable, Identifiable, Equatable {
    let id: String
    let name: String
    let address: String
    let coordinates: CLLocationCoordinate2D
    let type: String
    let image: String
    let description: String
    
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
        case description
    }
    
    enum GeometryKeys: String, CodingKey {
        case line
        case coordinates
    }
    
    init(id: String, name: String, address: String, coordinates: CLLocationCoordinate2D, type: String, image: String, description: String) {
        self.id = id
        self.name = name
        self.address = address
        self.coordinates = coordinates
        self.type = type
        self.image = image
        self.description = description
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
        description = try propertiesContainer.decode(String.self, forKey: .description)
        
        let geometryContainer = try container.nestedContainer(keyedBy: GeometryKeys.self, forKey: .geometry)
        var coordinatesArray: [[Double]] = []

        if let multiCoordinates = try? geometryContainer.decode([[[Double]]].self, forKey: .coordinates) {
            coordinatesArray = multiCoordinates.flatMap { $0 }
        } else if let singleCoordinates = try? geometryContainer.decode([[Double]].self, forKey: .coordinates) {
            coordinatesArray = singleCoordinates
        }

        
        let sumCoordinates = coordinatesArray.reduce(into: (latitude: 0.0, longitude: 0.0)) { (result, coordinate) in
            result.latitude += coordinate[1]
            result.longitude += coordinate[0]
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
    
    init(category: String, places: [Place]) {
        self.category = category
        self.places = places
    }
    
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
    var image: String
    var type: String
    
    init(name: String, description: String, buildingID: String, image: String, type: String) {
        self.name = name
        self.description = description
        self.buildingID = buildingID
        self.image = image
        self.type = type
    }
    
    enum CodingKeys: String, CodingKey {
        case name
        case description
        case buildingID
        case image
        case type
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.name = try container.decode(String.self, forKey: .name)
        self.description = try container.decode(String.self, forKey: .description)
        self.buildingID = try container.decode(String.self, forKey: .buildingID)
        self.image = try container.decode(String.self, forKey: .image)
        self.type = try container.decode(String.self, forKey: .type)
    }
}

struct NewsArticle {
    var title: String
    var link: String
    var pubDate: String
    var imageURL: String?
}

class RSSParser: NSObject, XMLParserDelegate {
    private var items: [NewsArticle] = []
    private var currentElement = ""
    private var currentTitle: String = ""
    private var currentLink: String = ""
    private var currentPubDate: String = ""
    private var currentFigureHTML: String = ""
    private var completion: (([NewsArticle]) -> Void)?

    func parse(data: Data, completion: @escaping ([NewsArticle]) -> Void) {
        self.completion = completion
        let parser = XMLParser(data: data)
        parser.delegate = self
        parser.parse()
    }

    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        currentElement = elementName
        if currentElement == "item" {
            currentTitle = ""
            currentLink = ""
            currentPubDate = ""
            currentFigureHTML = ""
        }
    }

    func parser(_ parser: XMLParser, foundCharacters string: String) {
        switch currentElement {
        case "title":
            currentTitle += string
        case "link":
            currentLink += string
            print(currentLink)
        case "pubDate":
            currentPubDate += string
        case "content:encoded":
            currentFigureHTML += string
        default:
            break
        }
    }

    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if elementName == "item" {
            let imageURL = extractImageURL(from: currentFigureHTML)
            let item = NewsArticle(title: currentTitle, link: currentLink, pubDate: currentPubDate, imageURL: imageURL)
            items.append(item)
        }
    }

    func parserDidEndDocument(_ parser: XMLParser) {
        completion?(items)
    }

    private func extractImageURL(from html: String) -> String? {
        do {
            let document = try SwiftSoup.parse(html)
            if let imgElement = try document.select("img").first() {
                return try imgElement.attr("src")
            }
        } catch {
            print("Failed to parse HTML: \(error)")
        }
        return nil
    }
}
