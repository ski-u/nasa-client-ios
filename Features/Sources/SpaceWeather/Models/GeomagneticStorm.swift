import Foundation
import Models
import SwiftUI

extension GeomagneticStorm {
    var kpColor: Color {
        switch maxKpIndex {
        case 9...: .red
        case 8...: Color(red: 1.0, green: 0.3, blue: 0.0)
        case 7...: .orange
        case 6...: .yellow
        case 5...: .green
        default: .green
        }
    }
    
    var intensityLabel: LocalizedStringKey {
        switch maxKpIndex {
        case 9...: "Extreme"
        case 8...: "Severe"
        case 7...: "Strong"
        case 6...: "Moderate"
        case 5...: "Minor"
        default: "Quiet"
        }
    }
    
    var formattedStartTime: String {
        for strategy in Date.ParseStrategy.startTimeParseStrategies {
            if let date = try? Date(startTime, strategy: strategy) {
                return date.formatted(date: .abbreviated, time: .shortened)
            }
        }
        return startTime
    }
    
    static let placeholders: [Self] = [
        .init(id: "1", startTime: "2024-01-01T00:00Z", maxKpIndex: 8.0),
        .init(id: "2", startTime: "2024-01-02T00:00Z", maxKpIndex: 6.0),
        .init(id: "3", startTime: "2024-01-03T00:00Z", maxKpIndex: 3.0),
    ]
}

private extension Date.ParseStrategy {
    // DONKI API returns startTime in "yyyy-MM-dd'T'HH:mmZ" format (seconds optional)
    static let startTimeParseStrategies: [Self] = [
        .init(
            format:
                "\(year: .defaultDigits)-\(month: .twoDigits)-\(day: .twoDigits)T\(hour: .twoDigits(clock: .twentyFourHour, hourCycle: .zeroBased)):\(minute: .twoDigits)\(timeZone: .iso8601(.short))",
            locale: Locale(identifier: "en_US_POSIX"),
            timeZone: .gmt,
        ),
        .init(
            format:
                "\(year: .defaultDigits)-\(month: .twoDigits)-\(day: .twoDigits)T\(hour: .twoDigits(clock: .twentyFourHour, hourCycle: .zeroBased)):\(minute: .twoDigits):\(second: .twoDigits)\(timeZone: .iso8601(.short))",
            locale: Locale(identifier: "en_US_POSIX"),
            timeZone: .gmt,
        ),
    ]
}
