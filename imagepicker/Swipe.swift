//
//  Swipe.swift
//  imagepicker
//
//  Created by Michael Alvin on 1/29/18.
//  Copyright © 2018 Sara Robinson. All rights reserved.
//

import Foundation
import UIKit

//
//  UISwipeGestureRecognizer.h
//  UIKit
//
//  Copyright (c) 2009-2015 Apple Inc. All rights reserved.
//

// Recognizes: when numberOfTouchesRequired have moved mostly in the specified direction, enough to be considered a swipe.
//             a slow swipe requires high directional precision but a small distance
//             a fast swipe requires low directional precision but a large distance

// Touch Location Behaviors:
//     locationInView:         location where the swipe began. this is the centroid if more than one touch was involved
//     locationOfTouch:inView: location of a particular touch when the swipe began

public struct UISwipeGestureRecognizerDirection : OptionSetType {
    public init(rawValue: UInt)
    
    public static var Right: UISwipeGestureRecognizerDirection { get }
    public static var Left: UISwipeGestureRecognizerDirection { get }
    public static var Up: UISwipeGestureRecognizerDirection { get }
    public static var Down: UISwipeGestureRecognizerDirection { get }
}

@available(iOS 3.2, *)
public class UISwipeGestureRecognizer : UIGestureRecognizer {
    
    public var numberOfTouchesRequired: Int // default is 1. the number of fingers that must swipe
    public var direction: UISwipeGestureRecognizerDirection // default is UISwipeGestureRecognizerDirectionRight. the desired direction of the swipe. multiple directions may be specified if they will result in the same behavior (for example, UITableView swipe delete)
}
