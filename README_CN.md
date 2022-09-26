# SwiftUINavigator

[![CI](https://github.com/javanli/SwiftUI-Navigator/actions/workflows/ci.yml/badge.svg)](https://github.com/javanli/SwiftUI-Navigator/actions/workflows/ci.yml)
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

因此我设计了`SwiftUINavigator`，希望提供一个更契合SwiftUI这种声明式UI思想的路由框架，并提供更加完善的导航能力。然而由于SwiftUI的能力限制，最终实现完全抛弃了原生导航，使用了实验性的基于`ZStack`的自定义页面栈方案，目前还没有足够的项目实践保证此方案的可靠性。
