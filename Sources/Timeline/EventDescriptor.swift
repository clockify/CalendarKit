import Foundation
import UIKit

public protocol EventDescriptor: AnyObject {
  var dateInterval: DateInterval {get set}
  var isAllDay: Bool {get}
  var text: String {get}
  var attributedText: NSAttributedString? {get}
  var lineBreakMode: NSLineBreakMode? {get}
  var font : UIFont {get}
  var color: UIColor {get}
  var textColor: UIColor {get}
  
  var timeLabelText: String {get}
  var timeLabelfont : UIFont {get}
  var timeLabelTextColor: UIColor {get}
  
  var additionalButton1Text: String {get}
  var additionalButton1Font: UIFont {get}
  var additionalButton1TextColor: UIColor {get}
  var additionalButton1Image: UIImage {get}
  var additionalButton1Width: CGFloat {get}
  
  var additionalButton2Text: String {get}
  var additionalButton2Font: UIFont {get}
  var additionalButton2TextColor: UIColor {get}
  var additionalButton2Image: UIImage {get}
  var additionalButton2Width: CGFloat {get}
  
  var additionalButton3Text: String {get}
  var additionalButton3Font: UIFont {get}
  var additionalButton3TextColor: UIColor {get}
  var additionalButton3Image: UIImage {get}
  var additionalButton3Width: CGFloat {get}
  
  var additionalButton4Text: String {get}
  var additionalButton4Font: UIFont {get}
  var additionalButton4TextColor: UIColor {get}
  var additionalButton4Image: UIImage {get}
  var additionalButton4Width: CGFloat {get}
  
  var additionalButton5Text: String {get}
  var additionalButton5Font: UIFont {get}
  var additionalButton5TextColor: UIColor {get}
  var additionalButton5Image: UIImage {get}
  var additionalButton5Width: CGFloat {get}
  
  var backgroundColor: UIColor {get}
  var editedEvent: EventDescriptor? {get set}
  func makeEditable() -> Self
  func commitEditing()
}
