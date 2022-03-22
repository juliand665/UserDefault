#if canImport(SwiftUI)
import SwiftUI

extension UserDefault {
	/// lightweight wrapper to ease the composition of `@State` with `@UserDefault`
	@available(iOS 13, macOS 10.15, tvOS 13, watchOS 6, *)
	@propertyWrapper
	struct State: DynamicProperty {
		@SwiftUI.State @UserDefault var wrappedValue: Value
		
		var projectedValue: Binding<Value> {
			$wrappedValue[dynamicMember: \.wrappedValue]
		}
		
		private init(inner: UserDefault<Value>) {
			_wrappedValue = .init(wrappedValue: inner)
		}
		
		init(wrappedValue: Value, _ key: String) {
			self.init(inner: UserDefault(wrappedValue: wrappedValue, key))
		}
		
		public init<T>(_ key: String) where Value == T? {
			self.init(inner: UserDefault(key))
		}
	}
}
#endif
