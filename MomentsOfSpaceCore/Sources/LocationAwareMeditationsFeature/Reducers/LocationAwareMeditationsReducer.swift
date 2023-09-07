import ComposableArchitecture

struct LocationsAwareMeditationsReducer: Reducer {
	enum State: Equatable {
		case empty
		case loading
		case error
		case results([LocationsAwareMeditations])
	}

	enum Action: Equatable {
		// I normally enforce this boundary with the use of a protocol conformance.
		enum ViewAction: Equatable {
			case onAppear
			case locationButtonWasTapped
		}

		case view(ViewAction)
		case fetchLocationAwareMeditations([LocationsAwareMeditations])
		case errorFetchingLocationAwareMeditations
		case locationDelegate(LocationService.Delegate.Event)
	}

	@Dependency(\.locationService) private var locationService
	@Dependency(\.locationsAwareMeditationsService) private var  locationsAwareMeditationsService

	var body: some ReducerOf<Self> {
		Reduce { state, action in
			switch action {
			case .view(.onAppear):
				return getMeditations()

			case .locationDelegate(.locationsDidUpdate):
				state = .loading
				return getMeditations()

			case .fetchLocationAwareMeditations(let meditations):
				state = meditations.isEmpty ? .empty : .results(meditations)
				return .none

			case .errorFetchingLocationAwareMeditations:
				state = .error
				return .none

			case .view(.locationButtonWasTapped):
				return .run { send in
					locationService.requestLocationPermitions()
					locationService.triggerLocationUpdates()

					for try await event in locationService.delegate() {
						await send(.locationDelegate(event))
					}
				}
			}
		}
	}

	private func getMeditations() -> EffectOf<Self> {
		.run(
			operation: { send in
				let meditations = try await locationsAwareMeditationsService.getLocationAwareMeditations()
				await send(.fetchLocationAwareMeditations(meditations))
			},
			// Log some type of error here or above on the chain
			catch: { _, send in await send(.errorFetchingLocationAwareMeditations) }
		)
	}
}
