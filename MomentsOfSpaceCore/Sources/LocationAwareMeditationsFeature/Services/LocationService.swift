import CoreLocation
import Dependencies

struct LocationService {
	let delegate: () -> AsyncStream<Delegate.Event>
	let triggerLocationUpdates: () -> Void
	let requestLocationPermitions: () -> Void
}

extension LocationService {
	final class Delegate: NSObject, CLLocationManagerDelegate {
		enum Event: Equatable {
			case locationsDidUpdate([CLLocation])
		}

		var continuation: AsyncStream<Event>.Continuation?

		init(continuation: AsyncStream<Event>.Continuation? = nil) {
			self.continuation = continuation
		}

		func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
			continuation?.yield(.locationsDidUpdate(locations))
		}

		// No time ⏰
		func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
			switch manager.authorizationStatus {
			case .authorizedAlways:
				break
			case .notDetermined:
				break
			case .restricted:
				break
			case .denied:
				break
			case .authorizedWhenInUse:
				break
			@unknown default:
				break
			}
		}
	}

	// Still working this pattern out,requesting updates should be only be done after getting authorization
	static func live(locationManager: CLLocationManager = .init()) -> Self {
		.init(
			delegate: {
				AsyncStream<Delegate.Event> {
					let delegate = Delegate(continuation: $0)
					locationManager.delegate = delegate
					$0.onTermination = { [delegate] _ in _ = delegate }
				}
			},
			triggerLocationUpdates: { locationManager.startUpdatingLocation() },
			requestLocationPermitions: { locationManager.requestWhenInUseAuthorization() }
		)
	}
}

// MARK: - Dependency registry
extension LocationService: DependencyKey {
	static let liveValue = LocationService.live()
}

extension DependencyValues {
	var locationService: LocationService {
		get { self[LocationService.self] }
		set { self[LocationService.self] = newValue }
	}
}
