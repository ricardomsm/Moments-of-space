import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif
import Networking

enum Endpoint {
	case getLocationAwareMeditations(latitude: Double? = nil, longitude: Double? = nil)

	static let meditationsJsonUrl = Bundle.module.url(forResource: "MeditationsResponse", withExtension: "json")

	var url: URL {
		switch self {
		case .getLocationAwareMeditations:
			guard let url = Self.meditationsJsonUrl else { fatalError("🔥 Unable to parse local url!") }
			return url
		}
	}

	var path: String {
		switch self {
		case .getLocationAwareMeditations:
			return "forecast"
		}
	}

	var requestMethod: RequestMethod {
		switch self {
		case .getLocationAwareMeditations:
			return .get
		}
	}

	var queryItems: [URLQueryItem]? {
		switch self {
		case let .getLocationAwareMeditations(latitude?, longitude?):
			return [.init(queryParam: .latitude(latitude)), .init(queryParam: .longitude(longitude))]
		case .getLocationAwareMeditations:
			return nil
		}
	}
}

extension Endpoint {
	enum QueryParameters: RawRepresentable {
		case latitude(Double)
		case longitude(Double)

		init?(rawValue: String) {
			switch rawValue {
			case "lat":
				self = .latitude(0)
			case "lon":
				self = .longitude(0)
			default:
				return nil
			}
		}

		var rawValue: String {
			switch self {
			case .latitude:
				return "lat"
			case .longitude:
				return "lon"
			}
		}
	}
}

extension URLQueryItem {
	init(queryParam: Endpoint.QueryParameters) {
		let name = queryParam.rawValue

		switch queryParam {
		case .latitude(let latitude):
			self = .init(name: name, value: String(latitude))
		case .longitude(let longitude):
			self = .init(name: name, value: String(longitude))
		}
	}
}
