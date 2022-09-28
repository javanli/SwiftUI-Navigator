//
//  NavBar.swift
//  CaseStudy
//
//  Created by baitaotu on 2022/9/27.
//

import SwiftUI
import SwiftUINavigator

struct NavBar: View {
    public var title : String
    @EnvironmentObject private var navigator: Navigator
    @EnvironmentObject private var navigationState : NavigationState
    var body: some View {
        VStack(spacing: 0) {
            ZStack {
                HStack(spacing: 0) {
                    Spacer()
                    Text(title)
                    Spacer()
                }
                if navigationState.canPop() {
                    HStack {
                        Button {
                            navigator.goBack()
                        } label: {
                            Text("Back")
                        }.frame(width: 60)
                        Spacer()
                    }
                }
            }.frame(height: 44)
            Divider()
        }
    }
}

struct NavBar_Previews: PreviewProvider {
    static var previews: some View {
        NavBar(title: "NavBar")
    }
}
