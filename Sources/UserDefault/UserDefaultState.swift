#if canImport(SwiftUI)
import SwiftUI

extension UserDefault {
	/// lightweight wrapper to ease the composition of `@State` with `@UserDefault`
	@available(iOS 13, macOS 10.15, tvOS 13, watchOS 6, *)
	@propertyWrapper
	public struct State: DynamicProperty {
		@SwiftUI.State @UserDefault public var wrappedValue: Value
		
		public var projectedValue: Binding<Value> {
			$wrappedValue[dynamicMember: \.wrappedValue]
		}
		
		private init(inner: UserDefault<Value>) {
			_wrappedValue = .init(wrappedValue: inner)
		}
		
		public init(wrappedValue: Value, _ key: String) {
			self.init(inner: UserDefault(wrappedValue: wrappedValue, key))
		}
		
		public init(_ key: String) where Value: ExpressibleByNilLiteral {
			self.init(wrappedValue: nil, key)
		}
	}
}
#endif
