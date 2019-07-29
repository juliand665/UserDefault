// Created by Julian Dunskus

import Foundation

private let encoder = JSONEncoder()
private let decoder = JSONDecoder()
public extension IndirectDefaultsValueConvertible where Self: Codable {
	static func decodeValue(from raw: Data) throws -> Self {
		return try decoder.decode(Self.self, from: raw)
	}
	
	func encode() throws -> Data {
		return try encoder.encode(self)
	}
}
