// https://stackoverflow.com/a/67853022/3213030
#if canImport(SwiftUI) && !arch(arm) // swiftui is weird about 32-bit arm; need this for release builds
import SwiftUI

// TODO: could probably use environment to accept defaults suite; would have to use update() method to apply it i think

extension UserDefault {
	/// lightweight wrapper to ease the composition of `@State` with `@UserDefault`
	@available(iOS 13, macOS 10.15, tvOS 13, watchOS 6, *)
	@propertyWrapper
	public struct State: DynamicProperty {
		// stored explicitly rather than as `@SwiftUI.State @UserDefault var wrappedValue`,
		// since newer SDKs implement `@State` as a macro, which can't be composed with other property wrappers
		private var state: SwiftUI.State<UserDefault<Value>>

		public var wrappedValue: Value {
			get { state.wrappedValue.wrappedValue }
			nonmutating set { state.wrappedValue.wrappedValue = newValue }
		}

		public var projectedValue: Binding<Value> {
			state.projectedValue[dynamicMember: \.wrappedValue]
		}

		private init(inner: UserDefault<Value>) {
			state = .init(wrappedValue: inner)
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
