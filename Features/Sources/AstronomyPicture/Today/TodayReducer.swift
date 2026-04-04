import APIClient
import ComposableArchitecture
import Foundation
import Models

@Reducer
public struct TodayReducer: Sendable {
    @Reducer
    public enum Path {
        case astronomyPictureList(AstronomyPictureList)
    }
    
    @ObservableState
    public struct State: Equatable {
        var error: TextState?
        var isLoading = false
        var path: StackState<Path.State>
        var picture: AstronomyPicture?
        
        public init(
            error: TextState? = nil,
            isLoading: Bool = false,
            path: StackState<Path.State> = .init([]),
            picture: AstronomyPicture? = nil,
        ) {
            self.error = error
            self.isLoading = isLoading
            self.path = path
            self.picture = picture
        }
    }
    
    public enum Action {
        case onAppear
        case path(StackActionOf<Path>)
        case pulledToRefresh
        case response(Result<AstronomyPicture, any Error>)
        case retryButtonTapped
    }
    
    public init() {}
    
    @Dependency(\.apiClient) private var client
    
    private enum CancelID { case fetch }
    
    public var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .onAppear:
                if state.picture != nil || state.isLoading {
                    return .none
                }
                return fetchTodayPicture(state: &state)

            case .path:
                return .none

            case .pulledToRefresh:
                return fetchTodayPicture(state: &state)

            case let .response(.success(picture)):
                state.isLoading = false
                state.picture = picture
                return .none

            case let .response(.failure(error)):
                state.error = .init(error.localizedDescription)
                state.isLoading = false
                return .none

            case .retryButtonTapped:
                return fetchTodayPicture(state: &state)
            }
        }
        .forEach(\.path, action: \.path)
    }
    
    private func fetchTodayPicture(state: inout State) -> Effect<Action> {
        state.error = nil
        state.isLoading = true
        state.picture = nil
        
        return .run { send in
            await send(
                .response(
                    Result {
                        try await client.fetchTodayPicture()
                    }
                )
            )
        }
        .cancellable(id: CancelID.fetch, cancelInFlight: true)
    }
}

extension TodayReducer.Path.State: Equatable {}
