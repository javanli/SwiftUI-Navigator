# SwiftUINavigator

[![CI](https://img.shields.io/badge/SPM-supported-DE5C43.svg?style=flat)](https://swift.org/package-manager/)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

[中文版🇨🇳](README_CN.md)

A declarative routing and navigation framework for SwiftUI apps

Tip1: This is a experimental framework. You should be careful about production use.

Tip2: `NavigationStack` for iOS16+ is much more better than `NavigationView`. It is recommended to try out `NavigationStack` before using SwiftUINavigator in iOS16+ project.

## Features

* centeral and declarative routing
* easier navigation api
* support push/present/replace
* support multi-level back
* support custom transition
* Low coupling between scenes
* String based sceneName, easy for dynamic navigation
* pure SwiftUI

## Motivation

SwiftUI is a great declarative UI framework, but `NavigationView` is a imperative navigation framework. With `NavigationView`, source page should build complete destination view for navigation. This results in bad coupling. And `NavigationView` don't have enough API to do custom navigation, it's not easy to develop a middle/big app with `NavigationView`.

So I design the `SwiftUINavigator` to provide a declarative routing framework which is more suitable with SwiftUI and has better navigation ability.

But because of the limitation of SwiftUI, `SwiftUINavigator` use `ZStack` to realize a custom Navigation Stack. I'm not sure if it's reliable enough for all apps.

## Examples

[Examples](./Examples/) to show how to use `SwiftUINavigator`

### CaseStudy

https://user-images.githubusercontent.com/15244665/194570990-041f9ff2-c0ba-438e-b832-24708832ba21.mp4

## Usage

First, declare all routes.

* Router is root view of framework，it will initialize the naivgation environment. Normally the entire app should be wrapped in Router.
* NavScene means a page，it renders content only when current scene name matchs it's name.

```Swift
@main
struct CaseStudyApp: App {
    var body: some Scene {
        WindowGroup {
            Router(initialName: HomeSceneName) {
                NavScene(HomeSceneName) {
                    HomeScene()
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
```

Then write your scenes.
There are 3 EnvironmentObject you can achieve in scene:

* Navigator : the controller of navigation, use Navigator to push/pop/present etc.
* NavigationState : the state of navigation, use NavigationState to view all pages state.
* NavigateSceneState : the state of current scene, use NavigateSceneState to view current page's name/transition state etc.

```Swift
let NavActionSceneName = "nav_action"
struct NavActionScene: View {
    @EnvironmentObject private var navigator: Navigator
    @EnvironmentObject private var navigationState : NavigationState
    @EnvironmentObject private var sceneState : NavigateSceneState
    var tag : Int = 0
    var body: some View {
        var fullPath = ""
        for sceneState in navigationState.historyStack {
            fullPath += "/\(sceneState.sceneName)"
        }
        return VStack() {
            NavBar(title: "NavAction-\(tag)")
            Text("currentFullPath:  \(fullPath)")
            
            Button("push") {
                navigator.push(NavActionSceneName,properties: ["tag": String(tag + 1)])
            }
            Button("present") {
                navigator.present(NavActionSceneName,properties: ["tag": String(tag + 1)])
            }
            Button("replace") {
                navigator.replace(NavActionSceneName,properties: ["tag": String(tag + 1)])
            }
            Button("backToHome") {
                navigator.goBack(total: .max, animated: true)
            }
            Spacer()
        }.background(sceneState.navigationType == .Push ? .white : .gray)
            .offset(x: 0, y: sceneState.navigationType == .Push ? 0 : 150)
    }
}
```

Detail usage -> [Examples](./Examples/)

## 依赖

* iOS 14.0+ / macOS 12.0+ / tvOS 14.0+ / watchOS 8.0+

## 安装

You can add SwiftUINavigator to an Xcode project by adding it as a package dependency.

> https://github.com/javanli/SwiftUI-Navigator

## 其他

Issues and PRs are warmly welcome.

Contact me by email(javanli@qq.com)
