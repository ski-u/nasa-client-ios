import APIClient
import APIKeyClient
import APIKeyClientLive
import DateFormatting
import Dependencies
import Foundation
import LocalDate
import Models

extension APIClient: DependencyKey {
    private static let apiKeyClient = APIKeyClient.liveValue
    private static let baseURL = URL(string: "https://api.nasa.gov")!
    
    public static var liveValue: Self {
        .init(
            fetchAstronomyPictures: {
                let payloads: [AstronomyPicture.Payload] = try await fetch(
                    path: "/planetary/apod",
                    queryItems: [
                        URLQueryItem(
                            name: "start_date",
                            value: LocalDate().addingMonths(-1).description,
                        )
                    ],
                )
                return payloads.map(AstronomyPicture.init).reversed()
            },
            fetchGeomagneticStorms: { days in
                let (startDate, endDate) = dateRange(days: days)
                let payloads: [GeomagneticStorm.Payload] = try await fetch(
                    path: "/DONKI/GST",
                    queryItems: [
                        URLQueryItem(name: "startDate", value: startDate),
                        URLQueryItem(name: "endDate", value: endDate),
                    ],
                )
                return payloads.map(GeomagneticStorm.init).sorted { $0.startTime > $1.startTime }
            },
            fetchTodayPicture: {
                let payload: AstronomyPicture.Payload = try await fetch(path: "/planetary/apod")
                return AstronomyPicture(payload: payload)
            },
        )
    }
    
    private static func fetch<T: Decodable>(
        path: String,
        queryItems: [URLQueryItem] = [],
    ) async throws -> T {
        guard let apiKey = apiKeyClient.getKey() else {
            throw NASAClientError.missingAPIKey
        }
        
        var urlComponents = URLComponents(url: baseURL, resolvingAgainstBaseURL: false)!
        urlComponents.path = path
        urlComponents.queryItems =
            [
                URLQueryItem(name: "api_key", value: apiKey.rawValue)
            ] + queryItems
        
        let (data, _) = try await URLSession.shared.data(from: urlComponents.url!)
        
        return try JSONDecoder().decode(T.self, from: data)
    }
    
    private static func dateRange(days: Int) -> (startDate: String, endDate: String) {
        let gregorianCalendar = Calendar(identifier: .gregorian)
        
        let today = Date()
        let start = gregorianCalendar.date(byAdding: .day, value: -days, to: today)!
        return (
            start.formatted(DateFormatStyles.iso8601YearMonthDayUTC),
            today.formatted(DateFormatStyles.iso8601YearMonthDayUTC),
        )
    }
}
