//
//  Router.swift
//
//
//  Created by lijunfan on 2022/8/19.
//
import Combine
import SwiftUI

private struct RouterWrapper<Content : View> : View {
    @EnvironmentObject private var navigationState : NavigationState
    private var content : () -> Content

    public init(@ViewBuilder content: @escaping () -> Content) {
        self.content = content
    }
    public var body: some View {
        ZStack {
            ForEach(0..<navigationState.historyStack.count, id:\.self){ index in
                let sceneState = navigationState.historyStack[index]
                sceneState.content(defaultBuilder: {
                    AnyView(content())
                })
                .allowsHitTesting(index == navigationState.historyStack.count - 1)
                .swipeableBack(isLastPage: index == navigationState.historyStack.count - 1)
                .environmentObject(sceneState)
                .environmentObject(sceneState.transitionState)
                .environmentObject(navigationState.fakeState(index: index))
                
            }
        }
    }
}
public struct Router<Content : View> : View {
    private let navigator : Navigator
    private var content : () -> Content

	public init(initialName: String,
                @ViewBuilder content: @escaping () -> Content) {
        navigator = Navigator(initialName: initialName)
        self.content = content
	}
    public init(navigator: Navigator,
                @ViewBuilder content: @escaping () -> Content) {
        self.navigator = navigator
        self.content = content
    }
	public var body: some View {
        RouterWrapper {
            content()
        }
        .environmentObject(navigator)
        .environmentObject(navigator.state)
	}
}
