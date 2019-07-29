// Created by Julian Dunskus

import Foundation

private let encoder = JSONEncoder()
private let decoder = JSONDecoder()
public extension DirectDefaultsValueConvertible where Self: Codable {
	init(defaultsRepresentation: Data) throws {
		self = try decoder.decode(Self.self, from: defaultsRepresentation)
	}
	
	func defaultsRepresentation() throws -> Data {
		return try encoder.encode(self)
	}
}
