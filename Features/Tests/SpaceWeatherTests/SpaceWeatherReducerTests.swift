import ComposableArchitecture
import Foundation
import Models
@testable import SpaceWeather
import Testing

struct SpaceWeatherReducerTests {
    @MainActor
    struct OnAppear {
        @Test
        func success() async {
            let store = TestStore(
                initialState: SpaceWeatherReducer.State()
            ) {
                SpaceWeatherReducer()
            }
            
            let storms = [GeomagneticStorm.mock]
            store.dependencies.apiClient.fetchGeomagneticStorms = { _ in
                storms
            }
            
            await store.send(.onAppear)
            
            await store.receive(\.stormsResponse.success, storms) {
                $0.storms = storms
            }
        }
        
        @Test
        func failure() async {
            let store = TestStore(
                initialState: SpaceWeatherReducer.State()
            ) {
                SpaceWeatherReducer()
            }
            
            let error = NSError(domain: "test", code: 1)
            store.dependencies.apiClient.fetchGeomagneticStorms = { _ in
                throw error
            }
            
            await store.send(.onAppear)
            
            await store.receive(\.stormsResponse.failure) {
                $0.error = .init(error.localizedDescription)
            }
        }
        
        @Test
        func alreadyLoaded() async {
            let store = TestStore(
                initialState: SpaceWeatherReducer.State(
                    storms: [.mock]
                )
            ) {
                SpaceWeatherReducer()
            }
            
            await store.send(.onAppear)
        }
    }
    
    @MainActor
    struct Refresh {
        @Test
        func success() async {
            let store = TestStore(
                initialState: SpaceWeatherReducer.State(
                    storms: []
                )
            ) {
                SpaceWeatherReducer()
            }
            
            let storms = [GeomagneticStorm.mock]
            store.dependencies.apiClient.fetchGeomagneticStorms = { _ in
                storms
            }
            
            await store.send(.pulledToRefresh)
            
            await store.receive(\.stormsResponse.success, storms) {
                $0.storms = storms
            }
        }
        
        @Test
        func failure() async {
            let store = TestStore(
                initialState: SpaceWeatherReducer.State(
                    storms: []
                )
            ) {
                SpaceWeatherReducer()
            }
            
            let error = NSError(domain: "test", code: 1)
            store.dependencies.apiClient.fetchGeomagneticStorms = { _ in
                throw error
            }
            
            await store.send(.pulledToRefresh)
            
            await store.receive(\.stormsResponse.failure) {
                $0.error = .init(error.localizedDescription)
            }
        }
    }
    
    @MainActor
    struct Retry {
        @Test
        func success() async {
            let store = TestStore(
                initialState: SpaceWeatherReducer.State(
                    error: .init("error")
                )
            ) {
                SpaceWeatherReducer()
            }
            
            let storms = [GeomagneticStorm.mock]
            store.dependencies.apiClient.fetchGeomagneticStorms = { _ in
                storms
            }
            
            await store.send(.retryButtonTapped) {
                $0.error = nil
            }
            
            await store.receive(\.stormsResponse.success, storms) {
                $0.storms = storms
            }
        }
        
        @Test
        func failure() async {
            let store = TestStore(
                initialState: SpaceWeatherReducer.State(
                    error: .init("error")
                )
            ) {
                SpaceWeatherReducer()
            }
            
            let error = NSError(domain: "test", code: 1)
            store.dependencies.apiClient.fetchGeomagneticStorms = { _ in
                throw error
            }
            
            await store.send(.retryButtonTapped) {
                $0.error = nil
            }
            
            await store.receive(\.stormsResponse.failure) {
                $0.error = .init(error.localizedDescription)
            }
        }
    }
}

private extension GeomagneticStorm {
    static let mock = Self(
        id: "1",
        startTime: "2024-01-01T00:00Z",
        maxKpIndex: 8.0,
    )
}
