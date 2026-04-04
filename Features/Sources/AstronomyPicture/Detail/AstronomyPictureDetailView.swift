import ComposableArchitecture
import Models
import SwiftUI
@preconcurrency import Translation

struct AstronomyPictureDetailView: View {
    let picture: AstronomyPicture
    
    @State private var isPresentedFullScreenImage = false
    
    // TODO: Run translation in a reducer
    // 1. Create a new dependency client for `TranslationSession`
    // 2. Create a new reducer for `AstronomyPictureDetailView`
    @State private var translationConfig: TranslationSession.Configuration? = nil
    @State private var translatedTitle: String? = nil
    @State private var translatedExplanation: String? = nil
    @State private var translationErrorString: String? = nil
    
    @Shared(.appStorage("isTranslationEnabled")) var isTranslationEnabled = false
    
    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                media()
                
                VStack(alignment: .leading, spacing: 8) {
                    Text(translatedTitle ?? picture.title)
                        .font(.title2.bold())
                    
                    Text(translatedExplanation ?? picture.explanation)
                    
                    if let copyright = picture.copyright {
                        Text("copyright: \(copyright)")
                            .font(.caption)
                            .foregroundStyle(Color.secondary)
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal)
            }
        }
        .translationTask(translationConfig) { session in
            Task { @MainActor in
                do {
                    let responses = try await session.translations(
                        from: [
                            .init(sourceText: picture.title, clientIdentifier: "title"),
                            .init(
                                sourceText: picture.explanation,
                                clientIdentifier: "explanation",
                            ),
                        ]
                    )
                    
                    responses.forEach {
                        switch $0.clientIdentifier {
                        case "title":
                            translatedTitle = $0.targetText
                        case "explanation":
                            translatedExplanation = $0.targetText
                        default:
                            break
                        }
                    }
                } catch {
                    translationErrorString = error.localizedDescription
                }
            }
        }
        .onAppear {
            translationConfig =
                isTranslationEnabled
                ? .init(
                    source: .init(identifier: "en"),
                    target: .init(identifier: "ja"),
                )
                : nil
        }
    }
    
    @ViewBuilder
    private func media() -> some View {
        switch picture.mediaType {
        case .image:
            AsyncImage(url: picture.url) { phase in
                switch phase {
                case .empty:
                    ProgressView()
                        .frame(maxWidth: .infinity)
                case let .success(image):
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .onTapGesture {
                            isPresentedFullScreenImage = true
                        }
                        .fullScreenCover(isPresented: $isPresentedFullScreenImage) {
                            FullScreenImageView(
                                closeButtonTapped: {
                                    isPresentedFullScreenImage = false
                                },
                                hdImageURL: picture.hdURL,
                                image: image,
                            )
                        }
                case let .failure(error):
                    VStack {
                        Text("Failed to open:")
                        Link(picture.url!.absoluteString, destination: picture.url!)
                        Text(error.localizedDescription)
                    }
                    .font(.subheadline)
                    .frame(maxWidth: .infinity)
                    .textCase(nil)
                @unknown default:
                    Text("Unexpected error occurred", bundle: .module)
                }
            }
        case .video:
            WebView(url: picture.url!)
                .aspectRatio(contentMode: .fit)
        case .other:
            EmptyView()
        case .unknown:
            Text("Unexpected error occurred", bundle: .module)
        }
    }
}

#Preview("Image") {
    NavigationView {
        AstronomyPictureDetailView(
            picture: .init(
                copyright: "Bray FallsKeith Quattrocchi",
                date: .init(year: 2012, month: 7, day: 12),
                explanation:
                    "What will become of our Sun? The first hint of our Sun's future was discovered inadvertently in 1764. At that time, Charles Messier was compiling a list of diffuse objects not to be confused with comets. The 27th object on Messier's list, now known as M27 or the Dumbbell Nebula, is a planetary nebula, one of the brightest planetary nebulae on the sky -- and visible toward the constellation of the Fox (Vulpecula) with binoculars. It takes light about 1000 years to reach us from M27, featured here in colors emitted by hydrogen and oxygen. We now know that in about 6 billion years, our Sun will shed its outer gases into a planetary nebula like M27, while its remaining center will become an X-ray hot white dwarf star.  Understanding the physics and significance of M27 was well beyond 18th century science, though. Even today, many things remain mysterious about planetary nebulas, including how their intricate shapes are created.",
                hdURL: URL(
                    string: "https://apod.nasa.gov/apod/image/2107/M27_Falls_3557.jpg"
                )!,
                mediaType: .image,
                title: "M27: The Dumbbell Nebula",
                url: URL(string: "https://apod.nasa.gov/apod/image/2107/M27_Falls_960.jpg")!,
            )
        )
    }
}

#Preview("Video") {
    NavigationView {
        AstronomyPictureDetailView(
            picture: .init(
                copyright: nil,
                date: .init(year: 2012, month: 7, day: 12),
                explanation:
                    "What happens when a black hole destroys a neutron star? Analyses indicate that just such an event created gravitational wave event GW200115, detected in 2020 January by LIGO and Virgo observatories. To better understand the unusual event, the featured visualization was created from a computer simulation. The visualization video starts with the black hole (about 6 times the Sun's mass) and neutron star (about 1.5 times the Sun's mass) circling each other, together emitting an increasing amount of gravitational radiation. The picturesque pattern of gravitational wave emission is shown in blue. The duo spiral together increasingly fast until the neutron star becomes completely absorbed by the black hole.  Since the neutron star did not break apart during the collision, little light escaped -- which matches the lack of an observed optical counterpart. The remaining black hole rings briefly, and as that dies down so do the emitted gravitational waves.  The 30-second time-lapse video may seem short, but it actually lasts about 1000 times longer than the real merger event.    Astrophysicists: Browse 2,500+ codes in the Astrophysics Source Code Library",
                hdURL: nil,
                mediaType: .video,
                title: "GW200115: Simulation of a Black Hole Merging with a Neutron Star",
                url: URL(string: "https://www.youtube.com/embed/V_Kd4YBNs7c?rel=0")!,
            )
        )
    }
}

#Preview("Other") {
    NavigationView {
        AstronomyPictureDetailView(
            picture: .init(
                copyright: "\nSpaceX\n",
                date: .init(year: 2024, month: 10, day: 23),
                explanation:
                    "Mechazilla has caught the Super Heavy booster! pic.twitter.com/6R5YatSVJX",
                hdURL: nil,
                mediaType: .other,
                title: "Caught",
                url: nil,
            )
        )
    }
}
