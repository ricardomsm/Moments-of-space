import Foundation

struct LocationsAwareMeditations: Decodable, Hashable, Identifiable {
	let id: Int
	let audioFiles: [AudioFile]
	let title: String
	let subtitle: String
	let description: String

	enum CodingKeys: String, CodingKey {
		case id, title, subtitle, description
		case audioFiles = "audio_files"
	}
}

extension LocationsAwareMeditations {
	struct AudioFile: Decodable, Hashable, Identifiable {
		let id: Int
		let name: String
		let audioUrl: String
		let version: String
		let durationInSeconds: Int

		enum CodingKeys: String, CodingKey {
			case id, name, version
			case audioUrl = "audio"
			case durationInSeconds = "duration_seconds"
		}
	}
}
