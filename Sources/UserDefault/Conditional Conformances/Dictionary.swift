// Created by Julian Dunskus

import Foundation

extension Dictionary: DefaultsValue where Key == String, Value: DefaultsValue {}

extension Dictionary: DefaultsValueConvertible where
	Key: DefaultsValueConvertible, Key.DefaultsRepresentation == String,
	Value: DefaultsValueConvertible
{
	public typealias DefaultsRepresentation = [String: Value.DefaultsRepresentation]
	
	public init(defaultsRepresentation: DefaultsRepresentation) throws {
		let converted = try defaultsRepresentation.map {
			try (Key(defaultsRepresentation: $0.key), Value(defaultsRepresentation: $0.value))
		}
		self.init(uniqueKeysWithValues: converted)
	}
	
	public func defaultsRepresentation() throws -> DefaultsRepresentation {
		let raw = try self.map { (try $0.key.defaultsRepresentation(), try $0.value.defaultsRepresentation()) }
		return .init(uniqueKeysWithValues: raw)
	}
}
