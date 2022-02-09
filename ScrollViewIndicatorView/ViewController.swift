//
//  ViewController.swift
//  ScrollViewIndicatorView
//
//  Created by Neal Wills on 2022/2/9.
//

import UIKit

class ViewController: UIViewController {
	
	var indicator: IndicatorView?
	var progressView: UIProgressView?
	var toIndex: Int = 1
	var fromIndex: Int = 0

	override func viewDidLoad() {
		super.viewDidLoad()
		
		self.indicator = IndicatorView.init(frame: CGRect.init(x: 40, y: 200, width: 200, height: 5))
		self.view.addSubview(self.indicator!)
		
		let btn = UIButton.init(frame: CGRect.init(x: 80, y: 260, width: 40, height: 40))
		self.view.addSubview(btn)
		btn.backgroundColor = UIColor.black
		btn.addTarget(self, action: #selector(btnAction), for: .touchUpInside)
		
		self.progressView = UIProgressView.init(progressViewStyle: .default)
		self.progressView?.frame = CGRect.init(x: 80, y: 230, width: 200, height: 10)
		self.view.addSubview(self.progressView!)
		
		self.indicator?.reloadData(count: 5)
		
	}
	
	@objc func btnAction() {
		self.toIndex = Int(arc4random() % 5)
		self.fromIndex = Int(arc4random() % 5)
		if (self.toIndex == self.fromIndex) {
			self.toIndex = (self.fromIndex + 1) % 5
		}
		let progress: CGFloat = CGFloat(self.progressView?.progress ?? 0)
		self.indicator?.scrollAction(to: self.toIndex, from: self.fromIndex, progress: progress)
	}
	
	
	override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
		let toouch = touches.first
		let p = toouch?.location(in: self.progressView) ?? CGPoint.zero
		var progress = p.x / (self.progressView?.frame.width ?? 1)
		progress = progress > 1 ? 1 : progress
		progress = progress < 0 ? 0 : progress
		self.progressView?.progress = Float(progress)
		self.indicator?.scrollAction(to: self.toIndex, from: self.fromIndex, progress: progress)
	}
	
	override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
		let toouch = touches.first
		let p = toouch?.location(in: self.progressView) ?? CGPoint.zero
		var progress = p.x / (self.progressView?.frame.width ?? 1)
		progress = progress > 1 ? 1 : progress
		progress = progress < 0 ? 0 : progress
		self.progressView?.progress = Float(progress)
		self.indicator?.scrollAction(to: self.toIndex, from: self.fromIndex, progress: progress)
	}

}

