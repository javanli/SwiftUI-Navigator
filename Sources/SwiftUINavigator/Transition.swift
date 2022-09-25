//
//  Transition.swift
//  Timepill
//
//  Created by baitaotu on 2022/9/18.
//

import Foundation
import SwiftUI

// kCAMediaTimingFunctionDefault
// timingPoints.cnt = 101
private let defaultTimingPoints = [
    0, 0.004487815157140687, 0.009982341783356547,
    0.016529326567491343, 0.024172369870963138,  0.03295146749129379,
    0.04290126613957928,  0.05404904830663532,  0.06641249719433087,
    0.07999733724908607,  0.09479499730150565,  0.11078049460320798,
    0.12791261904710977,  0.14612379056395045,    0.165338473379006,
    0.1854559034339236,   0.2063616009587379,  0.22792893423971897,
    0.2500233786329943,   0.2725072624904662,   0.2952445567168344,
    0.3181052625381306,  0.34096657434179756,  0.36371774470583096,
    0.38626058434707244,  0.40851059301560033,  0.43039680472186037,
    0.4518611977071575,  0.47285771533292326,  0.49335105522088174,
    0.5133153550526887,   0.5327328713434473,   0.5515927175336724,
    0.5698897026198408,   0.5876232920982464,   0.6047946771956575,
    0.6214133502670411,   0.6374863893181133,    0.653024057772053,
    0.668037927828928,    0.682540506014571,   0.6965449288767389,
    0.7100647178323065,   0.7231135834241149,   0.7357052705277073,
    0.7478534372704345,   0.7595715615421871,   0.7708728699681578,
    0.7817702850756538,   0.7922763871245753,   0.8024033876954126,
    0.8121631126521519,   0.8215669925335909,   0.8306260587878476,
    0.8393509445628254,    0.847751889010353,   0.8558387442624572,
    0.863620984402394,   0.8711077158870076,   0.8783076889861309,
    0.8852293098934655,   0.8918806532354688,    0.898269474763196,
    0.9044032240593398,     0.91028905713093,   0.9159338487889679,
    0.9213442047410517,     0.92652647334294,   0.9314867569708899,
    0.9362309229892647,   0.9407646142979403,   0.9450935942410327,
    0.9492223318438328,    0.953156294835013,   0.9569003216160499,
    0.9604590729525889,   0.9638370400023442,   0.9670385519427952,
    0.9700677832181692,   0.9729287604249371,    0.975625368854497,
    0.9781613587109456,   0.9805403510209825,   0.9827658432520642,
    0.9848412146540226,   0.9867697313384863,   0.9885545511096043,
    0.9901987280588159,   0.9917052169356964,   0.9930768773062612,
    0.9943164775095211,   0.9954266984225338,   0.9964101370437018,
    0.9972693099035883,   0.9980066563120916,    0.998624541450409,
    0.9991252833514669,   0.9995110411962129,   0.9997840307381204,
    0.9999463395019345,   1.0
]

/// calculate default timingfunction animation progress
/// default timingfunction = kCAMediaTimingFunctionDefault = cubic-bezier(0.25,0.1,0.25,1)
/// - Parameter t: animation time, 0 - 1
/// - Returns: animation position, 0 - 1
public func NavDefaultTransitionTimingFunc(_ t:Double) -> Double {
    if t < 0 {
        return 0
    }
    if t > 1 {
        return 1
    }
    return defaultTimingPoints[Int(t * 100.0)]
}


struct NavSceneTransition: ViewModifier {
    @EnvironmentObject private var sceneState: NavigateSceneState
    @EnvironmentObject private var transitionState: NavigateSceneTransitionState
    
    func body(content: Content) -> some View {
        var x = 0.0
        var y = 0.0
        var opacity = 1.0
        if !transitionState.useCustomTransition && transitionState.animationType != .None {
            if transitionState.animationType == .Show {
                if transitionState.animateProgress == 0 {
                    opacity = 0.0
                }
                if sceneState.navigationType == .Push {
                    x = (1 - NavDefaultTransitionTimingFunc(transitionState.animateProgress)) * UIScreen.screenWidth
                }
                else {
                    y = (1 - NavDefaultTransitionTimingFunc(transitionState.animateProgress)) * UIScreen.screenHeight
                }
            }
            // hide scene
            else {
                // pop
                if sceneState.navigationType == .Push {
                    x = NavDefaultTransitionTimingFunc(transitionState.animateProgress) * (UIScreen.screenWidth - transitionState.dragX)
                }
                // dismiss
                else {
                    y = NavDefaultTransitionTimingFunc(transitionState.animateProgress) * UIScreen.screenHeight
                }
            }
        }
        return content.offset(x: x + transitionState.dragX,y: y).opacity(opacity)
    }
}

extension View {
    func sceneTransition() -> some View {
        modifier(NavSceneTransition())
    }
}


struct SwipeableBack: ViewModifier {
    @EnvironmentObject private var sceneState: NavigateSceneState
    @EnvironmentObject private var navigator : Navigator
    @EnvironmentObject private var navigationState : NavigationState
    @EnvironmentObject private var transitionState: NavigateSceneTransitionState
    let isLastPage : Bool
    let thresholdX: CGFloat = 80
    let thresholdSpeedX: CGFloat = 50
    private var dragGesture: some Gesture {
        DragGesture(minimumDistance: 5)
            .onChanged { value in
                if (value.startLocation.x < 20)
                {
                    transitionState.dragX = Double.maximum(value.translation.width, 0)
                }
            }
            .onEnded { value in
                if transitionState.dragX > 0 && (value.predictedEndLocation.x - value.location.x > thresholdSpeedX || transitionState.dragX > thresholdX) {
                    navigator.pop()
                }
                else {
                    navigator.resetDragOffset()
                }
            }
    }

    func body(content: Content) -> some View {
        var including : GestureMask = .subviews
        if isLastPage {
            if navigationState.canPop() && sceneState.canSwipeBack {
                including = .all
            }
            else {
                including = .subviews
            }
        }
        else {
            including = .none
        }
        return content
            .simultaneousGesture(dragGesture, including: including)
    }
}

extension View {
    func swipeableBack(isLastPage:Bool) -> some View {
        modifier(SwipeableBack(isLastPage: isLastPage))
    }
}
