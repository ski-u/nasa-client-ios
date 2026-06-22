import Models
import Sharing
import SwiftUI
@preconcurrency import Translation

struct AstronomyPictureContentView: View {
    @Binding var isFullScreenImagePresented: Bool
    var picture: AstronomyPicture
    
    // TODO: Run translation in a reducer if possible
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
                            isFullScreenImagePresented = true
                        }
                        .fullScreenCover(isPresented: $isFullScreenImagePresented) {
                            FullScreenImageView(
                                closeButtonTapped: {
                                    isFullScreenImagePresented = false
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
