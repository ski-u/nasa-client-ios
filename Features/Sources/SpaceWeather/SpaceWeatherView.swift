import ComposableArchitecture
import Models
import SharedUI
import SwiftUI

public struct SpaceWeatherView: View {
    var store: StoreOf<SpaceWeatherReducer>
    
    public init(store: StoreOf<SpaceWeatherReducer>) {
        self.store = store
    }
    
    public var body: some View {
        NavigationStack {
            Group {
                if let storms = store.storms {
                    Group {
                        if storms.isEmpty {
                            ScrollView {
                                ContentUnavailableView(
                                    String(localized: "No Events", bundle: .module),
                                    systemImage: "bolt.slash",
                                    description: Text(
                                        "No geomagnetic storms in the past 30 days",
                                        bundle: .module
                                    )
                                )
                            }
                        } else {
                            List {
                                stormsSection(storms: storms)
                            }
                        }
                    }
                    .refreshable {
                        await store.send(.pulledToRefresh).finish()
                    }
                } else if let error = store.error {
                    ErrorView(
                        error: Text(error),
                        retry: { store.send(.retryButtonTapped) },
                    )
                    .padding()
                } else {
                    List {
                        stormsSection(storms: GeomagneticStorm.placeholders)
                            .redacted(reason: .placeholder)
                    }
                }
            }
            .navigationTitle(Text("Space Weather", bundle: .module))
            .onAppear {
                store.send(.onAppear)
            }
        }
    }
    
    private func stormsSection(storms: [GeomagneticStorm]) -> some View {
        Section {
            ForEach(storms) { storm in
                GeomagneticStormRowView(storm: storm)
            }
        } header: {
            Text("Geomagnetic Storms", bundle: .module)
                .unredacted()
        }
    }
}

#Preview {
    SpaceWeatherView(
        store: Store(
            initialState: SpaceWeatherReducer.State(
                storms: [
                    .init(
                        id: "2026-02-20T00:00:00-GST-001",
                        startTime: "2026-02-20T00:00Z",
                        maxKpIndex: 8.0,
                    ),
                    .init(
                        id: "2026-02-10T00:00:00-GST-002",
                        startTime: "2026-02-10T12:00Z",
                        maxKpIndex: 5.0,
                    ),
                    .init(
                        id: "2026-01-28T00:00:00-GST-003",
                        startTime: "2026-01-28T06:00Z",
                        maxKpIndex: 3.0,
                    ),
                ],
            ),
        ) {
            EmptyReducer()
        }
    )
}

#Preview("No storms") {
    SpaceWeatherView(
        store: Store(
            initialState: SpaceWeatherReducer.State(
                storms: [],
            ),
        ) {
            EmptyReducer()
        }
    )
}

#Preview("Loading") {
    SpaceWeatherView(
        store: Store(
            initialState: SpaceWeatherReducer.State(
                storms: nil,
            ),
        ) {
            EmptyReducer()
        }
    )
}

#Preview("Error") {
    SpaceWeatherView(
        store: Store(
            initialState: SpaceWeatherReducer.State(
                error: .init("Something went wrong"),
            ),
        ) {
            EmptyReducer()
        }
    )
}
