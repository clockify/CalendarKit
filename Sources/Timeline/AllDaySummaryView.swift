//
//  AllDaySummaryView.swift
//  CalendarKit
//
//  Created by Bozidar Nikolic on 9.12.21.
//

import UIKit

public final class AllDaySummaryView: UIView {
  private var style = AllDaySummaryViewStyle()
  
  private let allDaySummaryHeight: CGFloat = 40.0
  
  public var events: [EventDescriptor] = [] {
    didSet {
      self.reloadData()
    }
  }
  
  public var date: Date = Date() {
    didSet {
      self.reloadDate()
    }
  }
  
  private lazy var dateLabel: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.text = formattedDate(date: date)
    label.textAlignment = .left
    label.setContentCompressionResistancePriority(.required, for: .horizontal)
    return label
  }()
  
  private lazy var timeLabel: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.text = "6:00:00"
    label.textAlignment = .right
    label.setContentCompressionResistancePriority(.required, for: .horizontal)
    return label
  }()
  
  private lazy var stackView: UIStackView = {
    let stack = UIStackView()
    stack.frame = self.bounds
    stack.translatesAutoresizingMaskIntoConstraints = false
    stack.distribution = .equalSpacing
    stack.axis = .horizontal
    stack.backgroundColor = .clear
    stack.isLayoutMarginsRelativeArrangement = true
    stack.layoutMargins = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
    stack.layer.borderColor = UIColor.init(red: 0.8, green: 0.8, blue: 0.8, alpha: 0.8).cgColor
    stack.layer.borderWidth = 1
    stack.addArrangedSubview(dateLabel)
    stack.addArrangedSubview(timeLabel)
    return stack
  }()
  
  
  public func reloadData() {
    var timeInSeconds = 0.0
    for event in events {
      timeInSeconds += event.dateInterval.duration
    }
    
    timeLabel.text = getTimeFrom(seconds: timeInSeconds)
  }
  
  public func reloadDate() {
    dateLabel.text = formattedDate(date: date)
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
    
    addConstraints([
      //ovaj constraint baca gresku u consoli
      NSLayoutConstraint(item: stackView, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1, constant: 0),
      //ili ovaj :)
      NSLayoutConstraint(item: stackView, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1, constant: 0),

      NSLayoutConstraint(item: stackView, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: 0),

      NSLayoutConstraint(item: stackView, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1, constant: 0),

      NSLayoutConstraint(item: stackView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 40)
    ])
    
    heightAnchor.constraint(lessThanOrEqualToConstant: allDaySummaryHeight).isActive = true
    updateStyle(style)
  }
  
  public func updateStyle(_ newStyle: AllDaySummaryViewStyle) {
    style = newStyle
    backgroundColor = style.backgroundColor
    stackView.layer.borderColor = style.borderColor.cgColor
    stackView.layer.borderWidth = style.borderWidth
    dateLabel.font = style.dateLabelFont
    dateLabel.textColor = style.dateLabelColor
    timeLabel.font = style.timeLabelFont
    timeLabel.textColor = style.timeLabelColor
  }
  
  private func formattedDate(date: Date) -> String {
    let formatter = DateFormatter()
    formatter.dateFormat = "EEE, MMM dd"
    formatter.locale = Locale.init(identifier: Locale.preferredLanguages[0])
    return formatter.string(from: date)
  }
  
  private func getTimeFrom(seconds: Double) -> String{
    let secondsInt = Int(seconds)
    let hours = Int(secondsInt / 3600)
    let minutes = Int((secondsInt % 3600) / 60)
    let secondsToPresent = Int((secondsInt % 3600) % 60)
    
    let hoursString = "\(hours)"
    var minutesString = String(format: "%.2d", arguments: [minutes])
    let secondsString = String(format: "%.2d", arguments: [secondsToPresent])
    
    return "\(hoursString):\(minutesString):\(secondsString)"
  }
}
