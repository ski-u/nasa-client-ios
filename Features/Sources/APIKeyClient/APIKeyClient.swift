import Dependencies
import DependenciesMacros
import Models

@DependencyClient
public struct APIKeyClient: Sendable {
    public var getKey: @Sendable () -> APIKey?
    public var isKeyStored: @Sendable () -> Bool = { false }
    public var setKey: @Sendable (APIKey?) -> Void
}

extension APIKeyClient: TestDependencyKey {
    public static let testValue = Self()
    
    public static var inMemory: Self {
        let key = LockIsolated<APIKey?>(nil)
        
        return .init(
            getKey: { key.value },
            isKeyStored: { key.value != nil },
            setKey: { key.setValue($0) },
        )
    }
}

public extension DependencyValues {
    var apiKeyClient: APIKeyClient {
        get { self[APIKeyClient.self] }
        set { self[APIKeyClient.self] = newValue }
    }
}
