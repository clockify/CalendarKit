import UIKit

public final class Event: EventDescriptor {
  
  public var additionalButton1Text: String = ""
  public var additionalButton1Font: UIFont = UIFont.systemFont(ofSize: 12)
  public var additionalButton1TextColor: UIColor = SystemColors.label
  public var additionalButton1Image: UIImage = UIImage()
  public var additionalButton1Width: CGFloat = 0
  
  public var additionalButton2Text: String = ""
  public var additionalButton2Font: UIFont = UIFont.systemFont(ofSize: 12)
  public var additionalButton2TextColor: UIColor = SystemColors.label
  public var additionalButton2Image: UIImage = UIImage()
  public var additionalButton2Width: CGFloat = 0
  
  public var additionalButton3Text: String = ""
  public var additionalButton3Font: UIFont = UIFont.systemFont(ofSize: 12)
  public var additionalButton3TextColor: UIColor = SystemColors.label
  public var additionalButton3Image: UIImage = UIImage()
  public var additionalButton3Width: CGFloat = 0
  
  public var additionalButton4Text: String = ""
  public var additionalButton4Font: UIFont = UIFont.systemFont(ofSize: 12)
  public var additionalButton4TextColor: UIColor = SystemColors.label
  public var additionalButton4Image: UIImage = UIImage()
  public var additionalButton4Width: CGFloat = 0
  
  public var additionalButton5Text: String = ""
  public var additionalButton5Font: UIFont = UIFont.systemFont(ofSize: 12)
  public var additionalButton5TextColor: UIColor = SystemColors.label
  public var additionalButton5Image: UIImage = UIImage()
  public var additionalButton5Width: CGFloat = 0
  
  public var timeLabelText: String = ""
  public var timeLabelfont: UIFont = UIFont.systemFont(ofSize: 12)
  public var timeLabelTextColor: UIColor = SystemColors.label
  
  public var dateInterval = DateInterval()
  public var isAllDay = false
  public var text = ""
  public var attributedText: NSAttributedString?
  public var lineBreakMode: NSLineBreakMode?
  public var color = SystemColors.systemBlue {
    didSet {
      updateColors()
    }
  }
  public var backgroundColor = SystemColors.systemBlue.withAlphaComponent(0.3)
  public var textColor = SystemColors.label
  public var font = UIFont.boldSystemFont(ofSize: 12)
  public var userInfo: Any?
  public weak var editedEvent: EventDescriptor? {
    didSet {
      updateColors()
    }
  }

  public init() {}

  public func makeEditable() -> Event {
    let cloned = Event()
    cloned.dateInterval = dateInterval
    cloned.isAllDay = isAllDay
    cloned.text = text
    cloned.attributedText = attributedText
    cloned.lineBreakMode = lineBreakMode
    cloned.color = color
    cloned.backgroundColor = backgroundColor
    cloned.textColor = textColor
    cloned.userInfo = userInfo
    cloned.timeLabelText = timeLabelText
    cloned.timeLabelTextColor = timeLabelTextColor

    cloned.additionalButton1Text = additionalButton1Text
    cloned.additionalButton1Image = additionalButton1Image
    cloned.additionalButton1Width = additionalButton1Width
    
    cloned.additionalButton2Text = additionalButton2Text
    cloned.additionalButton2Image = additionalButton2Image
    cloned.additionalButton2Width = additionalButton2Width
    
    cloned.additionalButton3Text = additionalButton3Text
    cloned.additionalButton3Image = additionalButton3Image
    cloned.additionalButton3Width = additionalButton3Width
    
    cloned.additionalButton4Text = additionalButton4Text
    cloned.additionalButton4Image = additionalButton4Image
    cloned.additionalButton4Width = additionalButton4Width
    
    cloned.additionalButton5Text = additionalButton5Text
    cloned.additionalButton5Image = additionalButton5Image
    cloned.additionalButton5Width = additionalButton5Width
    
    cloned.editedEvent = self
    return cloned
  }

  public func commitEditing() {
    guard let edited = editedEvent else {return}
    edited.dateInterval = dateInterval
  }

  private func updateColors() {
    (editedEvent != nil) ? applyEditingColors() : applyStandardColors()
  }
  
  /// Colors used when event is not in editing mode
  private func applyStandardColors() {
    backgroundColor = dynamicStandardBackgroundColor()
    textColor = dynamicStandardTextColor()
  }
  
  /// Colors used in editing mode
  private func applyEditingColors() {
    backgroundColor = color.withAlphaComponent(0.95)
    textColor = .white
  }
  
  /// Dynamic color that changes depending on the user interface style (dark / light)
  private func dynamicStandardBackgroundColor() -> UIColor {
    let light = backgroundColorForLightTheme(baseColor: color)
    let dark = backgroundColorForDarkTheme(baseColor: color)
    return dynamicColor(light: light, dark: dark)
  }
  
  /// Dynamic color that changes depending on the user interface style (dark / light)
  private func dynamicStandardTextColor() -> UIColor {
    let light = textColorForLightTheme(baseColor: color)
    return dynamicColor(light: light, dark: color)
  }
  
  private func textColorForLightTheme(baseColor: UIColor) -> UIColor {
    var h: CGFloat = 0, s: CGFloat = 0, b: CGFloat = 0, a: CGFloat = 0
    baseColor.getHue(&h, saturation: &s, brightness: &b, alpha: &a)
    return UIColor(hue: h, saturation: s, brightness: b * 0.4, alpha: a)
  }
  
  private func backgroundColorForLightTheme(baseColor: UIColor) -> UIColor {
    baseColor.withAlphaComponent(0.3)
  }
  
  private func backgroundColorForDarkTheme(baseColor: UIColor) -> UIColor {
    var h: CGFloat = 0, s: CGFloat = 0, b: CGFloat = 0, a: CGFloat = 0
    color.getHue(&h, saturation: &s, brightness: &b, alpha: &a)
    return UIColor(hue: h, saturation: s, brightness: b * 0.4, alpha: a * 0.8)
  }
  
  private func dynamicColor(light: UIColor, dark: UIColor) -> UIColor {
    if #available(iOS 13.0, *) {
      return UIColor { traitCollection in
        let interfaceStyle = traitCollection.userInterfaceStyle
        switch interfaceStyle {
        case .dark:
          return dark
        default:
          return light
        }
      }
    } else {
      return light
    }
  }
}
