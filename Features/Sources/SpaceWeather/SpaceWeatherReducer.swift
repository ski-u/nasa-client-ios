import APIClient
import ComposableArchitecture
import Models

@Reducer
public struct SpaceWeatherReducer: Sendable {
    @ObservableState
    public struct State: Equatable {
        var error: TextState?
        var storms: [GeomagneticStorm]?
        
        public init(
            error: TextState? = nil,
            storms: [GeomagneticStorm]? = nil,
        ) {
            self.error = error
            self.storms = storms
        }
    }
    
    public enum Action {
        case onAppear
        case pulledToRefresh
        case retryButtonTapped
        case stormsResponse(Result<[GeomagneticStorm], any Error>)
    }
    
    public init() {}
    
    @Dependency(\.apiClient) private var client
    
    public var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .onAppear:
                if state.storms != nil {
                    return .none
                }
                return fetchStorms(state: &state)

            case .pulledToRefresh:
                return fetchStorms(state: &state)

            case .retryButtonTapped:
                return fetchStorms(state: &state)

            case let .stormsResponse(.success(storms)):
                state.storms = storms
                return .none

            case let .stormsResponse(.failure(error)):
                state.error = .init(error.localizedDescription)
                return .none
            }
        }
    }
    
    private func fetchStorms(state: inout State) -> EffectOf<Self> {
        state.error = nil
        
        return .run { send in
            await send(
                .stormsResponse(
                    Result {
                        try await client.fetchGeomagneticStorms(days: 30)
                    }
                )
            )
        }
    }
}
