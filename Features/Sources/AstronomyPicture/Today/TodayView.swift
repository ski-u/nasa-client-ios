import ComposableArchitecture
import LocalDate
import Models
import SharedUI
import SwiftUI

public struct TodayView: View {
    @Bindable var store: StoreOf<TodayReducer>
    
    @State private var isPresentedFullScreenImage = false
    
    public init(store: StoreOf<TodayReducer>) {
        self.store = store
    }
    
    public var body: some View {
        NavigationStack(path: $store.scope(state: \.path, action: \.path)) {
            Group {
                if let error = store.error {
                    ErrorView(
                        error: Text(error),
                        retry: { store.send(.retryButtonTapped) },
                    )
                    .padding()
                } else if let picture = store.picture {
                    AstronomyPictureDetailView(picture: picture)
                } else {
                    AstronomyPictureDetailView(picture: .placeholder)
                        .redacted(reason: .placeholder)
                }
            }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    NavigationLink(
                        state: TodayReducer.Path.State.astronomyPictureList(
                            AstronomyPictureList.State()
                        )
                    ) {
                        Image(systemName: "calendar")
                    }
                    .accessibilityLabel(Text("History", bundle: .module))
                }
            }
            .refreshable {
                store.send(.pulledToRefresh)
            }
            .onAppear {
                store.send(.onAppear)
            }
            .navigationTitle(Text("Today", bundle: .module))
        } destination: { store in
            switch store.case {
            case let .astronomyPictureList(store):
                AstronomyPictureListView(store: store)
            }
        }
    }
}

private extension AstronomyPicture {
    static let placeholder = Self(
        date: .init(),
        explanation: "placeholder explanation",
        mediaType: .image,
        title: "placeholder title",
    )
}

#Preview("Image") {
    NavigationView {
        TodayView(
            store: .init(
                initialState: TodayReducer.State(
                    error: nil,
                    isLoading: false,
                    picture: .init(
                        copyright: "Bray FallsKeith Quattrocchi",
                        date: LocalDate(year: 2012, month: 7, day: 12),
                        explanation:
                            "What will become of our Sun? The first hint of our Sun's future was discovered inadvertently in 1764. At that time, Charles Messier was compiling a list of diffuse objects not to be confused with comets. The 27th object on Messier's list, now known as M27 or the Dumbbell Nebula, is a planetary nebula, one of the brightest planetary nebulae on the sky -- and visible toward the constellation of the Fox (Vulpecula) with binoculars. It takes light about 1000 years to reach us from M27, featured here in colors emitted by hydrogen and oxygen. We now know that in about 6 billion years, our Sun will shed its outer gases into a planetary nebula like M27, while its remaining center will become an X-ray hot white dwarf star.  Understanding the physics and significance of M27 was well beyond 18th century science, though. Even today, many things remain mysterious about planetary nebulas, including how their intricate shapes are created.",
                        hdURL: URL(
                            string: "https://apod.nasa.gov/apod/image/2107/M27_Falls_3557.jpg"
                        )!,
                        mediaType: .image,
                        title: "M27: The Dumbbell Nebula",
                        url: URL(
                            string: "https://apod.nasa.gov/apod/image/2107/M27_Falls_960.jpg"
                        )!,
                    ),
                )
            ) {
                EmptyReducer()
            }
        )
    }
}

#Preview("Video") {
    NavigationView {
        TodayView(
            store: .init(
                initialState: TodayReducer.State(
                    error: nil,
                    isLoading: false,
                    picture: .init(
                        copyright: nil,
                        date: LocalDate(year: 2012, month: 7, day: 12),
                        explanation:
                            "What happens when a black hole destroys a neutron star? Analyses indicate that just such an event created gravitational wave event GW200115, detected in 2020 January by LIGO and Virgo observatories. To better understand the unusual event, the featured visualization was created from a computer simulation. The visualization video starts with the black hole (about 6 times the Sun's mass) and neutron star (about 1.5 times the Sun's mass) circling each other, together emitting an increasing amount of gravitational radiation. The picturesque pattern of gravitational wave emission is shown in blue. The duo spiral together increasingly fast until the neutron star becomes completely absorbed by the black hole.  Since the neutron star did not break apart during the collision, little light escaped -- which matches the lack of an observed optical counterpart. The remaining black hole rings briefly, and as that dies down so do the emitted gravitational waves.  The 30-second time-lapse video may seem short, but it actually lasts about 1000 times longer than the real merger event.    Astrophysicists: Browse 2,500+ codes in the Astrophysics Source Code Library",
                        hdURL: nil,
                        mediaType: .video,
                        title: "GW200115: Simulation of a Black Hole Merging with a Neutron Star",
                        url: URL(string: "https://www.youtube.com/embed/V_Kd4YBNs7c?rel=0")!,
                    ),
                )
            ) {
                EmptyReducer()
            }
        )
    }
}

#Preview("Other") {
    NavigationView {
        TodayView(
            store: .init(
                initialState: TodayReducer.State(
                    error: nil,
                    isLoading: false,
                    picture: .init(
                        copyright: "\nSpaceX\n",
                        date: LocalDate(year: 2024, month: 10, day: 23),
                        explanation:
                            "Mechazilla has caught the Super Heavy booster! pic.twitter.com/6R5YatSVJX",
                        hdURL: nil,
                        mediaType: .other,
                        title: "Caught",
                        url: nil,
                    ),
                )
            ) {
                EmptyReducer()
            }
        )
    }
}

#Preview("Error") {
    NavigationView {
        TodayView(
            store: .init(
                initialState: TodayReducer.State(
                    error: .init("Something wrong happened")
                )
            ) {
                EmptyReducer()
            }
        )
    }
}
