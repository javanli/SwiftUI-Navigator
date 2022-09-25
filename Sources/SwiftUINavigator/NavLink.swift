//
//  NavLink.swift
//
//
//  Created by lijunfan on 2022/8/19.
//
import SwiftUI


public struct NavLink<Content: View>: View {

	@EnvironmentObject private var navigator: Navigator
    @EnvironmentObject private var navigationState : NavigationState
	
	private let content: (Bool) -> Content
	private let sceneName: String
	private let replace: Bool
	
	public init(
		to sceneName: String,
		replace: Bool = false,
		@ViewBuilder content: @escaping (Bool) -> Content
	) {
		self.sceneName = sceneName
		self.replace = replace
		self.content = content
	}
	

	private func onPressed() {
        navigator.navigate(sceneName, replace: replace)
	}
	
	public var body: some View {
		let active = navigationState.sceneName == sceneName
		
		return Button(action: onPressed) {
			content(active)
		}
	}
}
