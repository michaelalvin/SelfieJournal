//
//  File.swift
//  imagepicker
//
//  Created by Michael Alvin on 1/12/18.
//  Copyright © 2018 Sara Robinson. All rights reserved.
//

import Foundation

import UIKit

import Charts

extension UITextField {
    
    func underlined(){
        let border = CALayer()
        let width = CGFloat(1.0)
        border.borderColor = UIColor.lightGray.cgColor
        border.frame = CGRect(x: 0, y: self.frame.size.height - width, width:  self.frame.size.width, height: self.frame.size.height)
        border.borderWidth = width
        self.layer.addSublayer(border)
        self.layer.masksToBounds = true
    }
    
}

extension UIColor {
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    convenience init(rgb: Int) {
        self.init(
            red: (rgb >> 16) & 0xFF,
            green: (rgb >> 8) & 0xFF,
            blue: rgb & 0xFF
        )
    }
}

extension LineChartView {
    private class LineChartFormatter: NSObject, IAxisValueFormatter {
        
        var labels: [String] = []
        
        func stringForValue(_ value: Double, axis: AxisBase?) -> String {
            return labels[Int(value)]
        }
        
        init(labels: [String]) {
            super.init()
            self.labels = labels
        }
    }
    
    func setLineChartData(xValues: [String], yValues: [Double], label: String, colorss: Int) {
        var dataEntries: [ChartDataEntry] = []
        
        for i in 0..<yValues.count {
            let dataEntry = ChartDataEntry(x: Double(i), y: yValues[i])
            dataEntries.append(dataEntry)
        }
        
        let chartDataSet = LineChartDataSet(values: dataEntries, label: label)
        let chartData = LineChartData(dataSet: chartDataSet)
        
        let chartFormatter = LineChartFormatter(labels: xValues)
        let xAxis = XAxis()
        xAxis.valueFormatter = chartFormatter
        self.xAxis.valueFormatter = xAxis.valueFormatter
        
        self.data = chartData
        
        // Set up
        self.xAxis.labelPosition = .bottom
        self.xAxis.drawGridLinesEnabled = false
        self.legend.enabled = true
        self.rightAxis.enabled = false
        self.leftAxis.drawGridLinesEnabled = false
        self.leftAxis.drawLabelsEnabled = true
        self.xAxis.labelRotationAngle = 45
        
        var gradientColors = [UIColor.magenta.cgColor, UIColor.clear.cgColor] as CFArray
        var color = UIColor.magenta
        
        //color variable in if conditions is the one passed in as variable
        if(colorss == 1) {
            chartDataSet.colors = [UIColor.magenta] //Sets the colour to magenta
            chartDataSet.setCircleColor(UIColor.magenta)
            chartDataSet.circleHoleColor = UIColor.magenta
            self.legend.colors = [UIColor.magenta]
        } else if (colorss == 2){
            color = UIColor(rgb: 0x559efc)
            chartDataSet.colors = [color] //Sets the colour to magenta
            chartDataSet.setCircleColor(color)
            chartDataSet.circleHoleColor = color
            self.legend.colors = [color]
            gradientColors = [color.cgColor, UIColor.clear.cgColor] as CFArray
        } else if (colorss == 3){
            color = UIColor(rgb: 0xff2d2d)
            chartDataSet.colors = [color] //Sets the colour to magenta
            chartDataSet.setCircleColor(color)
            chartDataSet.circleHoleColor = color
            self.legend.colors = [color]
            gradientColors = [color.cgColor, UIColor.clear.cgColor] as CFArray
        } else {
            color = UIColor(rgb: 0x64dd49)
            chartDataSet.colors = [color] //Sets the colour to magenta
            chartDataSet.setCircleColor(color)
            chartDataSet.circleHoleColor = color
            self.legend.colors = [color]
            gradientColors = [color.cgColor, UIColor.clear.cgColor] as CFArray
        }
        
        chartDataSet.circleRadius = 4.0
        
        //Gradient fill
        let colorLocations: [CGFloat] = [1.0, 0.0]
        guard let gradient = CGGradient.init(colorsSpace: CGColorSpaceCreateDeviceRGB(), colors: gradientColors, locations: colorLocations) else { print("gradient error"); return;
        }
        chartDataSet.fill = Fill.fillWithLinearGradient(gradient, angle: 90.0)
        chartDataSet.drawFilledEnabled = true
        
        self.animate(xAxisDuration: 2.0, yAxisDuration: 2.0, easingOption: .easeInSine)
    }
}

