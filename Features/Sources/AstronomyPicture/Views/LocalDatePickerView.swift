import Foundation
import LocalDate
import SwiftUI

public struct LocalDatePickerView: View {
    @State private var selection: LocalDate
    var onCompleted: (LocalDate) -> Void
    
    public init(
        selection: LocalDate,
        onCompleted: @escaping (LocalDate) -> Void,
    ) {
        _selection = State(initialValue: selection)
        self.onCompleted = onCompleted
    }
    
    public var body: some View {
        NavigationStack {
            DatePicker(
                selection: .init(
                    get: { selection.date(in: .newYork) },
                    set: { selection = .init(from: $0, in: .newYork) },
                ),
                in: minimumDate...maximumDate,
                displayedComponents: [.date],
            ) {
                EmptyView()
            }
            .datePickerStyle(.graphical)
            .frame(maxHeight: .infinity, alignment: .top)
            .navigationTitle(Text("Select date", bundle: .module))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button(action: { onCompleted(selection) }) {
                        Image(systemName: "checkmark")
                    }
                    .buttonStyle(.borderedProminent)
                }
            }
        }
    }
}

private extension LocalDatePickerView {
    var newYorkCalendar: Calendar {
        var calendar = Calendar(identifier: .gregorian)
        calendar.timeZone = .newYork
        return calendar
    }
    
    var maximumDate: Date {
        newYorkCalendar.startOfDay(for: .now)
    }
    
    var minimumDate: Date {
        DateComponents(
            calendar: newYorkCalendar,
            year: 1995,
            month: 6,
            day: 16,
        ).date!
    }
}

#Preview {
    LocalDatePickerView(
        selection: .init(),
        onCompleted: { _ in },
    )
}
