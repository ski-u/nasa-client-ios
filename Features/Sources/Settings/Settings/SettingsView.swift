import APIClient
import ComposableArchitecture
import LicenseList
import SwiftUI

public struct SettingsView: View {
    @Bindable var store: StoreOf<Settings>
    
    public init(store: StoreOf<Settings>) {
        self.store = store
    }
    
    public var body: some View {
        NavigationStack(path: $store.scope(state: \.path, action: \.path)) {
            List {
                Section {
                    NavigationLink(
                        state: Settings.Path.State.apiKeySetting(
                            APIKeySetting.State()
                        )
                    ) {
                        Label {
                            HStack {
                                Text("API Key", bundle: .module)
                                
                                Spacer()
                                
                                if let key = store.apiKey.masked {
                                    Text(key)
                                        .foregroundStyle(Color.secondary)
                                } else {
                                    Text("None", bundle: .module)
                                        .foregroundStyle(Color.secondary)
                                }
                            }
                        } icon: {
                            Image(systemName: "key.fill")
                                .foregroundStyle(Color.yellow)
                        }
                    }
                    
                    NavigationLink {
                        AppearanceView()
                    } label: {
                        Label {
                            HStack {
                                Text("Appearance", bundle: .module)
                                
                                Spacer()
                                
                                Text(store.userColorScheme.displayString, bundle: .module)
                                    .foregroundStyle(Color.secondary)
                            }
                        } icon: {
                            Image(systemName: "circle.lefthalf.filled")
                                .foregroundStyle(Color.green)
                        }
                    }
                    
                    NavigationLink {
                        TranslationView()
                    } label: {
                        Label {
                            HStack {
                                Text("Machine Translation", bundle: .module)
                                
                                Spacer()
                                
                                Text(store.isTranslationEnabled ? "On" : "Off", bundle: .module)
                                    .foregroundStyle(Color.secondary)
                            }
                        } icon: {
                            Image(systemName: "translate")
                                .foregroundStyle(Color.cyan)
                        }
                    }
                }
                
                Section {
                    NavigationLink {
                        LicenseListView()
                            .licenseViewStyle(.withRepositoryAnchorLink)
                            .navigationTitle(Text("Open Source Licenses", bundle: .module))
                    } label: {
                        Label {
                            Text("Open Source Licenses", bundle: .module)
                        } icon: {
                            Image(systemName: "wrench.and.screwdriver.fill")
                                .foregroundColor(.gray)
                        }
                    }
                }
            }
            .navigationTitle(Text("Settings", bundle: .module))
        } destination: { store in
            switch store.case {
            case let .apiKeySetting(store):
                APIKeySettingView(store: store)
            }
        }
        .onAppear {
            store.send(.onAppear)
        }
    }
}

#Preview {
    NavigationView {
        SettingsView(
            store: .init(
                initialState: Settings.State()
            ) {
                EmptyReducer()
            }
        )
    }
}
