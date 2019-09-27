import Foundation

public extension DefaultsValueConvertible where Self: NSObject & NSCoding {
	func defaultsRepresentation() throws -> Data {
		if #available(macOS 10.13, iOS 11.0, tvOS 11.0, watchOS 4.0, *) {
			return try NSKeyedArchiver.archivedData(withRootObject: self, requiringSecureCoding: false)
		} else {
			return NSKeyedArchiver.archivedData(withRootObject: self)
		}
	}
	
	init(defaultsRepresentation: Data) throws {
		let object: Self?
		if #available(macOS 10.13, iOS 11.0, tvOS 11.0, watchOS 4.0, *) {
			object = try NSKeyedUnarchiver.unarchivedObject(ofClass: Self.self, from: defaultsRepresentation)
		} else {
			object = NSKeyedUnarchiver.unarchiveObject(with: defaultsRepresentation) as? Self
		}
		
		self = try object ??? DefaultsError.illegalValue(found: defaultsRepresentation, for: Self.self)
	}
}
