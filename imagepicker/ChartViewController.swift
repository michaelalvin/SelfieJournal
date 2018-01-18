////
////  ChartViewController.swift
////  imagepicker
////
////  Created by Michael Alvin on 1/16/18.
////  Copyright © 2018 Sara Robinson. All rights reserved.
////
//
//import UIKit
//import Charts
//
//protocol GetChartData {
//    func getChartData(with dataPoints: [String], values: [String])
//    var workoutDuration: [String] {get set}
//    var beatsPerMinute: [String] {get set}
//}
//
//class ChartViewController: UIViewController, GetChartData {
//
//    var workoutDuration = [String]()
//    var beatsPerMinute = [String]()
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        populateChartData()
//        //barChart()
//
//        // Do any additional setup after loading the view.
//    }
//
//    override func didReceiveMemoryWarning() {
//        super.didReceiveMemoryWarning()
//        // Dispose of any resources that can be recreated.
//    }
//
//    func populateChartData() {
//        workoutDuration = ["1", "2", "3", "4", "5"]
//        beatsPerMinute = ["21", "41", "22", "24", "59"]
//        self.getChartData(with: workoutDuration, values: beatsPerMinute)
//    }
//
//    //Chart Options and Chart Constructors
//    func barChart() {
//
//    }
//
//    func lineChart() {
//
//    }
//
//    func cubicChart() {
//
//    }
//
//    func getChartData(with dataPoints: [String], values: [String]) {
//        self.workoutDuration = dataPoints
//        self.beatsPerMinute = values
//    }
//
//    public class ChartFormatter: NSObject, IAxisValueFormatter {
//        var workoutDuration = [String]()
//
//        public func stringForValue(_ value: Double, axis: AxisBase?) -> String {
//            return workoutDuration[Int(value)]
//        }
//
//        public func setValues(values: [String]) {
//            self.workoutDuration = values
//        }
//    }
//}

