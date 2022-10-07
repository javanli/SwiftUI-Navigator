//
//  UnknownScene.swift
//  CaseStudy
//
//  Created by baitaotu on 2022/10/7.
//

import SwiftUI

struct UnknownScene: View {
    var body: some View {
        ZStack {
            Color.white.frame(maxWidth: .infinity, maxHeight: .infinity)
            VStack {
                NavBar(title: "404")
                Spacer()
                Text("404 not found")
                Spacer()
            }
        }
    }
}

struct UnknownScene_Previews: PreviewProvider {
    static var previews: some View {
        UnknownScene()
    }
}
