//
//  TabBar.swift
//  CaseStudy
//
//  Created by baitaotu on 2022/9/27.
//

import SwiftUI
import SwiftUINavigator
struct TabBarItem : View {
    let img : String
    let imgH : String
    let title : String
    let isSelected : Bool
    var body: some View {
        VStack(spacing: 0) {
            Image(systemName: isSelected ? imgH : img)
                .foregroundColor(isSelected ? .blue : .gray)
                .font(.system(size: 20))
            
            Spacer().frame(height: 4)
            
            Text(title)
                .foregroundColor(isSelected ? .blue : .gray)
                .font(.system(size: 14))
        }
    }
}

struct TabBar: View {
    var body: some View {
        Divider()
        Spacer().frame(height: 12)
        HStack {
            Spacer()
            NavLink(to: Tab1SceneName, replace: true) { active in
                TabBarItem(img: "house", imgH: "house.fill", title: "Tab1", isSelected: active)
            }
            Spacer()
            Spacer()
            NavLink(to: Tab2SceneName, replace: true) { active in
                TabBarItem(img: "heart", imgH: "heart.fill", title: "Tab2", isSelected: active)
            }
            Spacer()
            Spacer()
            NavLink(to: Tab3SceneName, replace: true) { active in
                TabBarItem(img: "person.circle", imgH: "person.circle.fill", title: "Tab3", isSelected: active)
            }
            Spacer()
        }
    }
}

struct TabBar_Previews: PreviewProvider {
    static var previews: some View {
        TabBar()
    }
}
