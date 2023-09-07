import ComposableArchitecture
import XCTest
@testable import LocationAwareMeditationsFeature

@MainActor
final class LocationsAwareMeditationsReducerTests: XCTestCase {
    func testOnAppear_WhenErrorOccursLoadingMeditations_ShouldHaveValidState() async {
		let getLocationAwareMeditationsExpectation = expectation(description: "getLocationAwareMeditationsExpectation")
		defer { waitForExpectations(timeout: 1) }

		let store = TestStore(
			initialState: .loading,
			reducer: LocationsAwareMeditationsReducer.init,
			withDependencies: {
				$0.locationsAwareMeditationsService = .mock(
					getLocationAwareMeditations: { _,_ in
						getLocationAwareMeditationsExpectation.fulfill()
						throw NSError(domain: "", code: 500)
					}
				)
			}
		)

		await store.send(.view(.onAppear))

		await store.receive(.errorFetchingLocationAwareMeditations) { $0 = .error }
    }
}
