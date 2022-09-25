//
//  utils.swift
//
//
//  Created by lijunfan on 2022/8/19.
//

import Foundation
import SwiftUI

extension UIScreen{
   static let screenWidth = UIScreen.main.bounds.size.width
   static let screenHeight = UIScreen.main.bounds.size.height
   static let screenSize = UIScreen.main.bounds.size
}
public class NavDisplayLinkRequest {
    public var duration : Double = 0.3
    public var startTime : Double = 0
    public var onStepWithPercent : (Double)->Void
    public var onEnd : ()->Void
    
    init(duration : Double = 0.3, onStepWithPercent : @escaping (Double)->Void, onEnd : @escaping ()->Void) {
        self.duration = duration
        self.onStepWithPercent = onStepWithPercent
        self.onEnd = onEnd
    }
}
public class NavDisplayLink {
    private var displaylink: CADisplayLink!
    private var tasks : [NavDisplayLinkRequest] = []
    public init() {
        displaylink = CADisplayLink(target: self, selector: #selector(onStep))
        displaylink.add(to: .main, forMode: RunLoop.Mode.default)
    }
    public func requestDisplayLink(onStepWithPercent:@escaping (Double)->Void, duration: Double = 0.3) async -> Void {
        return await withCheckedContinuation { continuation in
            let task = NavDisplayLinkRequest(duration: duration, onStepWithPercent: onStepWithPercent) {
                continuation.resume()
            }
            tasks.append(task)
            displaylink.isPaused = false
        }
    }
    @objc public func onStep() {
        if tasks.count == 0 {
            displaylink.isPaused = true
            return
        }
        let task = tasks.first!
        let currentTime = Date().timeIntervalSince1970
        if task.startTime == 0 {
            task.startTime = currentTime
            task.onStepWithPercent(0)
        }
        else if currentTime >= task.startTime + task.duration {
            task.onStepWithPercent(1.0)
            task.onEnd()
            tasks.remove(at: 0)
        }
        else {
            task.onStepWithPercent((currentTime - task.startTime) / task.duration)
        }
    }
}
