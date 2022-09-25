//
//  NavScene.swift
//
//
//  Created by lijunfan on 2022/8/19.
//

import SwiftUI

public struct NavScene<Content : View> : View {
    @EnvironmentObject private var sceneState : NavigateSceneState
    private var name : String
    private var content : (Dictionary<String,String>) -> Content
    public init(
            _ name: String = "*",
            @ViewBuilder content: @escaping (Dictionary<String,String>) -> Content
    ) {
        self.content = content
        self.name = name
    }
    public var body: some View {
        Group {
            if sceneState.sceneName == name || name == "*" {
                ZStack {
                    (sceneState.navigationType == .Push ? Color.black : Color.clear).frame(maxWidth:.infinity,maxHeight: .infinity)
                    content(sceneState.properties)
                }
                .sceneTransition()
            }
        }
    }
}
