//
//  ChartSettingsView.swift
//  demo
//
//  Created by pikacode on 2021/6/22.
//

import UIKit
import Charts

class ChartSettingsView: UIView {

    @IBOutlet weak var contentTrailing: NSLayoutConstraint!
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var back: UIImageView!
    @IBOutlet weak var heightRectLeading: NSLayoutConstraint!

    let settings = ChartSettings.shared

    @IBAction func heightAction(_ sender: UIButton) {
        heightRectLeading.constant = [0, 121, 242][sender.tag]
        settings.mainHeight = [182, 282, 382][sender.tag]
        UIView.animate(withDuration: 0.2) {
            self.layoutIfNeeded()
        }
    }

    //主图指标
    @IBAction func mainIndicatorAction(_ sender: UIButton) {
        sender.isSelected.toggle()
        if sender.isSelected {
            sender.superview?.bringSubviewToFront(sender)
        } else {
            sender.superview?.sendSubviewToBack(sender)
        }
        var s = settings.mainIndicators[sender.tag]
        s.1 = sender.isSelected
        settings.mainIndicators[sender.tag] = s
        //dismiss()
    }

    //副图指标
    @IBAction func otherIndicatorAction(_ sender: UIButton) {
        sender.isSelected.toggle()
        if sender.isSelected {
            sender.superview?.bringSubviewToFront(sender)
        } else {
            sender.superview?.sendSubviewToBack(sender)
        }
        var s = settings.otherIndicators[sender.tag]
        s.1 = sender.isSelected
        settings.otherIndicators[sender.tag] = s
        //dismiss()
    }

    //线
    @IBAction func switchAction(_ sender: UISwitch) {
        //sender.isOn.toggle()
        settings.switchs[sender.tag] = sender.isOn
    }

    override func awakeFromNib() {
        contentTrailing.constant = -280
        bgView.alpha = 0

        back.addTap { [weak self] in
            self?.dismiss()
        }
        bgView.addTap { [weak self] in
            self?.dismiss()
        }
    }

    func show() {
        UIApplication.shared.keyWindow?.addSubview(self)
        frame = UIScreen.main.bounds
        self.superview?.layoutIfNeeded()

        UIView.animate(withDuration: 0.2) {
            self.bgView.alpha = 1
            self.contentTrailing.constant = 0
            self.superview?.layoutIfNeeded()
        }
    }

    func dismiss() {
        UIView.animate(withDuration: 0.2) {
            self.bgView.alpha = 0
            self.contentTrailing.constant = -280
            self.superview?.layoutIfNeeded()
        } completion: { (_) in
            self.removeFromSuperview()
        }
    }

}
