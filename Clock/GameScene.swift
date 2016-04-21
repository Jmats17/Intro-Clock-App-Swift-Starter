//
//  GameScene.swift
//  Clock
//
//  Created by Yujin Ariza on 4/20/16.
//  Copyright (c) 2016 Make School. All rights reserved.
//

import SpriteKit

let blockCategory: UInt32 = 1 << 1

func degreesToRadians(degrees: Double) -> CGFloat {
    return CGFloat(degrees * M_PI / 180)
}

public class GameScene: SKScene {
    var timeLabel: SKLabelNode?
    var hourHand: SKNode?
    var minuteHand: SKNode?
    var secondHand: SKNode?
    
    let clockFace = ClockFace()
    
    override public func didMoveToView(view: SKView) {
        timeLabel = childNodeWithName("timeLabel") as? SKLabelNode
        
        let clock = childNodeWithName("clock")!
        
        hourHand = clock.childNodeWithName("hourHand")
        minuteHand = clock.childNodeWithName("minuteHand")
        secondHand = clock.childNodeWithName("secondHand")
        
        updateTime()

        NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: #selector(GameScene.updateTime), userInfo: nil, repeats: true)
    }
    
    class func unarchiveFromFile(file: String) -> SKScene? {
        if let path = NSBundle.mainBundle().pathForResource(file, ofType: "sks") {
            let sceneData = try! NSData(contentsOfFile: path, options: .DataReadingMappedIfSafe)
            let archiver = NSKeyedUnarchiver(forReadingWithData: sceneData)
            
            archiver.setClass(self.classForKeyedUnarchiver(), forClassName: "SKScene")
            let scene = archiver.decodeObjectForKey(NSKeyedArchiveRootObjectKey) as! GameScene
            archiver.finishDecoding()
            return scene
        } else {
            return nil
        }
    }
    
    func updateTime() {
        clockFace.updateDate()
        
        let hours = clockFace.calendar.component(.Hour, fromDate: clockFace.date)
        let minutes = clockFace.calendar.component(.Minute, fromDate: clockFace.date)
        let seconds = clockFace.calendar.component(.Second, fromDate: clockFace.date)
        
        let timeString = "\(String(format: "%02d", hours)):\(String(format: "%02d", minutes)):\(String(format: "%02d", seconds))"
        timeLabel?.text = "The time is \(timeString)"
        
        hourHand?.zRotation = -degreesToRadians(clockFace.getHourHandDegrees())
        minuteHand?.zRotation = -degreesToRadians(clockFace.getMinuteHandDegrees())
        secondHand?.zRotation = -degreesToRadians(clockFace.getSecondHandDegrees())
    }
}