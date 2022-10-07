//
//  CaseStudyApp.swift
//  CaseStudy
//
//  Created by baitaotu on 2022/9/27.
//

import SwiftUI
import SwiftUINavigator

@main
struct CaseStudyApp: App {
    var body: some Scene {
        WindowGroup {
            Router(initialName: HomeSceneName) {
                NavScene(HomeSceneName) {
                    HomeScene()
                }
                NavScene(Tab1SceneName) { properties in
                    Tab1()
                }
                NavScene(Tab2SceneName) { properties in
                    Tab2()
                }
                NavScene(Tab3SceneName) { properties in
                    Tab3()
                }
                NavScene(NavActionSceneName) { properties in
                    let tagStr = properties["tag"] ?? "0"
                    NavActionScene(tag: Int(tagStr) ?? 0)
                }
                NavScene(FadeSceneName) {
                    FadeScene()
                }.fadeTransition()
                
                NavScene(PopupSceneName) {
                    PopupScene()
                }
                
                NavScene("*") {
                    UnknownScene()
                }
            }
        }
    }
}
