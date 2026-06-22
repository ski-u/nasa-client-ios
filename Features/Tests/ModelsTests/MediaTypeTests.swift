import Testing

@testable import Models

@MainActor
struct MediaTypeTests {
    @Test
    func initFromString() {
        #expect(MediaType(string: "image") == .image)
        #expect(MediaType(string: "video") == .video)
        #expect(MediaType(string: "other") == .other)
        #expect(MediaType(string: "unknown") == .unknown)
    }
}
