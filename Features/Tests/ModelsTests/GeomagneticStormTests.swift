import Testing

@testable import Models

struct GeomagneticStormTests {
    @Test
    func initFromPayload() {
        let payload = GeomagneticStorm.Payload(
            gstID: "id",
            startTime: "2026-02-20T00:00Z",
            allKpIndex: [
                .init(kpIndex: 2.0),
                .init(kpIndex: 4.0),
                .init(kpIndex: 6.0),
            ],
        )
        
        let model = GeomagneticStorm(payload: payload)
        
        #expect(model.id == "id")
        #expect(model.startTime == "2026-02-20T00:00Z")
        #expect(model.maxKpIndex == 6.0)
    }
    
    @Test
    func initFromPayloadWithoutKp() {
        let payload = GeomagneticStorm.Payload(
            gstID: "id",
            startTime: "2026-02-20T00:00Z",
            allKpIndex: [],
        )
        
        let model = GeomagneticStorm(payload: payload)
        
        #expect(model.maxKpIndex == 0)
    }
}
