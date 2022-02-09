//
//  IndicatorView.swift
//  ScrollViewIndicatorView
//
//  Created by Neal Wills on 2022/2/9.
//

import UIKit
 

class IndicatorView: UIView {
	
	var gap: CGFloat = 15
	var count: Int = 0
	
	private var indicatorList:[UIView] = .init()
	private var indicatorMaskList:[UIView] = .init()
	private var fromIndex: Int = 0
	private var toIndex: Int = 1
	private var itemWidth: CGFloat = 0
	private var maxItemWidthScale: CGFloat = 0.3
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		self.initSubviews()
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	func reloadData(count: Int) {
		self.count = count
		self.indicatorList.removeAll()
		self.indicatorMaskList.removeAll()
		self.subviews.forEach { $0.removeFromSuperview() }
		self.initSubviews()
	}
	
	private func initSubviews() {
		
		if self.count < 1 {
			return
		}
		
		let width = (self.frame.width - self.gap * (Double(self.count) - 1)) / (Double(self.count) + self.maxItemWidthScale)
		self.itemWidth = width
		
		for i in 0..<self.count {
			var itemLeading:CGFloat = 0
			let itemTop:CGFloat = 0
			let itemHeight:CGFloat = self.frame.height
			var itemWidth:CGFloat = width * (1 + self.maxItemWidthScale)
			let itemBackGroundColor: UIColor = UIColor.systemPink
			let itemMaskBackGroundColor: UIColor = UIColor.lightGray
			if i > 0 {
				itemLeading = width * self.maxItemWidthScale + (width + self.gap) * Double(i)
				itemWidth = width
			}
			let item = UIView.init(frame: CGRect.init(x: itemLeading, y: itemTop, width: itemWidth, height: itemHeight))
			item.layer.cornerRadius = itemHeight / 2.0
			item.backgroundColor = itemBackGroundColor
			item.clipsToBounds = true
			self.addSubview(item)
			
			let itemMask = UIView.init(frame: item.frame)
			itemMask.layer.cornerRadius = itemHeight / 2.0
			itemMask.backgroundColor = itemMaskBackGroundColor
			itemMask.clipsToBounds = true
			self.addSubview(itemMask)
			
			itemMask.alpha = i == 0 ? 0 : 1
			
			self.indicatorList.append(item)
			self.indicatorMaskList.append(itemMask)
		}
	}
	
	func scrollAction(to toIndex: Int, from fromIndex: Int, progress: CGFloat) {
		self.toIndex = toIndex
		self.fromIndex = fromIndex
		
		var newProgress = progress > 1 ? 1 : progress
		newProgress = newProgress < 0 ? 0 : newProgress
		
		let toWidth = self.itemWidth + self.itemWidth * self.maxItemWidthScale * newProgress
		let fromWidth = self.itemWidth * self.maxItemWidthScale * (1 - newProgress) + self.itemWidth
		let toAlpha = 1 - newProgress
		let fromAlpha = newProgress
		
		for i in 0..<self.count {
			var itemLeading:CGFloat = 0
			let itemTop:CGFloat = 0
			let itemHeight:CGFloat = self.frame.height
			var itemWidth:CGFloat = self.itemWidth
			var itemMaskAlpha = 1.0
			if i == fromIndex {
				itemWidth = fromWidth
				itemMaskAlpha = fromAlpha
			}
			if i == toIndex {
				itemWidth = toWidth
				itemMaskAlpha = toAlpha
			}
			if i > 0 {
				itemLeading = self.indicatorList[i - 1].frame.origin.x + self.indicatorList[i - 1].frame.width + self.gap
			}
			self.indicatorList[i].frame = CGRect.init(x: itemLeading, y: itemTop, width: itemWidth, height: itemHeight)
			self.indicatorMaskList[i].frame = self.indicatorList[i].frame
			self.indicatorMaskList[i].alpha = itemMaskAlpha
		}
		
	}
	
}
