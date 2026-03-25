import AstronomyPicture
import ComposableArchitecture
import Settings
import SpaceWeather

@Reducer
public struct AppReducer {
    @ObservableState
    public struct State: Equatable {
        var settings = Settings.State()
        var spaceWeather = SpaceWeatherReducer.State()
        var today = TodayReducer.State()
        
        public init() {}
    }
    
    public enum Action {
        case settings(Settings.Action)
        case spaceWeather(SpaceWeatherReducer.Action)
        case today(TodayReducer.Action)
    }
    
    public init() {}
    
    public var body: some ReducerOf<Self> {
        Scope(state: \.settings, action: \.settings) {
            Settings()
        }
        
        Scope(state: \.spaceWeather, action: \.spaceWeather) {
            SpaceWeatherReducer()
        }
        
        Scope(state: \.today, action: \.today) {
            TodayReducer()
        }
    }
}
