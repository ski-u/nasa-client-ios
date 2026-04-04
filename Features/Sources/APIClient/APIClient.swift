import Dependencies
import DependenciesMacros
import Models

@DependencyClient
public struct APIClient: Sendable {
    public var fetchAstronomyPictures: @Sendable () async throws -> [AstronomyPicture]
    public var fetchGeomagneticStorms: @Sendable (_ days: Int) async throws -> [GeomagneticStorm]
    public var fetchTodayPicture: @Sendable () async throws -> AstronomyPicture
}

extension APIClient: TestDependencyKey {
    public static let testValue = Self()
    
    public static var mockValue: Self {
        return .init(
            fetchAstronomyPictures: {
                try await Task.sleep(for: .seconds(2))
                return [.mock]
            },
            fetchGeomagneticStorms: { _ in
                try await Task.sleep(for: .seconds(2))
                return [.mock]
            },
            fetchTodayPicture: {
                try await Task.sleep(for: .seconds(2))
                return .mock
            },
        )
    }
}

public extension DependencyValues {
    var apiClient: APIClient {
        get { self[APIClient.self] }
        set { self[APIClient.self] = newValue }
    }
}

private extension AstronomyPicture {
    static let mock = Self(
        copyright: "Bray FallsKeith Quattrocchi",
        date: .init(year: 2012, month: 7, day: 12),
        explanation:
            "What will become of our Sun? The first hint of our Sun's future was discovered inadvertently in 1764. At that time, Charles Messier was compiling a list of diffuse objects not to be confused with comets. The 27th object on Messier's list, now known as M27 or the Dumbbell Nebula, is a planetary nebula, one of the brightest planetary nebulae on the sky -- and visible toward the constellation of the Fox (Vulpecula) with binoculars. It takes light about 1000 years to reach us from M27, featured here in colors emitted by hydrogen and oxygen. We now know that in about 6 billion years, our Sun will shed its outer gases into a planetary nebula like M27, while its remaining center will become an X-ray hot white dwarf star.  Understanding the physics and significance of M27 was well beyond 18th century science, though. Even today, many things remain mysterious about planetary nebulas, including how their intricate shapes are created.",
        hdURL: .init(
            string: "https://apod.nasa.gov/apod/image/2107/M27_Falls_3557.jpg"
        )!,
        mediaType: .image,
        title: "M27: The Dumbbell Nebula",
        url: .init(string: "https://apod.nasa.gov/apod/image/2107/M27_Falls_960.jpg")!,
    )
}

private extension GeomagneticStorm {
    static let mock = Self(
        id: "2026-02-20T00:00:00-GST-001",
        startTime: "2026-02-20T00:00Z",
        maxKpIndex: 5.33,
    )
}
