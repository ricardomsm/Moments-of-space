import Dependencies
import Foundation

struct LocationsAwareMeditationsService {
	let getLocationAwareMeditations: (
		_ latitude: Double?,
		_ longitude: Double?
	) async throws -> [LocationsAwareMeditations]
}

extension LocationsAwareMeditationsService {
	static var live: Self {
		.init(
			getLocationAwareMeditations: { lat, lon in
				try await Task.sleep(for: .seconds(2))
				let responseData = try Data(
					contentsOf: Endpoint.getLocationAwareMeditations(latitude: lat, longitude: lon).url
				)
				
				return try JSONDecoder().decode([LocationsAwareMeditations].self, from: responseData)
			}
		)
	}

	func getLocationAwareMeditations(
		latitude: Double? = nil,
		longitude: Double? = nil
	) async throws -> [LocationsAwareMeditations] {
		try await getLocationAwareMeditations(latitude, longitude)
	}
}

// MARK: - Dependency registry
extension LocationsAwareMeditationsService: DependencyKey {
	static let liveValue = LocationsAwareMeditationsService.live
}

extension DependencyValues {
	var locationsAwareMeditationsService: LocationsAwareMeditationsService {
		get { self[LocationsAwareMeditationsService.self] }
		set { self[LocationsAwareMeditationsService.self] = newValue }
	}
}
