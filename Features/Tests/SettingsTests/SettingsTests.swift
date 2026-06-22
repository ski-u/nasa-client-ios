import ComposableArchitecture
import Testing

@testable import Settings

@MainActor
struct SettingsTests {
    @Test
    func onAppear() async {
        let store = TestStore(
            initialState: Settings.State()
        ) {
            Settings()
        }
        
        store.dependencies.apiKeyClient.getKey = {
            .init(rawValue: "test")
        }
        
        await store.send(.onAppear) {
            $0.apiKey = .init(rawValue: "test")
        }
    }
}
