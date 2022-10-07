//
//  NavScene.swift
//
//
//  Created by lijunfan on 2022/8/19.
//

import SwiftUI

public struct NavScene<Content : View> : View {
    @EnvironmentObject private var sceneState : NavigateSceneState
    @Environment(\.colorScheme) var colorScheme
    private var name : String
    private var content : (Dictionary<String,String>) -> Content
    public init(
            _ name: String = "*",
            @ViewBuilder content: @escaping (Dictionary<String,String>) -> Content
    ) {
        self.content = content
        self.name = name
    }
    public init(
            _ name: String = "*",
            @ViewBuilder content: @escaping () -> Content
    ) {
        self.content = { properties in
            content()
        }
        self.name = name
    }
    public var body: some View {
        var canShow = false
        if !sceneState.hasMatch {
            if sceneState.sceneName == name || name == "*" {
                canShow = true
                sceneState.hasMatch = true
            }
        }
        return Group {
            if canShow {
                ZStack {
                    (sceneState.navigationType == .Push ? (colorScheme == .light ? Color.white : Color.black) : Color.clear)
                        .frame(maxWidth:.infinity,maxHeight: .infinity)
                        .edgesIgnoringSafeArea(.all)
                    content(sceneState.properties)
                }
                .sceneTransition()
            }
        }
    }
}
