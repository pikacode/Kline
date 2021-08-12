//
//  Depth.swift
//  KLine
//
//  Created by aax1 on 2021/6/28.
//

import UIKit
import Charts
open class Depth {
    required public init() {}

    private static func calculateDepth(_ data: inout [KLDepthPoint]){
    
        var buyArr = data.filter { (model) -> Bool in return model.type ==  .buy}
        var sellArr = data.filter { (model) -> Bool in return model.type ==  .sell }
    
        let buySum = buyArr.reduce(0) { (total, model) in return total + model.amount}
        let sellSum = sellArr.reduce(0) { (total, model) in return total + model.amount}
      
    
        buyArr[0].depthNum = buySum
        for index in 1 ..< buyArr.count {

            let item = buyArr[index]
            let lastItem = buyArr[index - 1]
            item.depthNum = lastItem.depthNum - lastItem.amount
            buyArr[index] = item
        }
        let count = sellArr.count - 1
        
        sellArr[0].depthNum = sellArr[0].amount
        sellArr[count].depthNum = sellSum
        for index in stride(from: count, through: 1, by: -1) {
            let item = sellArr[index]
            let lastItem = sellArr[index - 1]
            lastItem.depthNum = item.depthNum - item.amount

            sellArr[index - 1] = lastItem
        }
        
    }
}

extension Depth: KLIndicator {
    public static var style: KLStyle = KLStyle.default

    public static func calculate(_ data: inout [Any]) {
        guard var data = data as? [KLDepthPoint] else { return }
        calculateDepth(&data)
    }
    
    
    public func lineDataSet(_ data: [Any]) -> [LineChartDataSet]? {
        guard let data = data as? [KLDepthPoint] else { return nil }
        var sets = [LineChartDataSet]()
        let data1 = data.filter { (model) -> Bool in return model.type == .buy}
        let data2 = data.filter { (model) -> Bool in return model.type == .sell}
        
        let dataArr = [data1, data2]
        let colors = [style.downColor, style.upColor]
        for (index, item) in dataArr.enumerated() {
            let entries = item.compactMap{ (model) -> ChartDataEntry? in
                print(model.x, model.depthNum)
                return ChartDataEntry(x: Double(model.x), y: model.depthNum)
            }
            
            let set = LineChartDataSet(entries: entries, label: "")
            set.setColor(colors[index])
            set.lineWidth = style.lineWidth1
            set.drawFilledEnabled = true
            
            set.circleRadius = 0
            set.circleHoleRadius = 0
            set.drawValuesEnabled = false

            //生成渐变色
            let gradient = CGGradient.init(colorsSpace: CGColorSpaceCreateDeviceRGB(),
                                           colors: [colors[index].cgColor, UIColor.white.cgColor] as CFArray, locations: [1.0, 0.0])
            //将渐变色作为填充对象
            set.fill = Fill.fillWithLinearGradient(gradient!, angle: 90.0)
            sets.append(set)
        }
        
        return sets
    }
    
    
    
}
