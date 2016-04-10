//
//  ViewController.swift
//  rotation
//
//  Created by Ankit Aggarwal on 20/04/16.
//  Copyright © 2016 ankit.im. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet var pie: Pie!

    override func viewDidLoad() {
        super.viewDidLoad()
        let tap = UITapGestureRecognizer(target: self, action: #selector(ViewController.animate))
        view.addGestureRecognizer(tap)
    }

    var percent = 0.0

    func animate() {
        percent += 25
        pie.animateToPercent(percent%100)
    }
}


class Pie: UIView {

    var hand: CAShapeLayer!

    var circleCenter = CGPoint.zero
    var circleRadius = CGFloat(0)

    func angleFromPercent(percent: Double) -> Double {
        let angle = (360.0/100.0) * percent
        return (angle * (M_PI / 180.0))
    }

    func animateToPercent(percent: Double) {
        let rotationAngle = CGFloat(angleFromPercent(percent))
        let rotationPoint = circleCenter
        let center = CGPointMake(0, 0)

        self.hand.anchorPoint = CGPointMake(0.5, 1)
        var transform = CATransform3DIdentity;
        transform = CATransform3DTranslate(transform, rotationPoint.x-center.x, rotationPoint.y-center.y, 0.0);
        transform = CATransform3DRotate(transform, rotationAngle, 0.0, 0.0, 1.0);
        transform = CATransform3DTranslate(transform, center.x-rotationPoint.x, center.y-rotationPoint.y, 0.0);
        UIView.animateWithDuration(0.3) {
            self.hand.transform = transform
        }
    }

    override func drawRect(rect: CGRect) {
        // Draw base circle.
        circleRadius = (min(rect.width, rect.height))/2 - 4
        circleCenter = CGPoint(x: rect.width/2, y: rect.height/2)
        let circle = UIBezierPath(arcCenter: circleCenter,
                                  radius: circleRadius,
                                  startAngle: 0,
                                  endAngle: CGFloat(2 * M_PI),
                                  clockwise: true)
        UIColor(white: 1.0, alpha: 0.4).setFill()
        circle.fill()


        // Draw Hand.

        let radAngle = angleFromPercent(0) + M_PI_2
        let x = circleCenter.x - circleRadius * CGFloat(cos(radAngle))
        let y = circleCenter.y - circleRadius * CGFloat(sin(radAngle))
        let point = CGPointMake(x, y)

        let line = UIBezierPath()
        line.moveToPoint(circleCenter)
        line.addLineToPoint(point)
        line.lineWidth = 1.5
        line.lineCapStyle = CGLineCap.Round
        line.lineJoinStyle = CGLineJoin.Round

        hand = CAShapeLayer()
        hand.strokeColor = UIColor(red: 176/255.0, green: 170/255.0, blue: 192/255.0, alpha: 1.0).CGColor
        hand.lineWidth = 2.5
        hand.path = line.CGPath
        layer.addSublayer(hand)
    }
}
