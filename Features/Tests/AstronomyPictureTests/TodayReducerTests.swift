import APIClient
import ComposableArchitecture
import Foundation
import LocalDate
import Models
import Testing

@testable import AstronomyPicture

@MainActor
struct TodayReducerTests {
    @MainActor
    struct OnAppear {
        @Test
        func success() async throws {
            let store = TestStore(
                initialState: TodayReducer.State()
            ) {
                TodayReducer()
            }
            
            let mock = AstronomyPicture.mockImage()
            store.dependencies.apiClient.fetchTodayPicture = { mock }
            
            await store.send(.onAppear) {
                $0.isLoading = true
            }
            
            await store.receive(\.response.success) {
                $0.isLoading = false
                $0.picture = mock
            }
        }
        
        @Test
        func failure() async throws {
            let store = TestStore(
                initialState: TodayReducer.State()
            ) {
                TodayReducer()
            }
            
            let error = NSError(domain: "test", code: 1)
            store.dependencies.apiClient.fetchTodayPicture = { throw error }
            
            await store.send(.onAppear) {
                $0.isLoading = true
            }
            
            await store.receive(\.response.failure) {
                $0.error = .init(error.localizedDescription)
                $0.isLoading = false
            }
        }
        
        @Test
        func alreadyLoaded() async throws {
            let store = TestStore(
                initialState: TodayReducer.State(
                    picture: .mockImage()
                )
            ) {
                TodayReducer()
            }
            
            await store.send(.onAppear)
            
            // Canceled to load
        }
        
        @Test
        func whenLoading() async throws {
            let store = TestStore(
                initialState: TodayReducer.State(
                    isLoading: true
                )
            ) {
                TodayReducer()
            }
            
            await store.send(.onAppear)
            
            // Canceled to load
        }
    }
    
    @MainActor
    struct Refresh {
        @Test
        func success() async throws {
            let store = TestStore(
                initialState: TodayReducer.State()
            ) {
                TodayReducer()
            }
            
            let mock = AstronomyPicture.mockImage()
            store.dependencies.apiClient.fetchTodayPicture = { mock }
            
            await store.send(.pulledToRefresh) {
                $0.isLoading = true
            }
            
            await store.receive(\.response.success) {
                $0.isLoading = false
                $0.picture = mock
            }
        }
        
        @Test
        func failure() async throws {
            let store = TestStore(
                initialState: TodayReducer.State()
            ) {
                TodayReducer()
            }
            
            let error = NSError(domain: "test", code: 1)
            store.dependencies.apiClient.fetchTodayPicture = { throw error }
            
            await store.send(.pulledToRefresh) {
                $0.isLoading = true
            }
            
            await store.receive(\.response.failure) {
                $0.error = .init(error.localizedDescription)
                $0.isLoading = false
            }
        }
    }
    
    @MainActor
    struct Retry {
        @Test
        func success() async throws {
            let store = TestStore(
                initialState: TodayReducer.State(
                    error: .init("error")
                )
            ) {
                TodayReducer()
            }
            
            let mock = AstronomyPicture.mockImage()
            store.dependencies.apiClient.fetchTodayPicture = { mock }
            
            await store.send(.retryButtonTapped) {
                $0.error = nil
                $0.isLoading = true
            }
            
            await store.receive(\.response.success) {
                $0.isLoading = false
                $0.picture = mock
            }
        }
        
        @Test
        func failure() async throws {
            let store = TestStore(
                initialState: TodayReducer.State(
                    error: .init("error")
                )
            ) {
                TodayReducer()
            }
            
            let error = NSError(domain: "test", code: 1)
            store.dependencies.apiClient.fetchTodayPicture = { throw error }
            
            await store.send(.retryButtonTapped) {
                $0.error = nil
                $0.isLoading = true
            }
            
            await store.receive(\.response.failure) {
                $0.error = .init(error.localizedDescription)
                $0.isLoading = false
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
