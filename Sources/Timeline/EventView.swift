import UIKit

open class EventView: UIView {
  public var descriptor: EventDescriptor?
  public var color = SystemColors.label
  
  private let stackViewMaxHeight: CGFloat = 20.0
  private var stackViewHeight: CGFloat = 0.0
  private let stackViewSpace: CGFloat = 3.0

  public var contentHeight: CGFloat {
    return (textView.frame.height + stackView.frame.height)
  }

  public lazy var textView: UITextView = {
    let view = UITextView()
    view.isUserInteractionEnabled = false
    view.backgroundColor = .clear
    view.isScrollEnabled = false
    return view
  }()
  
  public lazy var stackView: UIStackView = {
    let stack = UIStackView()
    stack.distribution = .fill
    stack.axis = .horizontal
    stack.backgroundColor = .clear
    stack.isLayoutMarginsRelativeArrangement = true
    stack.layoutMargins = UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 10)
    stack.spacing = stackViewSpace

    stack.addArrangedSubview(additionalButton1)
    stack.addArrangedSubview(additionalButton2)
    stack.addArrangedSubview(additionalButton3)
    stack.addArrangedSubview(additionalButton4)
    stack.addArrangedSubview(additionalButton5)
    stack.addArrangedSubview(UIStackView())
    stack.addArrangedSubview(timeLabel)
    
    return stack
  }()
  
  public lazy var timeLabel: UILabel = {
    let label = UILabel()
    label.textAlignment = .right
    return label
  }()
  
  public lazy var additionalButton1: UIButton = {
    let button = UIButton()
    return button
  }()
  
  public lazy var additionalButton2: UIButton = {
    let button = UIButton()
    return button
  }()
  
  public lazy var additionalButton3: UIButton = {
    let button = UIButton()
    return button
  }()
  
  public lazy var additionalButton4: UIButton = {
    let button = UIButton()
    return button
  }()
  
  public lazy var additionalButton5: UIButton = {
    let button = UIButton()
    return button
  }()
  

  /// Resize Handle views showing up when editing the event.
  /// The top handle has a tag of `0` and the bottom has a tag of `1`
  public lazy var eventResizeHandles = [EventResizeHandleView(), EventResizeHandleView()]

  override public init(frame: CGRect) {
    super.init(frame: frame)
    configure()
  }

  required public init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    configure()
  }

  private func configure() {
    clipsToBounds = false
    color = tintColor
    
    addSubview(textView)
    addSubview(stackView)

    for (idx, handle) in eventResizeHandles.enumerated() {
      handle.tag = idx
      addSubview(handle)
    }
  }

  public func updateWithDescriptor(event: EventDescriptor) {
    if let attributedText = event.attributedText {
      textView.attributedText = attributedText
    } else {
      textView.text = event.text
      textView.textColor = event.textColor
      textView.font = event.font
    }
    
    additionalButton1.constraints.first { $0.firstAnchor == widthAnchor }?.isActive = false
    additionalButton1.setTitle(event.additionalButton1Text, for: .normal)
    additionalButton1.setTitleColor(event.additionalButton1TextColor, for: .normal)
    additionalButton1.setImage(event.additionalButton1Image, for: .normal)
    additionalButton1.titleLabel?.font = event.additionalButton1Font
    additionalButton1.addWidthConstraint(event.additionalButton1Width)
    
    additionalButton2.constraints.first { $0.firstAnchor == widthAnchor }?.isActive = false
    additionalButton2.setTitle(event.additionalButton2Text, for: .normal)
    additionalButton2.setTitleColor(event.additionalButton2TextColor, for: .normal)
    additionalButton2.titleLabel?.font = event.additionalButton2Font
    additionalButton2.setImage(event.additionalButton2Image, for: .normal)
    additionalButton2.addWidthConstraint(event.additionalButton2Width)
    
    additionalButton3.constraints.first { $0.firstAnchor == widthAnchor }?.isActive = false
    additionalButton3.setTitle(event.additionalButton3Text, for: .normal)
    additionalButton3.setTitleColor(event.additionalButton3TextColor, for: .normal)
    additionalButton3.titleLabel?.font = event.additionalButton3Font
    additionalButton3.setImage(event.additionalButton3Image, for: .normal)
    additionalButton3.addWidthConstraint(event.additionalButton3Width)
    
    additionalButton4.constraints.first { $0.firstAnchor == widthAnchor }?.isActive = false
    additionalButton4.setTitle(event.additionalButton4Text, for: .normal)
    additionalButton4.setTitleColor(event.additionalButton4TextColor, for: .normal)
    additionalButton4.titleLabel?.font = event.additionalButton4Font
    additionalButton4.setImage(event.additionalButton4Image, for: .normal)
    additionalButton4.addWidthConstraint(event.additionalButton4Width)
    
    additionalButton5.constraints.first { $0.firstAnchor == widthAnchor }?.isActive = false
    additionalButton5.setTitle(event.additionalButton5Text, for: .normal)
    additionalButton5.setTitleColor(event.additionalButton5TextColor, for: .normal)
    additionalButton5.setImage(event.additionalButton5Image, for: .normal)
    additionalButton5.titleLabel?.font = event.additionalButton5Font
    additionalButton5.addWidthConstraint(event.additionalButton5Width)
    
    timeLabel.text = event.timeLabelText
    timeLabel.textColor = event.timeLabelTextColor
    timeLabel.font = event.timeLabelfont
    
    if let lineBreakMode = event.lineBreakMode {
      textView.textContainer.lineBreakMode = lineBreakMode
    }
    descriptor = event
    backgroundColor = event.backgroundColor
    color = event.color
    eventResizeHandles.forEach{
      $0.borderColor = event.color
      $0.isHidden = event.editedEvent == nil
    }
    drawsShadow = event.editedEvent != nil
    setNeedsDisplay()
    setNeedsLayout()
  }
  
  public func animateCreation() {
    transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
    func scaleAnimation() {
      transform = .identity
    }
    UIView.animate(withDuration: 0.2,
                   delay: 0,
                   usingSpringWithDamping: 0.2,
                   initialSpringVelocity: 10,
                   options: [],
                   animations: scaleAnimation,
                   completion: nil)
  }

  /**
   Custom implementation of the hitTest method is needed for the tap gesture recognizers
   located in the ResizeHandleView to work.
   Since the ResizeHandleView could be outside of the EventView's bounds, the touches to the ResizeHandleView
   are ignored.
   In the custom implementation the method is recursively invoked for all of the subviews,
   regardless of their position in relation to the Timeline's bounds.
   */
  public override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
    for resizeHandle in eventResizeHandles {
      if let subSubView = resizeHandle.hitTest(convert(point, to: resizeHandle), with: event) {
        return subSubView
      }
    }
    return super.hitTest(point, with: event)
  }

  override open func draw(_ rect: CGRect) {
    super.draw(rect)
    guard let context = UIGraphicsGetCurrentContext() else {
      return
    }
    context.interpolationQuality = .none
    context.saveGState()
    context.setStrokeColor(color.cgColor)
    context.setLineWidth(3)
    context.translateBy(x: 0, y: 0.5)
    let leftToRight = UIView.userInterfaceLayoutDirection(for: semanticContentAttribute) == .leftToRight
    let x: CGFloat = leftToRight ? 0 : frame.width - 1  // 1 is the line width
    let y: CGFloat = 0
    context.beginPath()
    context.move(to: CGPoint(x: x, y: y))
    context.addLine(to: CGPoint(x: x, y: (bounds).height))
    context.strokePath()
    context.restoreGState()
  }

  private var drawsShadow = false

  override open func layoutSubviews() {
    super.layoutSubviews()
    
    if bounds.height < 40 {
      stackViewHeight = bounds.height - 15
    } else {
      stackViewHeight = stackViewMaxHeight
    }
    
    
    textView.frame = {
        if UIView.userInterfaceLayoutDirection(for: semanticContentAttribute) == .rightToLeft {
            return CGRect(x: bounds.minX, y: bounds.minY, width: bounds.width - 3, height: bounds.height - stackViewHeight)
        } else {
            return CGRect(x: bounds.minX + 3, y: bounds.minY, width: bounds.width - 3, height: bounds.height - stackViewHeight)
        }
    }()
    
   
    stackView.frame = {
      return CGRect(x: bounds.minX, y: textView.frame.height, width: bounds.width - 3, height: stackViewHeight)
    }()
    
    if frame.minY < 0 {
      var textFrame = textView.frame;
      textFrame.origin.y = frame.minY * -1;
      textFrame.size.height += frame.minY;
      textView.frame = textFrame;
      stackView.frame = textFrame;
    }

    let first = eventResizeHandles.first
    let last = eventResizeHandles.last
    let radius: CGFloat = 40
    let yPad: CGFloat =  -radius / 2
    let width = bounds.width
    let height = bounds.height
    let size = CGSize(width: radius, height: radius)
    first?.frame = CGRect(origin: CGPoint(x: width - radius - layoutMargins.right, y: yPad),
                          size: size)
    last?.frame = CGRect(origin: CGPoint(x: layoutMargins.left, y: height - yPad - radius),
                         size: size)
    
    if drawsShadow {
      applySketchShadow(alpha: 0.13,
                        blur: 10)
    }
  }

  private func applySketchShadow(
    color: UIColor = .black,
    alpha: Float = 0.5,
    x: CGFloat = 0,
    y: CGFloat = 2,
    blur: CGFloat = 4,
    spread: CGFloat = 0)
  {
    layer.shadowColor = color.cgColor
    layer.shadowOpacity = alpha
    layer.shadowOffset = CGSize(width: x, height: y)
    layer.shadowRadius = blur / 2.0
    if spread == 0 {
      layer.shadowPath = nil
    } else {
      let dx = -spread
      let rect = bounds.insetBy(dx: dx, dy: dx)
      layer.shadowPath = UIBezierPath(rect: rect).cgPath
    }
  }
}

extension UIView {
    
    public func removeAllConstraints() {
        var _superview = self.superview
        
        while let superview = _superview {
            for constraint in superview.constraints {
                
                if let first = constraint.firstItem as? UIView, first == self {
                    superview.removeConstraint(constraint)
                }
                
                if let second = constraint.secondItem as? UIView, second == self {
                    superview.removeConstraint(constraint)
                }
            }
            
            _superview = superview.superview
        }
        
        self.removeConstraints(self.constraints)
        self.translatesAutoresizingMaskIntoConstraints = true
    }
  
  public func addWidthConstraint(_ width: CGFloat) {
    let constraintButtonPlayWidth = NSLayoutConstraint (item: self,
                                                        attribute: .width,
                                                        relatedBy: .equal,
                                                        toItem: nil,
                                                        attribute: .notAnAttribute,
                                                        multiplier: 1,
                                                        constant: width)
    self.addConstraint(constraintButtonPlayWidth)
  }
}
