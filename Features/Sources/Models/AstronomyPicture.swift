import Foundation
import LocalDate

public struct AstronomyPicture: Equatable, Sendable {
    public var copyright: String?
    public var date: LocalDate
    public var explanation: String
    public var hdURL: URL?
    public var mediaType: MediaType
    public var title: String
    public var url: URL?
    
    public init(
        copyright: String? = nil,
        date: LocalDate,
        explanation: String,
        hdURL: URL? = nil,
        mediaType: MediaType,
        title: String,
        url: URL? = nil,
    ) {
        self.copyright = copyright
        self.date = date
        self.explanation = explanation
        self.hdURL = hdURL
        self.mediaType = mediaType
        self.title = title
        self.url = url
    }
    
    public init(payload: Payload) {
        self.init(
            copyright: payload.copyright,
            date: try! LocalDate(from: payload.date),
            explanation: payload.explanation,
            hdURL: payload.hdURL.map { URL(string: $0)! },
            mediaType: MediaType(string: payload.mediaType),
            title: payload.title,
            url: payload.url.map { URL(string: $0)! },
        )
    }
}

extension AstronomyPicture {
    public struct Payload: Decodable {
        public var copyright: String?
        public var date: String
        public var explanation: String
        public var hdURL: String?
        public var mediaType: String
        public var title: String
        public var url: String?
        
        public init(
            copyright: String? = nil,
            date: String,
            explanation: String,
            hdURL: String? = nil,
            mediaType: String,
            title: String,
            url: String? = nil,
        ) {
            self.copyright = copyright
            self.date = date
            self.explanation = explanation
            self.hdURL = hdURL
            self.mediaType = mediaType
            self.title = title
            self.url = url
        }
        
        enum CodingKeys: String, CodingKey {
            case copyright
            case date
            case explanation
            case hdURL = "hdurl"
            case mediaType = "media_type"
            case title
            case url
        }
    }
}
