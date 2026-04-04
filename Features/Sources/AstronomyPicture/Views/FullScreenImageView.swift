import SwiftUI

struct FullScreenImageView: View {
    let closeButtonTapped: () -> Void
    let hdImageURL: URL?
    let image: Image
    
    var body: some View {
        ZStack {
            if let hdImageURL {
                AsyncImage(url: hdImageURL) { phase in
                    switch phase {
                    case .empty, .failure:
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .overlay {
                                ProgressView()
                            }
                    case let .success(image):
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                    @unknown default:
                        Text("Unexpected error occurred", bundle: .module)
                    }
                }
            } else {
                image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            }
            
            VStack {
                HStack {
                    Spacer()
                    
                    Button(action: closeButtonTapped) {
                        Image(systemName: "xmark")
                            .foregroundColor(.primary)
                    }
                    .padding()
                }
                
                Spacer()
            }
        }
    }
}

struct FullScreenImageView_Previews: PreviewProvider {
    static var previews: some View {
        FullScreenImageView(
            closeButtonTapped: {},
            hdImageURL: nil,
            image: Image(systemName: "photo"),
        )
    }
}
