//
//  Tab3.swift
//  CaseStudy
//
//  Created by baitaotu on 2022/9/27.
//

import SwiftUI

let Tab3SceneName = "Tab3"
struct Tab3: View {
    var body: some View {
        VStack {
//            NavBar(title: "Tab3")
            Spacer()
            Text("Hello, Tab3!")
            Spacer()
            TabBar()
        }
    }
}

struct Tab3_Previews: PreviewProvider {
    static var previews: some View {
        Tab3()
    }
}
