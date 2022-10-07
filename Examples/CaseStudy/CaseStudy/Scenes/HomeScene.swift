//
//  HomeScene.swift
//  CaseStudy
//
//  Created by baitaotu on 2022/9/27.
//

import SwiftUI
import SwiftUINavigator

let HomeSceneName = "home"

struct HomeScene: View {
    @EnvironmentObject private var navigator: Navigator
    var body: some View {
        VStack(spacing:0) {
            // this is a custom navgation bar
            NavBar(title: "CaseStudy")
            List {
                Button("Common Navgation") {
                    navigator.push(NavActionSceneName)
                }
                .frame(height: 40)
                
                Button("CustomTabView") {
                    navigator.push(Tab1SceneName)
                }
                .frame(height: 40)
                
                Button("CustomFadeTransition") {
                    navigator.push(FadeSceneName)
                }
                .frame(height: 40)
                
                Button("Popup") {
                    navigator.present(PopupSceneName,animated: false)
                }
                .frame(height: 40)
                
                Button("Use * to handle scene not found") {
                    navigator.push("Unknown")
                }
                .frame(height: 40)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
                .listStyle(.plain)
                .listRowSeparator(.hidden)
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
