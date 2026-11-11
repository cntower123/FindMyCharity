//
//  MockCharityService.swift
//  FindMyCharity
//
//  Mock implementation of CharityDataProvider for development and testing.
//  Contains realistic sample charity data spanning multiple continents and causes.
//

import Foundation
import CoreLocation

// MARK: - Mock Charity Service

/// A mock implementation of CharityDataProvider that returns sample charity data.
/// Used for development, testing, and previews before connecting to a real API.
final class MockCharityService: CharityDataProvider, @unchecked Sendable {
    
    // MARK: - Singleton
    
    /// Shared instance for convenient access
    static let shared = MockCharityService()
    
    // MARK: - Properties
    
    /// Simulated network delay (in seconds) to mimic real API behavior
    var simulatedDelay: TimeInterval = 0.3
    
    /// Whether to simulate random failures for testing error handling
    var shouldSimulateFailures: Bool = false
    
    // MARK: - CharityDataProvider Implementation
    
    func fetchAllCharities() async throws -> [Charity] {
        // Simulate network delay
        if simulatedDelay > 0 {
            try await Task.sleep(nanoseconds: UInt64(simulatedDelay * 1_000_000_000))
        }
        
        // Simulate random failure if enabled
        if shouldSimulateFailures && Bool.random() {
            throw CharityDataError.networkError(underlying: URLError(.networkConnectionLost))
        }
        
        return Self.mockCharities
    }
    
    // MARK: - Mock Data
    
    /// Comprehensive list of mock charities for development
    static let mockCharities: [Charity] = [
        
        // MARK: - Africa
        
        Charity(
            id: "af-001",
            name: "WaterAid Kenya",
            description: "Transforming lives by improving access to clean water, sanitation, and hygiene in communities across Kenya. Working with local partners to build sustainable water systems.",
            cause: .cleanWater,
            secondaryCauses: [.healthcare],
            latitude: -1.2921,
            longitude: 36.8219,
            country: "Kenya",
            countryCode: "KE",
            continent: .africa,
            city: "Nairobi",
            websiteURL: URL(string: "https://www.wateraid.org/ke")!,
            logoURL: nil,
            foundedYear: 1999,
            registrationNumber: nil
        ),
        
        Charity(
            id: "af-002",
            name: "Camfed Ghana",
            description: "Supporting girls' education and women's empowerment in rural Ghana. Providing scholarships, mentorship, and entrepreneurship training to break the cycle of poverty.",
            cause: .education,
            secondaryCauses: [.youthDevelopment, .humanRights],
            latitude: 5.6037,
            longitude: -0.1870,
            country: "Ghana",
            countryCode: "GH",
            continent: .africa,
            city: "Accra",
            websiteURL: URL(string: "https://www.camfed.org")!,
            logoURL: nil,
            foundedYear: 1993,
            registrationNumber: nil
        ),
        
        Charity(
            id: "af-003",
            name: "Sheldrick Wildlife Trust",
            description: "Protecting wildlife and habitats across Kenya. Famous for elephant orphan rescue and rehabilitation, anti-poaching operations, and community conservation programs.",
            cause: .animalWelfare,
            secondaryCauses: [.environment],
            latitude: -1.3618,
            longitude: 36.7847,
            country: "Kenya",
            countryCode: "KE",
            continent: .africa,
            city: "Nairobi",
            websiteURL: URL(string: "https://www.sheldrickwildlifetrust.org")!,
            logoURL: nil,
            foundedYear: 1977,
            registrationNumber: nil
        ),
        
        Charity(
            id: "af-004",
            name: "Partners In Health Rwanda",
            description: "Providing quality healthcare to the poorest communities in Rwanda. Running hospitals, training healthcare workers, and strengthening the public health system.",
            cause: .healthcare,
            secondaryCauses: [.education],
            latitude: -1.9403,
            longitude: 29.8739,
            country: "Rwanda",
            countryCode: "RW",
            continent: .africa,
            city: "Kigali",
            websiteURL: URL(string: "https://www.pih.org/country/rwanda")!,
            logoURL: nil,
            foundedYear: 2005,
            registrationNumber: nil
        ),
        
        Charity(
            id: "af-005",
            name: "African Wildlife Foundation",
            description: "Conserving Africa's wildlife and wild lands through strategic land conservation, wildlife protection, and sustainable community development across the continent.",
            cause: .environment,
            secondaryCauses: [.animalWelfare],
            latitude: -1.2735,
            longitude: 36.7981,
            country: "Kenya",
            countryCode: "KE",
            continent: .africa,
            city: "Nairobi",
            websiteURL: URL(string: "https://www.awf.org")!,
            logoURL: nil,
            foundedYear: 1961,
            registrationNumber: nil
        ),
        
        Charity(
            id: "af-006",
            name: "Food For The Hungry Ethiopia",
            description: "Fighting hunger and poverty in Ethiopia through sustainable agriculture programs, clean water projects, and child-focused community development.",
            cause: .hunger,
            secondaryCauses: [.cleanWater, .education],
            latitude: 9.0054,
            longitude: 38.7636,
            country: "Ethiopia",
            countryCode: "ET",
            continent: .africa,
            city: "Addis Ababa",
            websiteURL: URL(string: "https://www.fh.org")!,
            logoURL: nil,
            foundedYear: 1985,
            registrationNumber: nil
        ),
        
        Charity(
            id: "af-007",
            name: "Educate! Uganda",
            description: "Developing young leaders and entrepreneurs in Uganda through skills-based education, mentorship, and business incubation programs in secondary schools.",
            cause: .education,
            secondaryCauses: [.youthDevelopment],
            latitude: 0.3476,
            longitude: 32.5825,
            country: "Uganda",
            countryCode: "UG",
            continent: .africa,
            city: "Kampala",
            websiteURL: URL(string: "https://www.experienceeducate.org")!,
            logoURL: nil,
            foundedYear: 2009,
            registrationNumber: nil
        ),
        
        // MARK: - Asia
        
        Charity(
            id: "as-001",
            name: "Room to Read India",
            description: "Transforming the lives of children in India through literacy and girls' education programs. Building libraries, publishing local language books, and supporting girls through secondary school.",
            cause: .education,
            secondaryCauses: [.youthDevelopment],
            latitude: 19.0760,
            longitude: 72.8777,
            country: "India",
            countryCode: "IN",
            continent: .asia,
            city: "Mumbai",
            websiteURL: URL(string: "https://www.roomtoread.org/india")!,
            logoURL: nil,
            foundedYear: 2003,
            registrationNumber: nil
        ),
        
        Charity(
            id: "as-002",
            name: "BRAC Bangladesh",
            description: "One of the world's largest NGOs, providing microfinance, education, healthcare, and social development programs to lift families out of poverty across Bangladesh.",
            cause: .humanRights,
            secondaryCauses: [.education, .healthcare, .hunger],
            latitude: 23.8103,
            longitude: 90.4125,
            country: "Bangladesh",
            countryCode: "BD",
            continent: .asia,
            city: "Dhaka",
            websiteURL: URL(string: "https://www.brac.net")!,
            logoURL: nil,
            foundedYear: 1972,
            registrationNumber: nil
        ),
        
        Charity(
            id: "as-003",
            name: "Japan Earthquake Relief",
            description: "Supporting communities affected by natural disasters in Japan through emergency response, reconstruction support, and disaster preparedness education.",
            cause: .disasterRelief,
            secondaryCauses: [.housing],
            latitude: 35.6762,
            longitude: 139.6503,
            country: "Japan",
            countryCode: "JP",
            continent: .asia,
            city: "Tokyo",
            websiteURL: URL(string: "https://www.japanrelief.org")!,
            logoURL: nil,
            foundedYear: 2011,
            registrationNumber: nil
        ),
        
        Charity(
            id: "as-004",
            name: "Water.org Philippines",
            description: "Bringing safe water and sanitation to families in the Philippines through affordable microloans and partnerships with local financial institutions.",
            cause: .cleanWater,
            secondaryCauses: [.healthcare],
            latitude: 14.5995,
            longitude: 120.9842,
            country: "Philippines",
            countryCode: "PH",
            continent: .asia,
            city: "Manila",
            websiteURL: URL(string: "https://water.org/our-impact/where-we-work/philippines")!,
            logoURL: nil,
            foundedYear: 2010,
            registrationNumber: nil
        ),
        
        Charity(
            id: "as-005",
            name: "Akshaya Patra Foundation",
            description: "Running the world's largest NGO-run school lunch program, serving nutritious meals to millions of children across India to fight classroom hunger.",
            cause: .hunger,
            secondaryCauses: [.education],
            latitude: 12.9716,
            longitude: 77.5946,
            country: "India",
            countryCode: "IN",
            continent: .asia,
            city: "Bangalore",
            websiteURL: URL(string: "https://www.akshayapatra.org")!,
            logoURL: nil,
            foundedYear: 2000,
            registrationNumber: nil
        ),
        
        Charity(
            id: "as-006",
            name: "Nepal Youth Foundation",
            description: "Freeing children from bonded labor, providing education, healthcare, and family support to ensure every child in Nepal can thrive.",
            cause: .humanRights,
            secondaryCauses: [.education, .healthcare],
            latitude: 27.7172,
            longitude: 85.3240,
            country: "Nepal",
            countryCode: "NP",
            continent: .asia,
            city: "Kathmandu",
            websiteURL: URL(string: "https://www.nepalyouthfoundation.org")!,
            logoURL: nil,
            foundedYear: 1990,
            registrationNumber: nil
        ),
        
        Charity(
            id: "as-007",
            name: "East Bali Poverty Project",
            description: "Breaking the cycle of poverty in remote East Bali through education, healthcare, and community development programs that empower local communities.",
            cause: .education,
            secondaryCauses: [.healthcare, .hunger],
            latitude: -8.4095,
            longitude: 115.1889,
            country: "Indonesia",
            countryCode: "ID",
            continent: .asia,
            city: "Bali",
            websiteURL: URL(string: "https://www.eastbalipovertyproject.org")!,
            logoURL: nil,
            foundedYear: 1998,
            registrationNumber: nil
        ),
        
        Charity(
            id: "as-008",
            name: "Soi Dog Foundation",
            description: "Improving the welfare of dogs and cats in Thailand through rescue, rehabilitation, adoption programs, and humane stray population management.",
            cause: .animalWelfare,
            secondaryCauses: [],
            latitude: 7.9890,
            longitude: 98.3516,
            country: "Thailand",
            countryCode: "TH",
            continent: .asia,
            city: "Phuket",
            websiteURL: URL(string: "https://www.soidog.org")!,
            logoURL: nil,
            foundedYear: 2003,
            registrationNumber: nil
        ),
        
        // MARK: - Europe
        
        Charity(
            id: "eu-001",
            name: "Médecins Sans Frontières",
            description: "Delivering emergency medical care to people affected by conflict, epidemics, disasters, and exclusion from healthcare worldwide from headquarters in Geneva.",
            cause: .healthcare,
            secondaryCauses: [.disasterRelief, .refugeeSupport],
            latitude: 46.2044,
            longitude: 6.1432,
            country: "Switzerland",
            countryCode: "CH",
            continent: .europe,
            city: "Geneva",
            websiteURL: URL(string: "https://www.msf.org")!,
            logoURL: nil,
            foundedYear: 1971,
            registrationNumber: nil
        ),
        
        Charity(
            id: "eu-002",
            name: "British Red Cross",
            description: "Helping people in crisis in the UK and around the world. Providing emergency response, refugee support, first aid training, and community support services.",
            cause: .disasterRelief,
            secondaryCauses: [.healthcare, .refugeeSupport],
            latitude: 51.5194,
            longitude: -0.0833,
            country: "United Kingdom",
            countryCode: "GB",
            continent: .europe,
            city: "London",
            websiteURL: URL(string: "https://www.redcross.org.uk")!,
            logoURL: nil,
            foundedYear: 1870,
            registrationNumber: "220949"
        ),
        
        Charity(
            id: "eu-003",
            name: "Sea-Watch",
            description: "Operating civilian search and rescue ships in the Mediterranean Sea, saving lives of refugees and migrants attempting dangerous sea crossings to Europe.",
            cause: .refugeeSupport,
            secondaryCauses: [.humanRights],
            latitude: 52.5200,
            longitude: 13.4050,
            country: "Germany",
            countryCode: "DE",
            continent: .europe,
            city: "Berlin",
            websiteURL: URL(string: "https://sea-watch.org")!,
            logoURL: nil,
            foundedYear: 2015,
            registrationNumber: nil
        ),
        
        Charity(
            id: "eu-004",
            name: "Mind UK",
            description: "Providing mental health support and advocacy across England and Wales. Running local services, helplines, and campaigning to improve mental health care.",
            cause: .mentalHealth,
            secondaryCauses: [.healthcare],
            latitude: 51.5074,
            longitude: -0.1278,
            country: "United Kingdom",
            countryCode: "GB",
            continent: .europe,
            city: "London",
            websiteURL: URL(string: "https://www.mind.org.uk")!,
            logoURL: nil,
            foundedYear: 1946,
            registrationNumber: "219830"
        ),
        
        Charity(
            id: "eu-005",
            name: "Age UK",
            description: "The UK's largest charity for older people, providing services, information, and support to help people make the most of later life.",
            cause: .elderCare,
            secondaryCauses: [.healthcare],
            latitude: 51.5287,
            longitude: -0.1026,
            country: "United Kingdom",
            countryCode: "GB",
            continent: .europe,
            city: "London",
            websiteURL: URL(string: "https://www.ageuk.org.uk")!,
            logoURL: nil,
            foundedYear: 2009,
            registrationNumber: "1128267"
        ),
        
        Charity(
            id: "eu-006",
            name: "Razom for Ukraine",
            description: "Supporting the people of Ukraine through humanitarian aid, medical supplies, and advocacy for democratic society and human rights.",
            cause: .humanRights,
            secondaryCauses: [.disasterRelief, .healthcare],
            latitude: 50.4501,
            longitude: 30.5234,
            country: "Ukraine",
            countryCode: "UA",
            continent: .europe,
            city: "Kyiv",
            websiteURL: URL(string: "https://www.razomforukraine.org")!,
            logoURL: nil,
            foundedYear: 2014,
            registrationNumber: nil
        ),
        
        Charity(
            id: "eu-007",
            name: "WWF Netherlands",
            description: "Working to conserve nature and reduce the most pressing threats to the diversity of life on Earth through conservation projects across the globe.",
            cause: .environment,
            secondaryCauses: [.animalWelfare, .climate],
            latitude: 52.0907,
            longitude: 5.1214,
            country: "Netherlands",
            countryCode: "NL",
            continent: .europe,
            city: "Utrecht",
            websiteURL: URL(string: "https://www.wwf.nl")!,
            logoURL: nil,
            foundedYear: 1962,
            registrationNumber: nil
        ),
        
        // MARK: - North America
        
        Charity(
            id: "na-001",
            name: "Feeding America",
            description: "The nation's largest domestic hunger-relief organization, operating a network of 200 food banks serving every county in the United States.",
            cause: .hunger,
            secondaryCauses: [],
            latitude: 41.8781,
            longitude: -87.6298,
            country: "United States",
            countryCode: "US",
            continent: .northAmerica,
            city: "Chicago",
            websiteURL: URL(string: "https://www.feedingamerica.org")!,
            logoURL: nil,
            foundedYear: 1979,
            registrationNumber: "36-3673599"
        ),
        
        Charity(
            id: "na-002",
            name: "Habitat for Humanity",
            description: "Building strength, stability, and self-reliance through shelter. Helping families build and improve places to call home through volunteer construction.",
            cause: .housing,
            secondaryCauses: [],
            latitude: 33.7490,
            longitude: -84.3880,
            country: "United States",
            countryCode: "US",
            continent: .northAmerica,
            city: "Atlanta",
            websiteURL: URL(string: "https://www.habitat.org")!,
            logoURL: nil,
            foundedYear: 1976,
            registrationNumber: "91-1914868"
        ),
        
        Charity(
            id: "na-003",
            name: "SickKids Foundation",
            description: "Raising funds for the Hospital for Sick Children in Toronto, supporting groundbreaking research, education, and care for children's health.",
            cause: .healthcare,
            secondaryCauses: [.youthDevelopment],
            latitude: 43.6532,
            longitude: -79.3832,
            country: "Canada",
            countryCode: "CA",
            continent: .northAmerica,
            city: "Toronto",
            websiteURL: URL(string: "https://www.sickkidsfoundation.com")!,
            logoURL: nil,
            foundedYear: 1972,
            registrationNumber: nil
        ),
        
        Charity(
            id: "na-004",
            name: "The Nature Conservancy",
            description: "Protecting ecologically important lands and waters across the Americas and globally through science-based conservation and collaborative partnerships.",
            cause: .environment,
            secondaryCauses: [.climate],
            latitude: 38.9072,
            longitude: -77.0369,
            country: "United States",
            countryCode: "US",
            continent: .northAmerica,
            city: "Washington D.C.",
            websiteURL: URL(string: "https://www.nature.org")!,
            logoURL: nil,
            foundedYear: 1951,
            registrationNumber: "53-0242652"
        ),
        
        Charity(
            id: "na-005",
            name: "St. Jude Children's Research Hospital",
            description: "Leading the way the world understands, treats, and defeats childhood cancer and other life-threatening diseases. Families never receive a bill.",
            cause: .healthcare,
            secondaryCauses: [.youthDevelopment],
            latitude: 35.1495,
            longitude: -90.0490,
            country: "United States",
            countryCode: "US",
            continent: .northAmerica,
            city: "Memphis",
            websiteURL: URL(string: "https://www.stjude.org")!,
            logoURL: nil,
            foundedYear: 1962,
            registrationNumber: "62-0646012"
        ),
        
        Charity(
            id: "na-006",
            name: "charity: water",
            description: "Bringing clean and safe drinking water to people in developing countries through sustainable water projects and 100% funding model.",
            cause: .cleanWater,
            secondaryCauses: [.healthcare],
            latitude: 40.7128,
            longitude: -74.0060,
            country: "United States",
            countryCode: "US",
            continent: .northAmerica,
            city: "New York",
            websiteURL: URL(string: "https://www.charitywater.org")!,
            logoURL: nil,
            foundedYear: 2006,
            registrationNumber: "22-3936753"
        ),
        
        Charity(
            id: "na-007",
            name: "Food Banks Canada",
            description: "Supporting a network of food banks across Canada to relieve hunger and address food insecurity at the national level.",
            cause: .hunger,
            secondaryCauses: [],
            latitude: 43.6532,
            longitude: -79.3832,
            country: "Canada",
            countryCode: "CA",
            continent: .northAmerica,
            city: "Toronto",
            websiteURL: URL(string: "https://www.foodbankscanada.ca")!,
            logoURL: nil,
            foundedYear: 1981,
            registrationNumber: nil
        ),
        
        Charity(
            id: "na-008",
            name: "Boys & Girls Clubs of America",
            description: "Enabling young people to reach their full potential through after-school programs focused on academic success, healthy lifestyles, and character development.",
            cause: .youthDevelopment,
            secondaryCauses: [.education],
            latitude: 33.7490,
            longitude: -84.3880,
            country: "United States",
            countryCode: "US",
            continent: .northAmerica,
            city: "Atlanta",
            websiteURL: URL(string: "https://www.bgca.org")!,
            logoURL: nil,
            foundedYear: 1860,
            registrationNumber: "13-5562976"
        ),
        
        Charity(
            id: "na-009",
            name: "TECHO Mexico",
            description: "Building emergency housing and sustainable communities in Mexican settlements, empowering residents through youth-led volunteer programs.",
            cause: .housing,
            secondaryCauses: [.youthDevelopment],
            latitude: 19.4326,
            longitude: -99.1332,
            country: "Mexico",
            countryCode: "MX",
            continent: .northAmerica,
            city: "Mexico City",
            websiteURL: URL(string: "https://www.techo.org/mexico")!,
            logoURL: nil,
            foundedYear: 2003,
            registrationNumber: nil
        ),
        
        Charity(
            id: "na-010",
            name: "350.org",
            description: "Building a global grassroots climate movement to confront the climate crisis and hold fossil fuel companies accountable for climate action.",
            cause: .climate,
            secondaryCauses: [.environment],
            latitude: 40.7128,
            longitude: -74.0060,
            country: "United States",
            countryCode: "US",
            continent: .northAmerica,
            city: "New York",
            websiteURL: URL(string: "https://350.org")!,
            logoURL: nil,
            foundedYear: 2008,
            registrationNumber: nil
        ),
        
        // MARK: - South America
        
        Charity(
            id: "sa-001",
            name: "Amazon Conservation Association",
            description: "Protecting biodiversity in the Amazon basin through land conservation, scientific research, and sustainable development with local communities in Peru and Bolivia.",
            cause: .environment,
            secondaryCauses: [.climate],
            latitude: -12.0464,
            longitude: -77.0428,
            country: "Peru",
            countryCode: "PE",
            continent: .southAmerica,
            city: "Lima",
            websiteURL: URL(string: "https://www.amazonconservation.org")!,
            logoURL: nil,
            foundedYear: 1999,
            registrationNumber: nil
        ),
        
        Charity(
            id: "sa-002",
            name: "Fundación Niños de los Andes",
            description: "Protecting the rights of vulnerable children in Colombia through prevention, care, and rehabilitation programs for street children and families.",
            cause: .youthDevelopment,
            secondaryCauses: [.humanRights, .education],
            latitude: 4.7110,
            longitude: -74.0721,
            country: "Colombia",
            countryCode: "CO",
            continent: .southAmerica,
            city: "Bogotá",
            websiteURL: URL(string: "https://www.ninandes.org")!,
            logoURL: nil,
            foundedYear: 1973,
            registrationNumber: nil
        ),
        
        Charity(
            id: "sa-003",
            name: "Rainforest Alliance Brazil",
            description: "Working with farmers and forest communities in Brazil to protect rainforests through sustainable agriculture, forest conservation, and community development.",
            cause: .environment,
            secondaryCauses: [.climate, .hunger],
            latitude: -23.5505,
            longitude: -46.6333,
            country: "Brazil",
            countryCode: "BR",
            continent: .southAmerica,
            city: "São Paulo",
            websiteURL: URL(string: "https://www.rainforest-alliance.org")!,
            logoURL: nil,
            foundedYear: 1992,
            registrationNumber: nil
        ),
        
        Charity(
            id: "sa-004",
            name: "COANIQUEM Chile",
            description: "Providing free rehabilitation treatment to children with severe burns in Chile, including medical care, psychological support, and social reintegration.",
            cause: .healthcare,
            secondaryCauses: [.youthDevelopment],
            latitude: -33.4489,
            longitude: -70.6693,
            country: "Chile",
            countryCode: "CL",
            continent: .southAmerica,
            city: "Santiago",
            websiteURL: URL(string: "https://www.coaniquem.cl")!,
            logoURL: nil,
            foundedYear: 1979,
            registrationNumber: nil
        ),
        
        Charity(
            id: "sa-005",
            name: "Banco de Alimentos Argentina",
            description: "Rescuing food that would otherwise be wasted and distributing it to community organizations serving people in need across Argentina.",
            cause: .hunger,
            secondaryCauses: [.environment],
            latitude: -34.6037,
            longitude: -58.3816,
            country: "Argentina",
            countryCode: "AR",
            continent: .southAmerica,
            city: "Buenos Aires",
            websiteURL: URL(string: "https://www.bancodealimentos.org.ar")!,
            logoURL: nil,
            foundedYear: 2001,
            registrationNumber: nil
        ),
        
        // MARK: - Oceania
        
        Charity(
            id: "oc-001",
            name: "OzHarvest",
            description: "Australia's leading food rescue organization, collecting quality surplus food and delivering it to charities supporting vulnerable communities.",
            cause: .hunger,
            secondaryCauses: [.environment],
            latitude: -33.8688,
            longitude: 151.2093,
            country: "Australia",
            countryCode: "AU",
            continent: .oceania,
            city: "Sydney",
            websiteURL: URL(string: "https://www.ozharvest.org")!,
            logoURL: nil,
            foundedYear: 2004,
            registrationNumber: nil
        ),
        
        Charity(
            id: "oc-002",
            name: "Great Barrier Reef Foundation",
            description: "Funding research and conservation projects to protect and restore the Great Barrier Reef, one of the world's most important marine ecosystems.",
            cause: .environment,
            secondaryCauses: [.climate],
            latitude: -27.4698,
            longitude: 153.0251,
            country: "Australia",
            countryCode: "AU",
            continent: .oceania,
            city: "Brisbane",
            websiteURL: URL(string: "https://www.barrierreef.org")!,
            logoURL: nil,
            foundedYear: 1999,
            registrationNumber: nil
        ),
        
        Charity(
            id: "oc-003",
            name: "KidsCan New Zealand",
            description: "Helping Kiwi kids affected by poverty succeed at school by providing food, raincoats, shoes, and basic healthcare in low-income communities.",
            cause: .youthDevelopment,
            secondaryCauses: [.hunger, .education],
            latitude: -36.8485,
            longitude: 174.7633,
            country: "New Zealand",
            countryCode: "NZ",
            continent: .oceania,
            city: "Auckland",
            websiteURL: URL(string: "https://www.kidscan.org.nz")!,
            logoURL: nil,
            foundedYear: 2005,
            registrationNumber: nil
        ),
        
        Charity(
            id: "oc-004",
            name: "Pacific Islands Conservation Initiative",
            description: "Protecting Pacific island ecosystems and supporting indigenous communities through marine conservation, sustainable fishing, and climate adaptation programs.",
            cause: .environment,
            secondaryCauses: [.climate, .humanRights],
            latitude: -18.1416,
            longitude: 178.4419,
            country: "Fiji",
            countryCode: "FJ",
            continent: .oceania,
            city: "Suva",
            websiteURL: URL(string: "https://www.pacificislands.org")!,
            logoURL: nil,
            foundedYear: 2008,
            registrationNumber: nil
        ),
        
        Charity(
            id: "oc-005",
            name: "Australian Wildlife Conservancy",
            description: "Protecting Australia's endangered wildlife through land acquisition, feral predator control, and science-based conservation management.",
            cause: .animalWelfare,
            secondaryCauses: [.environment],
            latitude: -31.9505,
            longitude: 115.8605,
            country: "Australia",
            countryCode: "AU",
            continent: .oceania,
            city: "Perth",
            websiteURL: URL(string: "https://www.australianwildlife.org")!,
            logoURL: nil,
            foundedYear: 2001,
            registrationNumber: nil
        ),
    ]
}
