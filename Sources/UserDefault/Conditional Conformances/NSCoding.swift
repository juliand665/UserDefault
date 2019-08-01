import Foundation

// TODO: find way to make this work before iOS 11 without using deprecated methods
@available(OSX 10.13, *)
@available(iOS 11.0, *)
public extension DefaultsValueConvertible where Self: NSObject & NSCoding {
	func defaultsRepresentation() throws -> Data {
		return try NSKeyedArchiver.archivedData(withRootObject: self, requiringSecureCoding: false)
	}
	
	init(defaultsRepresentation: Data) throws {
		self = try NSKeyedUnarchiver.unarchivedObject(ofClass: Self.self, from: defaultsRepresentation)
			??? DefaultsError.illegalValue(found: defaultsRepresentation, for: Self.self)
	}
}
