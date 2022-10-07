//
//  FadeScene.swift
//  CaseStudy
//
//  Created by baitaotu on 2022/9/28.
//

import SwiftUI
import SwiftUINavigator

struct FadeTransition: ViewModifier {
    @EnvironmentObject private var transitionState: NavigateSceneTransitionState
    
    func body(content: Content) -> some View {
        if !transitionState.useCustomTransition {
            transitionState.useCustomTransition = true
        }
        var opacity = 1.0
        if transitionState.animationType == .Show {
            opacity = NavDefaultTransitionTimingFunc(transitionState.animateProgress)
        }
        // hide scene
        else if transitionState.animationType == .Hide {
            opacity = 1 - NavDefaultTransitionTimingFunc(transitionState.animateProgress)
        }
        return content.opacity(opacity)
    }
}

extension View {
    func fadeTransition() -> some View {
        modifier(FadeTransition())
    }
}
let FadeSceneName = "FadeScene"
struct FadeScene: View {
    @EnvironmentObject private var navigator: Navigator
    var body: some View {
        VStack {
            NavBar(title: "FadeTransition")
            Spacer()
            Text("FadeTransition")
            Spacer()
        }
    }
}

struct FadeScene_Previews: PreviewProvider {
    static var previews: some View {
        FadeScene()
    }
}
