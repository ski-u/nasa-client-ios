import AstronomyPicture
import ComposableArchitecture
import Settings
import SpaceWeather

@Reducer
public struct AppReducer {
    @ObservableState
    public struct State: Equatable {
        var astronomyPicture = AstronomyPictureReducer.State(date: .init())
        var settings = Settings.State()
        var spaceWeather = SpaceWeatherReducer.State()
        
        public init() {}
    }
    
    public enum Action {
        case astronomyPicture(AstronomyPictureReducer.Action)
        case settings(Settings.Action)
        case spaceWeather(SpaceWeatherReducer.Action)
    }
    
    public init() {}
    
    public var body: some ReducerOf<Self> {
        Scope(state: \.astronomyPicture, action: \.astronomyPicture) {
            AstronomyPictureReducer()
        }
        
        Scope(state: \.settings, action: \.settings) {
            Settings()
        }
        
        Scope(state: \.spaceWeather, action: \.spaceWeather) {
            SpaceWeatherReducer()
        }
    }
}
