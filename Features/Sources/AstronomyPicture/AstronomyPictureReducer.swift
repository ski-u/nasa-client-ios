import APIClient
import ComposableArchitecture
import LocalDate
import Models

@Reducer
public struct AstronomyPictureReducer: Sendable {
    @ObservableState
    public struct State: Equatable {
        var date: LocalDate
        var error: TextState?
        var isFullScreenImagePresented: Bool
        var picture: AstronomyPicture?
        
        public init(
            date: LocalDate,
            error: TextState? = nil,
            isFullScreenImagePresented: Bool = false,
            picture: AstronomyPicture? = nil,
        ) {
            self.date = date
            self.error = error
            self.isFullScreenImagePresented = isFullScreenImagePresented
            self.picture = picture
        }
    }
    
    public enum Action: BindableAction {
        case astronomyPictureImageTapped
        case binding(BindingAction<State>)
        case onAppear
        case response(Result<AstronomyPicture, any Error>)
        case retryButtonTapped
    }
    
    public init() {}
    
    @Dependency(\.apiClient) private var apiClient
    
    public var body: some ReducerOf<Self> {
        BindingReducer()
        
        Reduce { state, action in
            switch action {
            case .astronomyPictureImageTapped:
                state.isFullScreenImagePresented = true
                return .none
                
            case .binding:
                return .none
                
            case .onAppear:
                if state.picture != nil {
                    return .none
                }
                return fetchAstronomyPicture(state: &state)
                
            case let .response(.success(picture)):
                state.picture = picture
                return .none
                
            case let .response(.failure(error)):
                state.error = .init(error.localizedDescription)
                return .none
                
            case .retryButtonTapped:
                state.error = nil
                return fetchAstronomyPicture(state: &state)
            }
        }
    }
    
    private func fetchAstronomyPicture(state: inout State) -> Effect<Action> {
        state.picture = nil
        
        return .run { [date = state.date] send in
            await send(
                .response(
                    Result {
                        try await apiClient.fetchAstronomyPicture(date: date)
                    }
                )
            )
        }
    }
}
