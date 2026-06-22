import ComposableArchitecture
import LocalDate
import Models
import SharedUI
import SwiftUI

public struct AstronomyPictureView: View {
    @Bindable var store: StoreOf<AstronomyPictureReducer>
    
    public init(store: StoreOf<AstronomyPictureReducer>) {
        self.store = store
    }
    
    public var body: some View {
        Group {
            if let error = store.error {
                ErrorView(
                    error: Text(error),
                    retry: { store.send(.retryButtonTapped) },
                )
                .padding()
            } else if let picture = store.picture {
                AstronomyPictureContentView(
                    isFullScreenImagePresented: $store.isFullScreenImagePresented,
                    picture: picture,
                )
            } else {
                AstronomyPictureContentView(
                    isFullScreenImagePresented: $store.isFullScreenImagePresented,
                    picture: .placeholder,
                )
                .redacted(reason: .placeholder)
            }
        }
        .navigationTitle(Text(store.date.description))
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            store.send(.onAppear)
        }
    }
}

private extension AstronomyPicture {
    static let placeholder = Self(
        date: .init(),
        explanation: "placeholder explanation",
        mediaType: .image,
        title: "placeholder title",
    )
}
