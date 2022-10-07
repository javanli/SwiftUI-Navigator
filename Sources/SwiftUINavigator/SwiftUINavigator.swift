//
//  Navigator.swift
//
//
//  Created by lijunfan on 2022/8/19.
//

import SwiftUI

public enum NavigationAnimationType {
    case None
    case Show
    case Hide
}

public class NavigateSceneTransitionState : ObservableObject {
    // swipe back state
    @Published var dragX :Double = 0
    @Published public var animationType : NavigationAnimationType = .None {
        didSet {
            self.animateProgress = 0.0
        }
    }
    @Published public var animateProgress : Double = 0.0 //0~1
    @Published public var useCustomTransition : Bool = false
    @Published public var forbidSwipeBack : Bool = false
}
public class NavigateSceneState : ObservableObject {
    public var sceneName : String
    public var properties : Dictionary<String,String>
    public var identifier = UUID()
    public let navigationType : NavigationType
    public var transitionState : NavigateSceneTransitionState = NavigateSceneTransitionState()
    private var contentView : AnyView?
    public var hasMatch : Bool = false
    
    
    public var canSwipeBack : Bool {
        !transitionState.forbidSwipeBack && !transitionState.useCustomTransition && navigationType == .Push
    }
    
    init(sceneName : String,
         properties : Dictionary<String,String> = [:],
         navigationType : NavigationType ) {
        self.sceneName = sceneName
        self.properties = properties
        self.navigationType = navigationType
    }
    
    public func content(defaultBuilder: ()->AnyView) -> AnyView {
        if contentView == nil {
            contentView = defaultBuilder()
        }
        return contentView!
    }
    public func resetHasMatch() -> NavigateSceneState {
        hasMatch = false
        return self
    }
}

public enum NavigationType {
    case Push
    case Present
}

public class NavigationState : ObservableObject {
    @Published public var historyStack: [NavigateSceneState]
    
    public var sceneName: String {
        return historyStack.last!.sceneName
    }
    public init(initialName: String) {
        historyStack = []
        let sceneState = NavigateSceneState(sceneName: initialName,navigationType: .Push)
        historyStack = [sceneState]
    }
    private init(historyStack: [NavigateSceneState]) {
        self.historyStack = historyStack
    }
    public func canPop() -> Bool{
        return historyStack.count > 1
    }
    public func fakeState(index: Int) ->  NavigationState{
        if index >= historyStack.count - 1 {
            return self
        }
        return NavigationState(historyStack: Array(historyStack[0...index]))
    }
}

public class Navigator: ObservableObject {
    // for custom transition
    private var displaylink: NavDisplayLink!
    // serial queue to handle navigation task
    public var pendingTask : Task<Void, Never> = Task{}
    internal var state : NavigationState

    private var historyStack: [NavigateSceneState] {
        state.historyStack
    }
    public init(initialName: String) {
        state = NavigationState(initialName: initialName)
        displaylink = NavDisplayLink()
    }
    public func serialHandleNavigate(navigate:@escaping () async -> Void){
        let oldPendingTask = pendingTask
        pendingTask = Task { @MainActor in
            await oldPendingTask.value
            await navigate()
        }
    }

    public func push(_ name: String, properties : Dictionary<String,String> = [:], animated: Bool = true) {
        navigate(name,properties: properties, animated: animated, type: .Push)
    }
    
    public func replace(_ name: String, properties : Dictionary<String,String> = [:]) {
        navigate(name, replace: true,properties: properties, animated: false, type: .Push)
    }
    
    public func present(_ name: String, properties : Dictionary<String,String> = [:], animated: Bool = true) {
        navigate(name,properties: properties, animated: animated, type: .Present)
    }
    
    func navigate(_ name: String, replace: Bool = false, properties : Dictionary<String,String> = [:]) {
        navigate(name, replace: replace, properties: properties, animated: !replace,type: .Push)
    }
    func navigate(_ name: String, replace: Bool = false, properties : Dictionary<String,String> = [:], animated: Bool, type: NavigationType) {
        let sceneState = NavigateSceneState(sceneName: name, properties: properties, navigationType: type)
        let transitionState = sceneState.transitionState
        serialHandleNavigate {@MainActor [self] in
            if replace && !historyStack.isEmpty {
                if animated {
                    transitionState.animationType = .Show
                    state.historyStack.append(sceneState)
                    await displaylink.requestDisplayLink(onStepWithPercent: { percent in
                        transitionState.animateProgress = percent
                    })
                    state.historyStack.remove(at: historyStack.count - 2)
                    transitionState.animationType = .None
                }
                else {
                    state.historyStack[historyStack.endIndex - 1] = sceneState
                }
            }
            else {
                if animated {
                    transitionState.animationType = .Show
                    state.historyStack.append(sceneState)
                    await displaylink.requestDisplayLink(onStepWithPercent: { percent in
                        transitionState.animateProgress = percent
                    })
                    transitionState.animationType = .None
                }
                else {
                    state.historyStack.append(sceneState)
                }
            }
        }
    }

    public func pop(animated: Bool = true) {
        goBack(total: 1, animated: animated)
    }
    public func goBack(total: Int = 1, animated: Bool = true) {
        if !state.canPop() {
            return
        }
        let total = min(total, historyStack.count - 1)
        
        serialHandleNavigate {@MainActor [self] in
            if animated {
                if total > 1 {
                    state.historyStack.removeSubrange((historyStack.count - total)..<(historyStack.count - 1))
                }
                let transitionState = historyStack.last!.transitionState
                transitionState.animationType = .Hide
                await displaylink?.requestDisplayLink(onStepWithPercent: { percent in
                    transitionState.animateProgress = percent
                })
                state.historyStack.removeLast()
                transitionState.animationType = .None
            }
            else {
                state.historyStack.removeLast(total)
            }
        }
	}
    public func resetDragOffset(){
        let transitionState = historyStack.last!.transitionState
        if transitionState.dragX <= 0 {
            return
        }
        serialHandleNavigate {@MainActor [self] in
            let oriDragX = transitionState.dragX
            await displaylink?.requestDisplayLink(onStepWithPercent: { percent in
                transitionState.dragX = oriDragX - NavDefaultTransitionTimingFunc(percent) * oriDragX
            },duration: transitionState.dragX / UIScreen.screenWidth * 0.3)
        }
    }
}
