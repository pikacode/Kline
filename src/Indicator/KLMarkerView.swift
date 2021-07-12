//
//  KLMarkerView.swift
//  KLine
//
//  Created by aax1 on 2021/7/12.
//

import UIKit
import UIKit
import Charts
class KLMarkerView: UIView {
    var openLabel: UILabel?
    var closeLabel: UILabel?
    var highLabel: UILabel?
    var lowLabel: UILabel?
    var volLabel: UILabel?
    var changeRateLabel: UILabel?
    var changeQuotaLabel: UILabel?
    var markerView: KLMarker!
    
    func initUI() {
        let labelArr = [openLabel, closeLabel, highLabel, lowLabel, volLabel, changeQuotaLabel, changeRateLabel]
        let titleArr = ["开","收","高","低","量","涨跌额","涨跌幅"]
        
        markerView = KLMarker.init(frame: CGRect.init(x: 0, y: 0, width: 130, height: 173))
//        markerView.chartView = chartView
//        markerView.backgroundColor = UIColor.init(red: 38, green: 38, blue: 38, alpha: 0.8)
        markerView.isOpaque = true
        
        for (index, item) in labelArr.enumerated() {
        let tView = UIView.init()
            
            let height = markerView.bounds.size.height / CGFloat(labelArr.count)
            let top = CGFloat(height) * CGFloat(index)
           
            tView.frame = CGRect.init(x: 0, y: top, width: markerView.bounds.size.width, height: height)
            markerView.addSubview(tView)
            tView.backgroundColor = .lightGray
            
            addCell(title: titleArr[index], valueLabel: item ?? UILabel(), bgView: tView)
        }
    }
    
    
    
    func addCell(title: String, valueLabel: UILabel , bgView: UIView)  {
        
        let label = addLabel(title: "kai")
        let W = bgView.bounds.size.width - 12.0
        let H = bgView.bounds.size.height
        
        label.frame = CGRect.init(x: 6, y: 0, width: W, height: H)
        label.textAlignment = .left
        bgView.addSubview(label)
        label.text = title
                
        let valueLabel = addLabel(title: "35420.12", valueLabel: true)
        valueLabel.textAlignment = .right
        bgView.addSubview(valueLabel)
        valueLabel.frame = CGRect.init(x: 6, y: 0, width: W, height: H)
        valueLabel.textAlignment = .right
        
    }
    
    func addLabel(title: String, valueLabel: Bool = false) -> UILabel {
        let label = UILabel.init()
        label.text = title
        label.textColor = valueLabel ? .white :  UIColor.init(red: 153, green: 153, blue: 153, alpha: 1)
        label.font = .systemFont(ofSize: 12)
        return label
    }

}
