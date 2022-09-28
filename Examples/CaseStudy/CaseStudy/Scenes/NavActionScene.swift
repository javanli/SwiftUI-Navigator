//
//  NavActionScene.swift
//  CaseStudy
//
//  Created by baitaotu on 2022/9/27.
//

import SwiftUI
import SwiftUINavigator

let NavActionSceneName = "nav_action"
struct NavActionScene: View {
    @EnvironmentObject private var navigator: Navigator
    @EnvironmentObject private var navigationState : NavigationState
    @EnvironmentObject private var sceneState : NavigateSceneState
    var tag : Int = 0
    var body: some View {
        var fullPath = ""
        for sceneState in navigationState.historyStack {
            fullPath += "/\(sceneState.sceneName)"
        }
        return VStack() {
            NavBar(title: "NavAction-\(tag)")
            Text("currentFullPath:  \(fullPath)")
            
            Button("push") {
                navigator.push(NavActionSceneName,properties: ["tag": String(tag + 1)])
            }
            Button("present") {
                navigator.present(NavActionSceneName,properties: ["tag": String(tag + 1)])
            }
            Button("replace") {
                navigator.replace(NavActionSceneName,properties: ["tag": String(tag + 1)])
            }
            Button("backToHome") {
                navigator.goBack(total: .max, animated: true)
            }
            Spacer()
        }.background(sceneState.navigationType == .Push ? .white : .gray)
            .offset(x: 0, y: sceneState.navigationType == .Push ? 0 : 150)
    }
}

struct NavActionScene_Previews: PreviewProvider {
    static var previews: some View {
        NavActionScene()
    }
}
