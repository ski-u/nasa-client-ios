import Models
import SwiftUI

struct GeomagneticStormRowView: View {
    var storm: GeomagneticStorm
    
    var body: some View {
        Label {
            HStack {
                VStack(alignment: .leading, spacing: 2) {
                    Text("Kp \(storm.maxKpIndex, format: .number.precision(.fractionLength(1)))")
                        .font(.headline)
                    
                    Text(storm.formattedStartTime)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
                
                Spacer()
                            
                Text(storm.intensityLabel)
                    .font(.caption)
                    .foregroundStyle(storm.kpColor)
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
                startTime: "2026-02-20T00:00Z",
                maxKpIndex: 8.0,
            ),
        )
        
        GeomagneticStormRowView(
            storm: .init(
                id: "2026-02-10T00:00:00-GST-002",
                startTime: "2026-02-10T12:00Z",
                maxKpIndex: 5.0,
            ),
        )
        
        GeomagneticStormRowView(
            storm: .init(
                id: "2026-01-28T00:00:00-GST-003",
                startTime: "2026-01-28T06:00Z",
                maxKpIndex: 3.0,
            ),
        )
    }
}
