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
	
	var body: some View {
		VStack {
			Circle()
				.fill(self.circleColor)
				.animation(.linear)
				.frame(width: 50, height: 50)
				.scaleEffect(self.isCircleScaled ? 2 : 1) // the order is important
				.offset(
					x: self.circleCenter.x - 25, // to make it snap to the middle substract half of the diameter
					y: self.circleCenter.y - 25
				)
				// .animation(.default)
				// .animation(.linear)
				// .animation(.easeIn)
				.animation(.spring(response: 0.3, dampingFraction: 0.1))
				.gesture(
					DragGesture(minimumDistance: 0)
						.onChanged { value in
							self.circleCenter = value.location
						}
				)
			
			Toggle("Scale", isOn: self.$isCircleScaled)
				.padding(.horizontal)
			Button("Circle Colors") {
				// self.circleColor = .red
				[Color.red, .blue, .green, .purple, .black]
					.enumerated()
					.forEach { offset, color in
						DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(offset)) {
							self.circleColor = color
						}
					}
//				DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
//					self.circleColor = .blue
//				}
//				DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
//					self.circleColor = .green
//				}
//				DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
//					self.circleColor = .purple
//				}
//				DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
//					self.circleColor = .black
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
