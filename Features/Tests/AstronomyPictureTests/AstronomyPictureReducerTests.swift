import APIClient
import ComposableArchitecture
import Foundation
import LocalDate
import Models
import Testing

@testable import AstronomyPicture

@MainActor
struct AstronomyPictureReducerTests {
    @Test
    func astronomyPictureImageTapped() async throws {
        let store = TestStore(
            initialState: AstronomyPictureReducer.State(
                date: .init(),
                picture: .mockImage(),
            )
        ) {
            AstronomyPictureReducer()
        }
        
        await store.send(.astronomyPictureImageTapped) {
            $0.isFullScreenImagePresented = true
        }
    }
    
    @MainActor
    struct OnAppear {
        @Test
        func success() async throws {
            let store = TestStore(
                initialState: AstronomyPictureReducer.State(
                    date: .init(),
                )
            ) {
                AstronomyPictureReducer()
            }
            
            let mock = AstronomyPicture.mockImage()
            store.dependencies.apiClient.fetchAstronomyPicture = { _ in mock }
            
            await store.send(.onAppear)
            
            await store.receive(\.response.success) {
                $0.picture = mock
            }
        }
        
        @Test
        func failure() async throws {
            let store = TestStore(
                initialState: AstronomyPictureReducer.State(
                    date: .init(),
                )
            ) {
                AstronomyPictureReducer()
            }
            
            let error = NSError(domain: "test", code: 1)
            store.dependencies.apiClient.fetchAstronomyPicture = { _ in throw error }
            
            await store.send(.onAppear)
            
            await store.receive(\.response.failure) {
                $0.error = .init(error.localizedDescription)
            }
        }
        
        @Test
        func alreadyLoaded() async throws {
            let store = TestStore(
                initialState: AstronomyPictureReducer.State(
                    date: .init(),
                    picture: .mockImage(),
                )
            ) {
                AstronomyPictureReducer()
            }
            
            await store.send(.onAppear)
            
            // Canceled to load
        }
    }
    
    @MainActor
    struct Retry {
        @Test
        func success() async throws {
            let store = TestStore(
                initialState: AstronomyPictureReducer.State(
                    date: .init(),
                    error: .init("error"),
                )
            ) {
                AstronomyPictureReducer()
            }
            
            let mock = AstronomyPicture.mockImage()
            store.dependencies.apiClient.fetchAstronomyPicture = { _ in mock }
            
            await store.send(.retryButtonTapped) {
                $0.error = nil
            }
            
            await store.receive(\.response.success) {
                $0.picture = mock
            }
        }
        
        @Test
        func failure() async throws {
            let store = TestStore(
                initialState: AstronomyPictureReducer.State(
                    date: .init(),
                    error: .init("error"),
                )
            ) {
                AstronomyPictureReducer()
            }
            
            let error = NSError(domain: "test", code: 1)
            store.dependencies.apiClient.fetchAstronomyPicture = { _ in throw error }
            
            await store.send(.retryButtonTapped) {
                $0.error = nil
            }
            
            await store.receive(\.response.failure) {
                $0.error = .init(error.localizedDescription)
            }
        }
    }
}

extension AstronomyPicture {
    static func mockImage() -> Self {
        .init(
            copyright: "copyright",
            date: LocalDate(year: 2012, month: 7, day: 12),
            explanation: "explanation",
            hdURL: URL(string: "https://example.com/hd-url")!,
            mediaType: .image,
            title: "title",
            url: URL(string: "https://example.com/url")!,
        )
    }
    
    static func mockVideo() -> Self {
        .init(
            copyright: "copyright",
            date: LocalDate(year: 2012, month: 7, day: 12),
            explanation: "explanation",
            hdURL: nil,
            mediaType: .video,
            title: "title",
            url: URL(string: "https://example.com")!,
        )
    }
}
