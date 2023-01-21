import ComposableArchitecture
import SwiftUI

struct AppFeature: ReducerProtocol {
	
	struct State: Equatable {
		var circleCenter = CGPoint.zero
		var circleColor = Color.black
		var isCircleScaled = false
	}
	
	enum Action: Equatable {
		case cycleColorsButtonTapped
		case dragGesture(CGPoint)
		case resetButtonTapped
		case setCircleColor(Color)
		case toggleScale(isOn: Bool)
	}
	
	var body: some ReducerProtocol<State, Action> {
		Reduce { state, action in
			switch action {
			case .cycleColorsButtonTapped:
				state.circleColor = .red
				
				// when we merge effects, the all run at the same time,
				// when we concatenate effects, it makes sure the next one only run when the previous one completes
				return .concatenate(
					[Color.blue, .green, .purple, .black]
						.map { color in
								.task {
									.setCircleColor(color)
								}
								.delay(for: .seconds(1), scheduler: DispatchQueue.main.animation(.linear))
							 .eraseToEffect()
						}
//					.task {
//						.setCircleColor(.blue)
//					}
//				 .delay(for: .seconds(1), scheduler: DispatchQueue.main)
//				 .eraseToEffect(),
//
//					.task {
//						.setCircleColor(.green)
//					}
//				 .delay(for: .seconds(1), scheduler: DispatchQueue.main)
//				 .eraseToEffect(),
//
//					.task {
//						.setCircleColor(.purple)
//					}
//				 .delay(for: .seconds(1), scheduler: DispatchQueue.main)
//				 .eraseToEffect(),
//
//
//					.task {
//						.setCircleColor(.black)
//					}
//				 .delay(for: .seconds(1), scheduler: DispatchQueue.main)
//				 .eraseToEffect()
				)
			
			case let .dragGesture(location):
				state.circleCenter = location
				return .none
			
			case .resetButtonTapped:
				state = State()
				return .none
				
			case let .setCircleColor(color):
				state.circleColor = color
				return .none
			
			case .toggleScale(isOn: let isOn):
				state.isCircleScaled = isOn
				return .none
			}
		}
	}
}

struct TCAContentView: View {
	
	let store: StoreOf<AppFeature>
	@ObservedObject var viewStore: ViewStoreOf<AppFeature>
	
	init(store: StoreOf<AppFeature>) {
		self.store = store
		self.viewStore = ViewStore(store)
	}
	
	var body: some View {
		VStack {
			Circle()
				.fill(self.viewStore.circleColor)
				.frame(width: 50, height: 50)
				.scaleEffect(self.viewStore.isCircleScaled ? 2 : 1)
				.offset(
					x: self.viewStore.circleCenter.x - 25,
					y: self.viewStore.circleCenter.y - 25
				)
				.gesture(
					DragGesture(minimumDistance: 0)
						.onChanged { value in
							self.viewStore.send(.dragGesture(value.location), animation: (.spring(response: 0.3, dampingFraction: 0.1)))
						}
				)
			
			Toggle(
				"Scale",
				isOn: self.viewStore.binding(
					get: \.isCircleScaled,
					send: AppFeature.Action.toggleScale(isOn:)
				)
				.animation(.spring(response: 0.3, dampingFraction: 0.1))
			)
				.padding(.horizontal)
			
			Button("Circle Colors") {
				self.viewStore.send(.cycleColorsButtonTapped)
			}

			Button("Reset") {
				self.viewStore.send(.resetButtonTapped, animation: .default)
			}
		}
	}
}

struct TCAContentView_Previews: PreviewProvider {
	static var previews: some View {
		TCAContentView(store: .init(initialState: .init(), reducer: AppFeature()))
	}
}
