import ComposableArchitecture
import Models
import SharedUI
import SwiftUI

struct AstronomyPictureListView: View {
    let store: StoreOf<AstronomyPictureList>
    
    var body: some View {
        List {
            if let error = store.error {
                Section(
                    header: ErrorView(
                        error: Text(error),
                        retry: { store.send(.retryButtonTapped) },
                    )
                ) {}
            } else {
                content
            }
        }
        .onAppear {
            store.send(.onAppear)
        }
        .navigationTitle(.init("Astronomy Pictures"))
        .navigationBarTitleDisplayMode(.inline)
    }
    
    @ViewBuilder
    private var content: some View {
        ForEach(
            store.isLoading ? AstronomyPicture.placeholderList : store.pictures,
            id: \.date.description,
        ) { picture in
            NavigationLink {
                AstronomyPictureDetailView(picture: picture)
                    .navigationTitle(.init(picture.date.description))
                    .navigationBarTitleDisplayMode(.inline)
            } label: {
                VStack(alignment: .leading) {
                    Text(picture.date.description)
                        .font(.callout)
                        .foregroundStyle(Color.gray)
                    Text(picture.title)
                }
            }
            .disabled(!store.isLoaded)
        }
        .redacted(reason: store.isLoading ? .placeholder : [])
    }
}

private extension AstronomyPicture {
    static let placeholderList: [AstronomyPicture] = (0...10).map {
        .init(
            date: .init(year: 2025, month: 1, day: 1).addingMonths($0),
            explanation: "",
            mediaType: .image,
            title: String(repeating: " ", count: .random(in: 10...50)),
        )
    }
}
