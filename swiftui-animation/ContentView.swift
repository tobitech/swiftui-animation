//
//  ContentView.swift
//  swiftui-animation
//
//  Created by Oluwatobi Omotayo on 20/01/2023.
//

import SwiftUI

struct ContentView: View {
	
	@State var circleCenter = CGPoint.zero
	@State var circleColor = Color.black
	@State var isCircleScaled = false
	@State var isResetting = false
	
	var body: some View {
		VStack {
			Circle()
				.fill(self.circleColor)
				// .animation(.linear)
				.frame(width: 50, height: 50)
				.scaleEffect(self.isCircleScaled ? 2 : 1) // the order is important
				// .animation(.easeInOut) // the order of animation modifier doesn't always work. Somehow this overrides the sprint animation for the offset below
				// .animation(nil, value: self.isCircleScaled) // to remove animation for a property
				.offset(
					x: self.circleCenter.x - 25, // to make it snap to the middle substract half of the diameter
					y: self.circleCenter.y - 25
				)
				// .animation(self.isResetting ? nil : .spring(response: 0.3, dampingFraction: 0.1), value: self.circleCenter)
				.gesture(
					DragGesture(minimumDistance: 0)
						.onChanged { value in
							withAnimation(.spring(response: 0.3, dampingFraction: 0.1)) {
								self.circleCenter = value.location
							}
						}
				)
			
			Toggle(
				"Scale",
				isOn: self.$isCircleScaled.animation(.spring(response: 0.3, dampingFraction: 0.1))
//				isOn: .init(
//					get: { self.isCircleScaled },
//					set: { isOn in
//						withAnimation(.spring(response: 0.3, dampingFraction: 0.1)) {
//							self.isCircleScaled = isOn
//						}
//					}
//				)
			)
				.padding(.horizontal)
			
			Button("Circle Colors") {
				// self.circleColor = .red
				[Color.red, .blue, .green, .purple, .black]
					.enumerated()
					.forEach { offset, color in
						DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(offset)) {
							withAnimation(.linear) {
								self.circleColor = color
							}
							
							// withAnimation: (() -> R) -> R
						}
					}
			}
			
			// showing the limitations of implicit animations here.
			// the animations are batched in one transaction
			// without the asyncAfter delay, isResetting won't affect the animation.
			// implicit animations are an untargetted way of performing animations.
			// with explicit animations we just don't have to do anything when we change the values
			// and we can wrap the value changes in withAnimation if we want reset to happen with a targetted animation and you can even move some changes out of the block.
			Button("Reset") {
				// self.isResetting = true
				withAnimation {
					self.circleCenter = .zero
					self.circleColor = .black
				}
				self.isCircleScaled = false
//				DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1)) {
//					self.isResetting = false
//				}
			}
		}
	}
}

struct ContentView_Previews: PreviewProvider {
	static var previews: some View {
		ContentView()
	}
}
