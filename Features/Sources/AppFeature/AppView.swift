import AstronomyPicture
import ComposableArchitecture
import Models
import Settings
import SpaceWeather
import SwiftUI

public struct AppView: View {
    var store: StoreOf<AppReducer>
    
    @State private var sidebarItem: SidebarItem? = .today
    
    @Shared(.appStorage("colorScheme")) var userColorScheme = UserColorScheme.system
    
    public init(store: StoreOf<AppReducer>) {
        self.store = store
    }
    
    public var body: some View {
        Group {
            switch UIDevice.current.userInterfaceIdiom {
            case .phone:
                if #available(iOS 26, *) {
                    tabView
                        .tabBarMinimizeBehavior(.onScrollDown)
                } else {
                    tabView
                }
            default:
                sidebarView
            }
        }
        .preferredColorScheme(userColorScheme.colorScheme)
    }
    
    private var tabView: some View {
        TabView {
            NavigationStack {
                TodayView(store: store.scope(state: \.today, action: \.today))
            }
            .tabItem {
                VStack {
                    Image(systemName: "moon.stars")
                    Text("Today", bundle: .module)
                }
            }
            
            SpaceWeatherView(store: store.scope(state: \.spaceWeather, action: \.spaceWeather))
                .tabItem {
                    VStack {
                        Image(systemName: "bolt.fill")
                        Text("Space Weather", bundle: .module)
                    }
                }
            
            SettingsView(store: store.scope(state: \.settings, action: \.settings))
                .tabItem {
                    VStack {
                        Image(systemName: "gear")
                        Text("Settings", bundle: .module)
                    }
                }
        }
    }
    
    private var sidebarView: some View {
        NavigationSplitView {
            List(SidebarItem.allCases, id: \.self, selection: $sidebarItem) { item in
                Label {
                    Text(item.displayName, bundle: .module)
                } icon: {
                    item.icon
                }
            }
        } detail: {
            switch sidebarItem {
            case .today:
                TodayView(store: store.scope(state: \.today, action: \.today))
            case .spaceWeather:
                SpaceWeatherView(store: store.scope(state: \.spaceWeather, action: \.spaceWeather))
            case .setting:
                SettingsView(store: store.scope(state: \.settings, action: \.settings))
            case .none:
                EmptyView()
            }
        }
    }
    
    private enum SidebarItem: CaseIterable {
        case today
        case spaceWeather
        case setting
        
        var displayName: LocalizedStringKey {
            switch self {
            case .today:
                "Today"
            case .spaceWeather:
                "Space Weather"
            case .setting:
                "Settings"
            }
        }
        
        var icon: Image {
            switch self {
            case .today:
                Image(systemName: "moon.stars")
            case .spaceWeather:
                Image(systemName: "bolt.fill")
            case .setting:
                Image(systemName: "gear")
            }
        }
    }
}
