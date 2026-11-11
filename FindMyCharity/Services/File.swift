//
//  GlobalGivingService.swift
//  FindMyCharity
//

import Foundation
import CoreLocation

class GlobalGivingService {
    
    static let shared = GlobalGivingService()
    private(set) var cachedCharities: [Charity] = []
    
    private let apiKey = Secrets.globalGivingAPIKey
    private let baseURL = "https://api.globalgiving.org/api/public/projectservice"
    
    // File URL for cached data
    private var cacheFileURL: URL {
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        return documentsDirectory.appendingPathComponent("cached_charities.json")
    }
    
    // Country name to coordinates
    private let countryNameCoordinates: [String: (lat: Double, lon: Double, spread: Double)] = [
        "AF": (33.93, 67.71, 3.0),
        "AL": (41.15, 20.17, 0.5),
        "DZ": (28.03, 1.66, 3.0),
        "AR": (-38.42, -63.62, 4.0),
        "AU": (-25.27, 133.78, 5.0),
        "BD": (23.68, 90.35, 1.5),
        "BR": (-14.24, -51.93, 5.0),
        "KH": (12.57, 104.99, 1.5),
        "CM": (7.37, 12.35, 1.5),
        "CA": (56.13, -106.35, 5.0),
        "CF": (6.61, 20.94, 2.0),
        "TD": (15.45, 18.73, 3.0),
        "CL": (-35.68, -71.54, 3.0),
        "CN": (35.86, 104.20, 5.0),
        "CO": (4.57, -74.30, 2.0),
        "CD": (-4.04, 21.76, 3.0),
        "CR": (9.75, -83.75, 0.5),
        "EC": (-1.83, -78.18, 1.0),
        "EG": (26.82, 30.80, 2.0),
        "SV": (13.79, -88.90, 0.3),
        "ET": (9.15, 40.49, 2.5),
        "FR": (46.23, 2.21, 1.5),
        "DE": (51.17, 10.45, 1.0),
        "GH": (7.95, -1.02, 1.0),
        "GT": (15.78, -90.23, 0.8),
        "HT": (18.97, -72.29, 0.5),
        "HN": (15.20, -86.24, 0.8),
        "IN": (22.0, 79.0, 4.0),
        "ID": (-2.0, 118.0, 4.0),
        "IQ": (33.22, 43.68, 1.5),
        "IL": (31.05, 34.85, 0.3),
        "IT": (41.87, 12.57, 1.5),
        "JM": (18.11, -77.30, 0.3),
        "JP": (36.20, 138.25, 2.0),
        "JO": (30.59, 36.24, 0.5),
        "KE": (-1.0, 38.0, 3.0),
        "LR": (6.43, -9.43, 0.8),
        "MW": (-13.25, 34.30, 1.5),
        "MY": (4.21, 101.98, 2.0),
        "ML": (17.57, -4.00, 3.0),
        "MX": (23.63, -102.55, 4.0),
        "MA": (31.79, -7.09, 2.0),
        "MZ": (-18.67, 35.53, 2.5),
        "MM": (21.91, 95.96, 2.0),
        "NP": (28.39, 84.12, 1.0),
        "NI": (12.87, -85.21, 0.8),
        "NE": (17.61, 8.08, 2.5),
        "NG": (9.08, 8.68, 2.0),
        "PK": (30.38, 69.35, 2.5),
        "PS": (31.95, 35.23, 0.2),
        "PA": (8.54, -80.78, 0.5),
        "PY": (-23.44, -58.44, 1.5),
        "PE": (-9.19, -75.02, 3.0),
        "PH": (12.88, 121.77, 2.0),
        "RW": (-1.94, 29.87, 0.5),
        "SN": (14.50, -14.45, 1.0),
        "SL": (8.46, -11.78, 0.5),
        "SO": (5.15, 46.20, 2.0),
        "ZA": (-29.0, 25.0, 3.0),
        "SS": (6.88, 31.31, 2.0),
        "ES": (40.46, -3.75, 1.5),
        "LK": (7.87, 80.77, 0.8),
        "SD": (12.86, 30.22, 3.0),
        "SY": (34.80, 39.00, 1.0),
        "TW": (23.70, 121.00, 0.5),
        "TZ": (-6.37, 34.89, 2.5),
        "TH": (15.87, 100.99, 2.0),
        "TG": (8.62, 0.82, 0.5),
        "TR": (38.96, 35.24, 2.5),
        "UG": (1.37, 32.29, 1.5),
        "UA": (48.38, 31.17, 2.5),
        "GB": (54.0, -2.0, 1.5),
        "US": (39.0, -98.0, 10.0),
        "VE": (6.42, -66.59, 2.0),
        "VN": (14.06, 108.28, 2.0),
        "YE": (15.55, 48.52, 1.5),
        "ZM": (-13.13, 27.85, 2.0),
        "ZW": (-19.02, 29.15, 1.5),
    ]
    
    // Country names to codes
    private let countryNameToCode: [String: String] = [
        "afghanistan": "AF",
        "albania": "AL",
        "algeria": "DZ",
        "argentina": "AR",
        "australia": "AU",
        "bangladesh": "BD",
        "brazil": "BR",
        "cambodia": "KH",
        "cameroon": "CM",
        "canada": "CA",
        "central african republic": "CF",
        "chad": "TD",
        "chile": "CL",
        "china": "CN",
        "colombia": "CO",
        "congo": "CD",
        "democratic republic of congo": "CD",
        "drc": "CD",
        "costa rica": "CR",
        "ecuador": "EC",
        "egypt": "EG",
        "el salvador": "SV",
        "ethiopia": "ET",
        "france": "FR",
        "germany": "DE",
        "ghana": "GH",
        "guatemala": "GT",
        "haiti": "HT",
        "honduras": "HN",
        "india": "IN",
        "indonesia": "ID",
        "iraq": "IQ",
        "israel": "IL",
        "italy": "IT",
        "jamaica": "JM",
        "japan": "JP",
        "jordan": "JO",
        "kenya": "KE",
        "liberia": "LR",
        "malawi": "MW",
        "malaysia": "MY",
        "mali": "ML",
        "mexico": "MX",
        "morocco": "MA",
        "mozambique": "MZ",
        "myanmar": "MM",
        "burma": "MM",
        "nepal": "NP",
        "nicaragua": "NI",
        "niger": "NE",
        "nigeria": "NG",
        "pakistan": "PK",
        "palestine": "PS",
        "palestinian": "PS",
        "panama": "PA",
        "paraguay": "PY",
        "peru": "PE",
        "philippines": "PH",
        "rwanda": "RW",
        "senegal": "SN",
        "sierra leone": "SL",
        "somalia": "SO",
        "south africa": "ZA",
        "south sudan": "SS",
        "spain": "ES",
        "sri lanka": "LK",
        "sudan": "SD",
        "syria": "SY",
        "taiwan": "TW",
        "tanzania": "TZ",
        "thailand": "TH",
        "togo": "TG",
        "turkey": "TR",
        "uganda": "UG",
        "ukraine": "UA",
        "united kingdom": "GB",
        "uk": "GB",
        "united states": "US",
        "usa": "US",
        "america": "US",
        "venezuela": "VE",
        "vietnam": "VN",
        "yemen": "YE",
        "zambia": "ZM",
        "zimbabwe": "ZW",
    ]
    
    // MARK: - Load Charities (with caching)
    
    func fetchCharities() async throws -> [Charity] {
        // Try to load from cache first
        if let cached = loadFromCache() {
            print("🌍 Loaded \(cached.count) charities from cache")
            cachedCharities = cached
            return cached
        }
        
        // No cache - fetch from API
        print("🌍 No cache found - fetching from API...")
        let charities = try await fetchFromAPI()
        
        // Save to cache
        saveToCache(charities)
        
        cachedCharities = charities
        return charities
    }
    
    // Force refresh from API
    func refreshCharities() async throws -> [Charity] {
        print("🌍 Force refreshing from API...")
        let charities = try await fetchFromAPI()
        saveToCache(charities)
        cachedCharities = charities
        return charities
    }
    
    // Clear cache
    func clearCache() {
        try? FileManager.default.removeItem(at: cacheFileURL)
        print("🌍 Cache cleared")
    }
    
    // MARK: - Cache Methods
    
    private func loadFromCache() -> [Charity]? {
        guard FileManager.default.fileExists(atPath: cacheFileURL.path) else {
            return nil
        }
        
        do {
            let data = try Data(contentsOf: cacheFileURL)
            let charities = try JSONDecoder().decode([Charity].self, from: data)
            return charities
        } catch {
            print("🌍 Error loading cache: \(error)")
            return nil
        }
    }
    
    private func saveToCache(_ charities: [Charity]) {
        do {
            let data = try JSONEncoder().encode(charities)
            try data.write(to: cacheFileURL)
            print("🌍 Saved \(charities.count) charities to cache")
        } catch {
            print("🌍 Error saving cache: \(error)")
        }
    }
    
    // MARK: - API Fetch
    
    private func fetchFromAPI() async throws -> [Charity] {
        var allCharities: [Charity] = []
        var nextProjectId: Int? = nil
        var pageCount = 0
        let maxPages = 200
        
        var countryIndex: [String: Int] = [:]
        
        while pageCount < maxPages {
            var urlString = "\(baseURL)/all/projects/active?api_key=\(apiKey)&numberOfResults=50"
            
            if let nextId = nextProjectId {
                urlString += "&nextProjectId=\(nextId)"
            }
            
            guard let url = URL(string: urlString) else {
                throw URLError(.badURL)
            }
            
            let (data, _) = try await URLSession.shared.data(from: url)
            
            let parser = GlobalGivingXMLParser()
            let result = parser.parseWithNextId(data: data)
            let projects = result.projects
            nextProjectId = result.nextProjectId
            
            print("🌍 Page \(pageCount + 1): Parsed \(projects.count) projects")
            
            let charities = projects.compactMap { project -> Charity? in
                guard !project.id.isEmpty else { return nil }
                
                var countryCode = project.countryCode
                
                if countryCode == "XX" || countryCode.isEmpty {
                    let countryLower = project.country.lowercased()
                    if let code = countryNameToCode[countryLower] {
                        countryCode = code
                    }
                }
                
                guard let countryData = countryNameCoordinates[countryCode] else {
                    return nil
                }
                
                let index = countryIndex[countryCode] ?? 0
                countryIndex[countryCode] = index + 1
                
                let spread = countryData.spread
                let cols = 6
                let row = index / cols
                let col = index % cols
                
                let latOffset = (Double(row) - 2.5) * (spread / 3.0)
                let lonOffset = (Double(col) - 2.5) * (spread / 3.0)
                
                let lat = countryData.lat + latOffset
                let lon = countryData.lon + lonOffset
                
                return Charity(
                    id: project.id,
                    name: project.title,
                    description: project.summary,
                    cause: mapThemeToCause(project.themeName),
                    secondaryCauses: [],
                    latitude: lat,
                    longitude: lon,
                    country: project.country,
                    countryCode: countryCode,
                    continent: guessContinent(countryCode: countryCode),
                    city: project.city,
                    websiteURL: URL(string: project.projectLink) ?? URL(string: "https://www.globalgiving.org")!,
                    logoURL: URL(string: project.imageLink ?? ""),
                    foundedYear: nil,
                    registrationNumber: nil
                )
            }
            
            allCharities.append(contentsOf: charities)
            pageCount += 1
            
            if nextProjectId == nil {
                break
            }
        }
        
        print("🌍 Total: Created \(allCharities.count) charities")
        return allCharities
    }
    
    private func mapThemeToCause(_ themeName: String?) -> CharityCause {
        guard let theme = themeName?.lowercased() else { return .humanRights }
        
        if theme.contains("education") || theme.contains("child") {
            return .education
        } else if theme.contains("health") || theme.contains("covid") {
            return .healthcare
        } else if theme.contains("water") || theme.contains("sanitation") {
            return .cleanWater
        } else if theme.contains("environment") || theme.contains("climate") {
            return .environment
        } else if theme.contains("hunger") || theme.contains("food") {
            return .hunger
        } else if theme.contains("disaster") || theme.contains("relief") {
            return .disasterRelief
        } else if theme.contains("animal") || theme.contains("wildlife") {
            return .animalWelfare
        } else {
            return .humanRights
        }
    }
    
    private func guessContinent(countryCode: String) -> Continent {
        let code = countryCode.uppercased()
        
        let northAmerica = ["US", "CA", "MX", "GT", "BZ", "HN", "SV", "NI", "CR", "PA"]
        let southAmerica = ["BR", "AR", "CL", "CO", "PE", "VE", "EC", "BO", "PY", "UY"]
        let europe = ["GB", "DE", "FR", "IT", "ES", "PT", "NL", "BE", "CH", "AT", "PL", "SE", "NO", "DK"]
        let asia = ["CN", "JP", "KR", "IN", "PK", "BD", "ID", "PH", "VN", "TH", "MY", "SG", "NP", "LK", "AF"]
        let oceania = ["AU", "NZ", "FJ", "PG"]
        
        if northAmerica.contains(code) { return .northAmerica }
        if southAmerica.contains(code) { return .southAmerica }
        if europe.contains(code) { return .europe }
        if asia.contains(code) { return .asia }
        if oceania.contains(code) { return .oceania }
        
        return .africa
    }
}

// MARK: - XML Parser

class GlobalGivingXMLParser: NSObject, XMLParserDelegate {
    
    private var projects: [ParsedProject] = []
    private var currentProject: ParsedProject?
    private var currentElement: String = ""
    private var currentValue: String = ""
    private var isInProject: Bool = false
    private var isInImage: Bool = false
    private var isInCountries: Bool = false
    private var nextProjectId: Int? = nil
    
    struct ParsedProject {
        var id: String = ""
        var title: String = ""
        var summary: String = ""
        var projectLink: String = ""
        var imageLink: String?
        var themeName: String?
        var country: String = "Unknown"
        var countryCode: String = "XX"
        var city: String?
        var latitude: Double = 0.0
        var longitude: Double = 0.0
    }
    
    struct ParseResult {
        let projects: [ParsedProject]
        let nextProjectId: Int?
    }
    
    func parse(data: Data) -> [ParsedProject] {
        let parser = XMLParser(data: data)
        parser.delegate = self
        parser.parse()
        return projects
    }
    
    func parseWithNextId(data: Data) -> ParseResult {
        let parser = XMLParser(data: data)
        parser.delegate = self
        parser.parse()
        return ParseResult(projects: projects, nextProjectId: nextProjectId)
    }
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        currentElement = elementName
        currentValue = ""
        
        if elementName == "project" {
            isInProject = true
            currentProject = ParsedProject()
        } else if elementName == "image" {
            isInImage = true
        } else if elementName == "countries" {
            isInCountries = true
        }
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        currentValue += string
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        let trimmedValue = currentValue.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if elementName == "nextProjectId" && !isInProject {
            nextProjectId = Int(trimmedValue)
        }
        
        if isInProject {
            switch elementName {
            case "id":
                if !isInImage {
                    currentProject?.id = trimmedValue
                }
            case "title":
                currentProject?.title = trimmedValue
            case "summary":
                currentProject?.summary = trimmedValue
            case "projectLink":
                currentProject?.projectLink = trimmedValue
            case "url":
                if isInImage && currentProject?.imageLink == nil {
                    currentProject?.imageLink = trimmedValue
                }
            case "themeName":
                currentProject?.themeName = trimmedValue
            case "country":
                if !isInCountries {
                    currentProject?.country = trimmedValue
                }
            case "iso3166CountryCode":
                if currentProject?.countryCode == "XX" {
                    currentProject?.countryCode = trimmedValue
                }
            case "contactCity":
                currentProject?.city = trimmedValue
            case "latitude":
                currentProject?.latitude = Double(trimmedValue) ?? 0.0
            case "longitude":
                currentProject?.longitude = Double(trimmedValue) ?? 0.0
            case "image":
                isInImage = false
            case "countries":
                isInCountries = false
            case "project":
                if let project = currentProject, !project.id.isEmpty {
                    projects.append(project)
                }
                currentProject = nil
                isInProject = false
            default:
                break
            }
        }
        
        currentValue = ""
    }
}
