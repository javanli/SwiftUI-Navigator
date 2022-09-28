//
//  Tab1.swift
//  CaseStudy
//
//  Created by baitaotu on 2022/9/27.
//

import SwiftUI
import SwiftUINavigator

let Tab1SceneName = "Tabs.tab1"
struct Tab1: View {
    @EnvironmentObject private var navigator: Navigator
    var body: some View {
        VStack {
            NavBar(title: "Tab1")
            Spacer()
            Text("Hello, Tab1!").onTapGesture {
                navigator.pop()
            }
            Spacer()
            TabBar()
        }
    }
}

struct Tab1_Previews: PreviewProvider {
    static var previews: some View {
        Tab1()
    }
}
