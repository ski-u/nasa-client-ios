import Models
import SwiftUI

struct GeomagneticStormRowView: View {
    var storm: GeomagneticStorm
    
    var body: some View {
        Label {
            VStack(alignment: .leading) {
                Text(storm.intensityLabel, bundle: .module)
                    .font(.caption.bold())
                    .foregroundStyle(storm.kpColor)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(storm.kpColor.opacity(0.15), in: Capsule())
                
                Text("Kp \(storm.maxKpIndex, format: .number.precision(.fractionLength(1)))")
                    .font(.headline)
                
                Text(storm.formattedStartTime)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
        } icon: {
            Image(systemName: "circle.fill")
                .imageScale(.small)
                .foregroundStyle(storm.kpColor)
        }
    }
}

#Preview {
    List {
        GeomagneticStormRowView(
            storm: .init(
                id: "2026-02-20T00:00:00-GST-001",
                startTime: "2026-02-21T00:00Z",
                maxKpIndex: 9.0,
            )
        )
        
        GeomagneticStormRowView(
            storm: .init(
                id: "2026-02-20T00:00:00-GST-001",
                startTime: "2026-02-20T00:00Z",
                maxKpIndex: 8.0,
            )
        )
        
        GeomagneticStormRowView(
            storm: .init(
                id: "2026-02-10T00:00:00-GST-002",
                startTime: "2026-02-12T12:00Z",
                maxKpIndex: 7.0,
            )
        )
        
        GeomagneticStormRowView(
            storm: .init(
                id: "2026-02-10T00:00:00-GST-002",
                startTime: "2026-02-11T12:00Z",
                maxKpIndex: 6.0,
            )
        )
        
        GeomagneticStormRowView(
            storm: .init(
                id: "2026-02-10T00:00:00-GST-002",
                startTime: "2026-02-10T12:00Z",
                maxKpIndex: 5.0,
            )
        )
        
        GeomagneticStormRowView(
            storm: .init(
                id: "2026-01-28T00:00:00-GST-003",
                startTime: "2026-01-28T06:00Z",
                maxKpIndex: 3.0,
            )
        )
    }
}
