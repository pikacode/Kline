//
//  MACD.swift
//  KLine
//
//  Created by aax1 on 2021/6/17.
//

import UIKit
import Charts
open class MACD: KLIndicator {
    
    public static var style: KLStyle = KLStyle.default
    
    public static var emaDay = [12, 26]
        
    public static func calculate(_ data: inout [KLineData]) {
        calculateSignMACD(&data)
    }
    /**
     EMA（12）= 前一日EMA（12）×11/13＋今日收盘价×2/13
     EMA（26）= 前一日EMA（26）×25/27＋今日收盘价×2/27
     DIFF=今日EMA（12）- 今日EMA（26）
     DEA（MACD）= 前一日DEA×8/10＋今日DIF×2/10
     BAR=2×(DIFF－DEA)
     */
    static func calculateSignMACD(_ data: inout [KLineData]) {
        for index in 0..<data.count {
            let model = data[index]
            //计算EMA12，EMA26, DEA
            if index == 0 {
                model.big_macd = model.close
                model.small_macd = model.close
                model.dif = 0
                model.dea = 0
            }else{
                let lastModel = data[index - 1]
                model.big_macd = lastModel.big_macd * 25 / 27 + model.close * 2 / 27
                model.small_macd = lastModel.small_macd * 11 / 13 + model.close * 2 / 13
                model.dif =  model.small_macd - model.big_macd
                model.dea  = lastModel.dea * (8.0 / 10.0) + model.dif * (2.0 / 10.0)
            }
            model.macd_macd = 2 * (model.dif - model.dea)
            data[index] =  model
        }
    }
    
    public static func lineData(_ data: [KLineData]) -> [LineChartDataSet]? {
        
        let sets = emaDay.map { (day) -> LineChartDataSet in
            
            let index = emaDay.firstIndex(of: day) ?? 0
            let entries = data.compactMap{ (d) -> ChartDataEntry? in
                return ChartDataEntry(x: d.x, y: index == 0 ? d.dif : d.dea)
            }
            let set = LineChartDataSet(entries: entries, label: "")
            
            let color = [style.lineColor1, style.lineColor2][index]
            set.setColor(color)
            set.setCircleColor(UIColor(red: 240/255, green: 238/255, blue: 70/255, alpha: 1))
            set.lineWidth = 0.5
            set.circleRadius = 0
            set.circleHoleRadius = 0
            set.fillColor = UIColor(red: 240/255, green: 238/255, blue: 70/255, alpha: 1)
            set.mode = .cubicBezier
            set.drawValuesEnabled = true
            set.valueFont = .systemFont(ofSize: 0)
            set.valueTextColor = UIColor(red: 240/255, green: 238/255, blue: 70/255, alpha: 1)
            set.axisDependency = .left
            return set
        }
        return sets
    }
    
    public static func barData(_ data: [KLineData]) -> [BarChartDataSet]? {
        let entries = data.compactMap{ (d) -> BarChartDataEntry in
            return BarChartDataEntry(x: d.x, y: d.macd_macd)
        }
        let colors = entries.map { (entry) -> NSUIColor in
            return entry.y > 0 ? .red : .green
        }
        let set = BarChartDataSet(entries: entries)
        set.colors = colors
        set.valueColors = colors
        return [set]
    }
    
    
}