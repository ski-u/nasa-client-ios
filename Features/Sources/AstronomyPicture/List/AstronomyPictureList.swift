import APIClient
import ComposableArchitecture
import Models

@Reducer
public struct AstronomyPictureList: Sendable {
    @ObservableState
    public struct State: Equatable {
        var error: TextState?
        var isLoaded: Bool
        var isLoading: Bool
        var pictures: [AstronomyPicture]
        
        public init(
            error: TextState? = nil,
            isLoaded: Bool = false,
            isLoading: Bool = false,
            pictures: [AstronomyPicture] = [],
        ) {
            self.error = error
            self.isLoaded = isLoaded
            self.isLoading = isLoading
            self.pictures = pictures
        }
    }
    
    public enum Action {
        case onAppear
        case response(Result<[AstronomyPicture], any Error>)
        case retryButtonTapped
    }
    
    public init() {}
    
    @Dependency(\.apiClient) private var client
    
    private enum CancelID { case fetch }
    
    public var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .onAppear:
                if state.isLoaded {
                    return .none
                }
                return fetchAstronomyPictures(state: &state)

            case let .response(.success(pictures)):
                state.isLoaded = true
                state.isLoading = false
                state.pictures = pictures
                return .none

            case let .response(.failure(error)):
                state.error = .init(error.localizedDescription)
                state.isLoading = false
                return .none

            case .retryButtonTapped:
                return fetchAstronomyPictures(state: &state)
            }
        }
    }
    
    private func fetchAstronomyPictures(state: inout State) -> Effect<Action> {
        state.error = nil
        state.isLoading = true
        
        return .run { send in
            await send(
                .response(
                    Result {
                        try await client.fetchAstronomyPictures()
                    }
                )
            )
        }
        .cancellable(id: CancelID.fetch, cancelInFlight: true)
    }
}
