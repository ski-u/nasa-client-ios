import Foundation
import Testing

@testable import DateFormatting

struct DateFormatStylesTests {
    @Test
    func iso8601YearMonthDayUTC() {
        var calendar = Calendar(identifier: .gregorian)
        calendar.timeZone = TimeZone(secondsFromGMT: 0)!
        
        let components = DateComponents(
            calendar: calendar,
            timeZone: TimeZone(secondsFromGMT: 0),
            year: 2026,
            month: 3,
            day: 7,
            hour: 23,
            minute: 45,
            second: 12,
        )
        let date = calendar.date(from: components)!
        
        #expect(date.formatted(DateFormatStyles.iso8601YearMonthDayUTC) == "2026-03-07")
    }
}
