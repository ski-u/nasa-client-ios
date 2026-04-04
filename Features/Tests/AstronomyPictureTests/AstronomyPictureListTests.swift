import APIClient
import ComposableArchitecture
import Foundation
import Models
import Testing

@testable import AstronomyPicture

@MainActor
struct AstronomyPictureListTests {
    @MainActor
    struct OnAppear {
        @Test
        func success() async throws {
            let store = TestStore(
                initialState: AstronomyPictureList.State()
            ) {
                AstronomyPictureList()
            }
            
            store.dependencies.apiClient.fetchAstronomyPictures = {
                [.mockImage()]
            }
            
            await store.send(.onAppear) {
                $0.isLoading = true
            }
            
            await store.receive(\.response.success, [.mockImage()]) {
                $0.isLoaded = true
                $0.isLoading = false
                $0.pictures = [.mockImage()]
            }
        }
        
        @Test
        func failure() async throws {
            let store = TestStore(
                initialState: AstronomyPictureList.State()
            ) {
                AstronomyPictureList()
            }
            
            let error = NSError(domain: "test", code: 1)
            store.dependencies.apiClient.fetchAstronomyPictures = {
                throw error
            }
            
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
                initialState: AstronomyPictureList.State(
                    isLoaded: true,
                    pictures: [.mockImage()],
                )
            ) {
                AstronomyPictureList()
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
                initialState: AstronomyPictureList.State(
                    error: .init("error")
                )
            ) {
                AstronomyPictureList()
            }
            
            store.dependencies.apiClient.fetchAstronomyPictures = {
                [.mockImage()]
            }
            
            await store.send(.retryButtonTapped) {
                $0.error = nil
                $0.isLoading = true
            }
            
            await store.receive(\.response.success, [.mockImage()]) {
                $0.isLoaded = true
                $0.isLoading = false
                $0.pictures = [.mockImage()]
            }
        }
        
        @Test
        func failure() async throws {
            let store = TestStore(
                initialState: AstronomyPictureList.State(
                    error: .init("error")
                )
            ) {
                AstronomyPictureList()
            }
            
            let error = NSError(domain: "test", code: 1)
            store.dependencies.apiClient.fetchAstronomyPictures = {
                throw error
            }
            
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
