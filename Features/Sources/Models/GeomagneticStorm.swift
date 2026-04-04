public struct GeomagneticStorm: Equatable, Sendable, Identifiable {
    public var id: String
    public var startTime: String
    public var maxKpIndex: Double
    
    public init(
        id: String,
        startTime: String,
        maxKpIndex: Double,
    ) {
        self.id = id
        self.startTime = startTime
        self.maxKpIndex = maxKpIndex
    }
    
    public init(payload: Payload) {
        self.init(
            id: payload.gstID,
            startTime: payload.startTime,
            maxKpIndex: payload.allKpIndex.map(\.kpIndex).max() ?? 0,
        )
    }
}

extension GeomagneticStorm {
    public struct Payload: Decodable {
        public var gstID: String
        public var startTime: String
        public var allKpIndex: [KpIndex]
        
        public init(
            gstID: String,
            startTime: String,
            allKpIndex: [KpIndex],
        ) {
            self.gstID = gstID
            self.startTime = startTime
            self.allKpIndex = allKpIndex
        }
        
        public struct KpIndex: Decodable {
            public var kpIndex: Double
            
            public init(kpIndex: Double) {
                self.kpIndex = kpIndex
            }
        }
    }
}
