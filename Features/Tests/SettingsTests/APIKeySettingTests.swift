import APIKeyClient
import ComposableArchitecture
import Testing

@testable import Settings

@MainActor
struct APIKeySettingTests {
    @Test
    func onAppear() async throws {
        let store = TestStore(
            initialState: APIKeySetting.State()
        ) {
            APIKeySetting()
        }
        
        store.dependencies.apiKeyClient.getKey = {
            .init(rawValue: "test")
        }
        
        await store.send(.onAppear) {
            $0.apiKeyInput = .init(rawValue: "test")
        }
    }
    
    @Test
    func updateButtonTapped() async throws {
        let store = TestStore(
            initialState: APIKeySetting.State(
                apiKeyInput: .init(rawValue: "updated"),
            )
        ) {
            APIKeySetting()
        }
        
        store.dependencies.apiKeyClient = .inMemory
        
        await store.send(.updateButtonTapped)
        
        await store.receive(\.delegate.updated)
        
        #expect(store.dependencies.apiKeyClient.getKey() == .init(rawValue: "updated"))
    }
}
