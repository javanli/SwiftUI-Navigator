//
//  HomeScene.swift
//  CaseStudy
//
//  Created by baitaotu on 2022/9/27.
//

import SwiftUI
import SwiftUINavigator

let HomeSceneName = "home"

let homeConfig = [
    (text:"Try Navgation",sceneName:NavActionSceneName),
    (text:"CustomTabView",sceneName:Tab1SceneName),
    (text:"CustomFadeTransition",sceneName:FadeSceneName)
]
struct HomeScene: View {
    @EnvironmentObject private var navigator: Navigator
    var body: some View {
        VStack(spacing:0) {
            // this is a custom navgation bar
            NavBar(title: "CaseStudy")
            List {
                ForEach(0..<homeConfig.count,id: \.self) { index in
                    Button(homeConfig[index].text) {
                        navigator.push(homeConfig[index].sceneName)
                    }
                    .frame(height: 40)
                    .listRowSeparator(.hidden)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
                .listStyle(.plain)
                .environment(\.defaultMinListRowHeight, 0)
                .ignoresSafeArea()
        }
    }
}

struct HomeScene_Previews: PreviewProvider {
    static var previews: some View {
        HomeScene()
    }
}
