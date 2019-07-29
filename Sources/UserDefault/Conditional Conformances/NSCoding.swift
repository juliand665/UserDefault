// Created by Julian Dunskus

import Foundation

// TODO: find way to make this work before iOS 11 without using deprecated methods
@available(OSX 10.13, *)
@available(iOS 11.0, *)
public extension IndirectDefaultsValueConvertible where Self: NSObject & NSCoding {
	func encode() throws -> Data {
		return try NSKeyedArchiver.archivedData(withRootObject: self, requiringSecureCoding: false)
	}
	
	static func decodeValue(from raw: Data) throws -> Self {
		return try NSKeyedUnarchiver.unarchivedObject(ofClass: Self.self, from: raw) ??? DefaultsError.missingValue
	}
}
