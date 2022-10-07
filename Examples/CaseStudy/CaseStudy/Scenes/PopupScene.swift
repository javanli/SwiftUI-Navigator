//
//  PopupScene.swift
//  CaseStudy
//
//  Created by baitaotu on 2022/10/7.
//

import SwiftUI
import SwiftUINavigator

let PopupSceneName = "PopupScene"
struct PopupScene: View {
    @EnvironmentObject private var navigator: Navigator
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Color.black.opacity(0.4).frame(maxWidth: .infinity, maxHeight: .infinity)
                VStack {
                    Spacer()
                    Button {
                        navigator.pop(animated: false)
                    } label: {
                        Image(systemName: "x.circle.fill")
                            .foregroundColor(.init(.sRGB, white: 0.8, opacity: 1.0))
                            .font(.system(size: 30))
                    }

                    HStack {
                        Spacer()
                        ZStack {
                            Color.white.frame(width: geometry.size.width * 0.6, height: geometry.size.height * 0.6)
                                .border(.black, width: 1)
                            Text("This is a Popup")
                        }
                        Spacer()
                    }
                    Spacer()
                }
            }.ignoresSafeArea()
        }
    }
}

struct PopupScene_Previews: PreviewProvider {
    static var previews: some View {
        PopupScene()
    }
}
