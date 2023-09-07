import ComposableArchitecture
import SwiftUI

public struct LocationsAwareMeditationsView: View {
	private let store: StoreOf<LocationsAwareMeditationsReducer>

	public init() {
		self.init(store: .init(initialState: .loading, reducer: LocationsAwareMeditationsReducer.init))
	}

	init(store: StoreOf<LocationsAwareMeditationsReducer>) { self.store = store }

	private func meditationCell(_ meditation: LocationsAwareMeditations) -> some View {
		HStack(spacing: 0) {
			VStack(alignment: .leading, spacing: 10) {
				Text(meditation.title)
					.font(.title2)

				Text(meditation.subtitle)
					.foregroundColor(.gray)
			}

			Spacer()

			ZStack(alignment: .center) {
				Image("ripple", bundle: .module)
					.resizable()
					.frame(width: 100, height: 100)

				Text("\(meditation.totalMinutes) min")
					.foregroundColor(.gray)
					.fontWeight(.bold)
			}
		}
		.padding(.leading, 8)
		.background { Color.gray.opacity(0.1) }
		.frame(height: 100)
		.clipShape(RoundedRectangle(cornerRadius: 16))
	}


	// Due to time some of the colors aren't a match, definitely need a color picker app 🥲.
	public var body: some View {
		NavigationStack {
			ZStack {
				Color.white.edgesIgnoringSafeArea(.all)

				SwitchStore(store) { state in
					switch state {
					case .loading:
						ProgressView()
							.progressViewStyle(.circular)
					case .empty:
						Text("No meditations for your place and time 🧘🏻‍♂️")
					case .error:
						Text("Something unexpected ocorred 🙈!")
					case .results(let results):
						ScrollView(showsIndicators: false) {
							ForEach(results, id: \.self) { meditation in
								meditationCell(meditation)
							}
							.padding(.horizontal, 16)
						}
						.padding(.top, 16)
					}
				}
			}
			.toolbar {
				ToolbarItem(placement: .navigationBarLeading) {
					Text("Meditations")
						.font(.largeTitle)
						.foregroundStyle(LinearGradient(colors: [.pink, .cyan], startPoint: .leading, endPoint: .trailing))
					// Magic padding number to avoid UINavigationBar appearance magicks 🔨🔮, may break on other devices 🥲
						.padding(.top, 80)
				}
				

				ToolbarItem(placement: .navigationBarTrailing) {
					Button(action: { store.send(.view(.locationButtonWasTapped)) }) {
						Image(systemName: "location.circle")
							.renderingMode(.template)
							.resizable()
							.foregroundColor(.gray)
							.frame(width: 40, height: 40)
					}
				}
			}
			.navigationBarTitleDisplayMode(.large)
		}
		.task { store.send(.view(.onAppear)) }
	}
}

private extension LocationsAwareMeditations {
	var totalMinutes: Int { audioFiles.map(\.durationInSeconds).reduce(0, +).toMinutes }
}

private extension Int {
	var toMinutes: Self { (self % 3600) / 60 }
}

// MARK: - Previews
#if DEBUG
struct SwiftUIView_Previews: PreviewProvider {
    static var previews: some View {
		LocationsAwareMeditationsView(
			store: .init(
				initialState: .results(
					[
						.init(id: 1, audioFiles: [], title: "Cenas", subtitle: "cenas", description: ""),
						.init(id: 1, audioFiles: [], title: "Cenas", subtitle: "cenas", description: ""),
						.init(id: 1, audioFiles: [], title: "Cenas", subtitle: "cenas", description: "")
					]
				),
				reducer: LocationsAwareMeditationsReducer.init
			)
		)
    }
}
#endif
