//
//  ContentView.swift
//  swiftui-animation
//
//  Created by Oluwatobi Omotayo on 20/01/2023.
//

import SwiftUI

struct ContentView: View {
	
	@State var circleCenter = CGPoint.zero
	@State var isCircleScaled = false
	
	var body: some View {
		VStack {
			Circle()
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
		}
	}
}

struct ContentView_Previews: PreviewProvider {
	static var previews: some View {
		ContentView()
	}
}
