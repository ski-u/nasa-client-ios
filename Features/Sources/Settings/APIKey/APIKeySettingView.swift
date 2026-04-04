import ComposableArchitecture
import SwiftUI

struct APIKeySettingView: View {
    @Bindable var store: StoreOf<APIKeySetting>
    
    var body: some View {
        List {
            Section(footer: link) {
                TextField(
                    String(localized: "Set your API key", bundle: .module),
                    text: $store.apiKeyInput.rawValue,
                )
                .textFieldStyle(.plain)
            }
        }
        .navigationTitle(Text("API key", bundle: .module))
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .confirmationAction) {
                Button(action: { store.send(.updateButtonTapped) }) {
                    Text("Save", bundle: .module)
                }
                .disabled(!store.isEdited)
            }
        }
        .onAppear {
            store.send(.onAppear)
        }
    }
    
    private var link: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(
                "You can generate your API key on [NASA Open APIs](https://api.nasa.gov)",
                bundle: .module,
            )
            .font(.caption)
        }
    }
}

struct APIKeyView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            APIKeySettingView(
                store: .init(
                    initialState: APIKeySetting.State()
                ) {
                    EmptyReducer()
                }
            )
        }
    }
}
