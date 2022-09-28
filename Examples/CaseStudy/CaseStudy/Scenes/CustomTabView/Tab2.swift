//
//  Tab2.swift
//  CaseStudy
//
//  Created by baitaotu on 2022/9/27.
//

import SwiftUI

let Tab2SceneName = "Tabs.tab2"
struct Tab2: View {
    var body: some View {
        VStack {
//            NavBar(title: "Tab2")
            Spacer()
            Text("Hello, Tab2!")
            Spacer()
            TabBar()
        }
    }
}

struct Tab2_Previews: PreviewProvider {
    static var previews: some View {
        Tab2()
    }
}
