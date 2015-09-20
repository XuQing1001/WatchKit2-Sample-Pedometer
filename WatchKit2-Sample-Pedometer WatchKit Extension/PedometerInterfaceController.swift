//
//  InterfaceController.swift
//  WatchKit2-Sample-Pedometer WatchKit Extension
//
//  Created by XuQing on 15/8/2.
//  Copyright © 2015年 XuQing1001. All rights reserved.
//

import WatchKit
import Foundation
import CoreMotion

class PedometerInterfaceController: WKInterfaceController {
    // 用于标记可用性的圆形Group  （可用：绿色，不可用：红色）
    @IBOutlet var groupStepsAvailable: WKInterfaceGroup!
    @IBOutlet var groupDistanceAvailable: WKInterfaceGroup!
    @IBOutlet var groupFloorAvailable: WKInterfaceGroup!
    
    // 显示数值的标签： 步数，距离，上下楼层数
    @IBOutlet weak var labelSteps: WKInterfaceLabel!
    @IBOutlet weak var labelDistance: WKInterfaceLabel!
    @IBOutlet weak var labelFloorsAscended: WKInterfaceLabel!
    @IBOutlet weak var labelFloorsDescended: WKInterfaceLabel!

    // 创建一个CMPedometer对象
    let pedometer = CMPedometer()
    
    
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
    }
    
    func setAvailability(availability : Bool, mark: WKInterfaceGroup){
        mark.setBackgroundColor(availability ? UIColor.greenColor() : UIColor.redColor())
    }
    
    override func willActivate() {
        super.willActivate()
        setAvailability(CMPedometer.isStepCountingAvailable(), mark: groupStepsAvailable)
        setAvailability(CMPedometer.isDistanceAvailable(), mark: groupDistanceAvailable)
        setAvailability(CMPedometer.isFloorCountingAvailable(), mark: groupFloorAvailable)
        print("Pace：\(CMPedometer.isPaceAvailable())|StepCount:\(CMPedometer.isStepCountingAvailable())|Distance:\(CMPedometer.isDistanceAvailable())|FloorCount:\(CMPedometer.isFloorCountingAvailable())")
        startPedometerUpdates()
    }
    
    // 开始获取计步器数据
    func startPedometerUpdates(){
        // 判断计步器是否可用
        if (CMPedometer.isPaceAvailable() == true) {
            // 获取实时计步器数据
            pedometer.startPedometerUpdatesFromDate(NSDate()) { (pedometerData, error) -> Void in
                print("\(NSDate()) startPedometerUpdatesFromDate: \(pedometerData); Error:\(error?.description)")
                if pedometerData != nil {
                    // 步数
                    let steps: UInt = pedometerData!.numberOfSteps.unsignedLongValue
                    self.labelSteps.setText(String(format: "%lu", steps))
                    print("PedometerData: Steps:\(steps)")
                    // 距离
                    if pedometerData!.distance != nil {
                        let distance: UInt = pedometerData!.distance!.unsignedLongValue
                        self.labelDistance.setText(String(format: "%lu", distance))
                    }
                    // 上楼层数
                    if pedometerData!.floorsAscended != nil {
                        let floorsAscended: UInt = pedometerData!.floorsAscended!.unsignedLongValue
                        self.labelFloorsAscended.setText(String(format: "%lu", floorsAscended))
                    }
                    // 下楼层数
                    if pedometerData!.floorsDescended != nil {
                        let floorsDescended: UInt = pedometerData!.floorsDescended!.unsignedLongValue
                        self.labelFloorsDescended.setText(String(format: "%lu", floorsDescended))
                    }
                }
            }
        }
        else {
            self.labelSteps.setText("--")
            self.labelDistance.setText("--")
            self.labelFloorsAscended.setText("--")
            self.labelFloorsDescended.setText("--")
        }
    }
    
    override func didDeactivate() {
        super.didDeactivate()
        // 停止获取数据
        pedometer.stopPedometerUpdates()
    }

}
