# SwiftUINavigator

[![CI](https://img.shields.io/badge/SPM-supported-DE5C43.svg?style=flat)](https://swift.org/package-manager/)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

为SwiftUI应用提供的一个声明式的路由和导航框架。

注意： 这是一个实验性的框架，生产环境使用需要仔细评估。

注意2: iOS16推出的`NavigationStack`比起`NavigationView`已经优化了非常多，如果你的应用只需要支持iOS16及以上，建议优先考虑`NavigationStack`

## 特点

优点：

* 中心化、声明式的路由定义
* 更简单易用的页面跳转接口
* 支持push/present
* 支持replace
* 支持多级返回
* 支持自定义转场动画
* 页面间无耦合
* 基于字符串的sceneName跳转，更灵活，方便配置化
* 纯SwiftUI实现

缺点：

* 使用`ZStack`自定义的页面栈，存在一些限制：
    1. 不兼容原生导航栈（`NavigationView`）
    2. 需要自定义导航栏
    3. 不兼容原生`Transition`，自定义动画需要自行插值计算，比较麻烦（当页面中存在`List`时跟`Transition`有冲突）
    4. 其它未知问题

## 动机

SwiftUI是一个优秀的声明式UI框架，但官方提供的`NavigationView`是个非常僵硬的命令式路由系统，起始页需要完整构造出落地页的View才能进行跳转，页面间耦合太重，并且缺少很多能力，并不足以支持一个中大型应用的开发。

因此我设计了`SwiftUINavigator`，希望提供一个更契合SwiftUI这种声明式UI思想的路由框架，并提供更加完善的导航能力。然而由于SwiftUI的能力限制，最终实现完全抛弃了原生导航，使用了基于`ZStack`的自定义页面栈方案，此方案的可靠性目前还有待验证。

## 例子

[这里](./Examples/)提供了一些例子来演示如何利用`SwiftUINavigator`来提供路由能力。

### CaseStudy

https://user-images.githubusercontent.com/15244665/194570990-041f9ff2-c0ba-438e-b832-24708832ba21.mp4

## 使用

首先，声明路由。

* Router是此路由框架的根节点，它会初始化所需的路由环境。通常情况下Router应该在一个应用的最外层。
* NavScene代表一个页面，只有当前页面的name与其匹配时才会渲染其内容

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

之后，开发scene。scene中可以获取到3个EnvironmentObject：

* Navigator : 路由控制器，通过Navigator控制页面的进出等
* NavigationState : 路由状态，通过NavigationState可以访问完整的页面栈
* NavigateSceneState : 页面状态，通过NavigateSceneState可以访问当前页面的状态

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

更详细的使用方式请参考[例子](./Examples/)

## 依赖

* iOS 14.0+ / macOS 12.0+ / tvOS 14.0+ / watchOS 8.0+

## 安装

You can add SwiftUINavigator to an Xcode project by adding it as a package dependency.

> https://github.com/javanli/SwiftUI-Navigator

## 其他

欢迎提Issue和PR，也可以通过邮箱(javanli@qq.com)联系我。
