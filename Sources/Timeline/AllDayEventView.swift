//
//  AllDayEventView.swift
//  CalendarKit
//
//  Created by Bozidar Nikolic on 10.12.21.
//

import UIKit

public final class AllDayEventView: UIView {
  private var style = AllDayEventViewStyle()
  
  private let allDayEventHeight: CGFloat = 24.0
  public var allDayEventViewHeight: CGFloat = 0.0
  private var allDayEventViewHeightConstratint = NSLayoutConstraint()
  private let maxViewHeight: CGFloat = 168.0 // equivalent 7 rows 
  
  public var events: [EventDescriptor] = [] {
    didSet {
      self.reloadData()
    }
  }
  
  private lazy var stackView: UIStackView = {
    let stack = UIStackView()
    stack.frame = self.bounds
    stack.translatesAutoresizingMaskIntoConstraints = false
    stack.distribution = .equalSpacing
    stack.axis = .vertical
    stack.backgroundColor = .clear
    stack.isLayoutMarginsRelativeArrangement = true
    stack.layoutMargins = UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 10)
    stack.spacing = 5
    stack.layer.borderColor = UIColor.init(red: 0.8, green: 0.8, blue: 0.8, alpha: 0.8).cgColor
    stack.layer.borderWidth = 1
    return stack
  }()
  
  public func reloadData() {
    
    stackView.arrangedSubviews
                .filter({ $0 is UILabel })
                .forEach({ $0.removeFromSuperview() })
    
    for event in events {
      let label = UILabel()
      label.translatesAutoresizingMaskIntoConstraints = false
      label.text = event.text
      label.textAlignment = .left
      label.setContentCompressionResistancePriority(.required, for: .horizontal)
      stackView.addArrangedSubview(label)
    }
    
    allDayEventViewHeight = allDayEventHeight * CGFloat(events.count)
    
    allDayEventViewHeightConstratint.constant = allDayEventViewHeight
    
    updateStyle(style)
    setNeedsLayout()
    layoutIfNeeded()
  }
  
  // MARK: - RETURN VALUES
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    configure()
  }
  
  required public init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    configure()
  }
  
  private func configure() {
    clipsToBounds = true
    
    addSubview(stackView)
    
    allDayEventViewHeightConstratint =  NSLayoutConstraint(item: stackView,
                                                           attribute: .height,
                                                           relatedBy: .equal,
                                                           toItem: nil,
                                                           attribute: .notAnAttribute,
                                                           multiplier: 1,
                                                           constant: allDayEventViewHeight)
    
    addConstraints([
      //ovaj constraint baca gresku u consoli
      NSLayoutConstraint(item: stackView, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1, constant: 0),
      //ili ovaj :)
      NSLayoutConstraint(item: stackView, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1, constant: 0),

      NSLayoutConstraint(item: stackView, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: 0),

      NSLayoutConstraint(item: stackView, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1, constant: 0),
      
      allDayEventViewHeightConstratint
    ])
    
    heightAnchor.constraint(lessThanOrEqualToConstant: maxViewHeight).isActive = true
    updateStyle(style)
  }
  
  public func updateStyle(_ newStyle: AllDayEventViewStyle) {
    style = newStyle
    backgroundColor = style.backgroundColor
    stackView.layer.borderColor = style.borderColor.cgColor
    stackView.layer.borderWidth = style.borderWidth

    for label in stackView.arrangedSubviews {
      if label is UILabel {
        if let labelTmp = label as? UILabel {
          labelTmp.font = style.allDayEventFont
          labelTmp.textColor = style.allDayEventColor
        }
      }
    }
  }
}

