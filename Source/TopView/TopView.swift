import UIKit

protocol TopViewDelegate {

  func flashButtonDidPress(title: String)
  func rotateDeviceDidPress()
}

class TopView: UIView {

  struct Dimensions {
    static let leftOffset: CGFloat = 11
    static let rightOffset: CGFloat = 11
    static let height: CGFloat = 34
  }

  lazy var flashButton: UIButton = { [unowned self] in
    let button = UIButton()
    button.setImage(self.getImage("flashIcon"), forState: .Normal)
    button.setTitle("AUTO", forState: .Normal)
    button.titleEdgeInsets = UIEdgeInsetsMake(0, 4, 0, 0)
    button.setTitleColor(UIColor(red:0.98, green:0.98, blue:0.45, alpha:1), forState: .Normal)
    button.setTitleColor(UIColor(red:0.52, green:0.52, blue:0.24, alpha:1), forState: .Highlighted)
    button.titleLabel?.font = self.configuration.flashButton
    button.setTranslatesAutoresizingMaskIntoConstraints(false)
    button.addTarget(self, action: "flashButtonDidPress:", forControlEvents: .TouchUpInside)
    button.contentHorizontalAlignment = .Left

    return button
    }()

  lazy var rotateCamera: UIButton = { [unowned self] in
    let button = UIButton()
    button.setImage(self.getImage("cameraIcon"), forState: .Normal)
    button.setTranslatesAutoresizingMaskIntoConstraints(false)
    button.addTarget(self, action: "rotateCameraButtonDidPress:", forControlEvents: .TouchUpInside)

    return button
    }()

  lazy var configuration: PickerConfiguration = {
    let configuration = PickerConfiguration()
    return configuration
    }()

  var delegate: TopViewDelegate?

  // MARK: - Initializers

  override init(frame: CGRect) {
    super.init(frame: frame)

    [flashButton, rotateCamera].map { self.addSubview($0) }

    setupConstraints()
  }

  required init(coder aDecoder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
  }

  // MARK: - Constraints

  func setupConstraints() {
    addConstraint(NSLayoutConstraint(item: flashButton, attribute: .Left,
      relatedBy: .Equal, toItem: self, attribute: .Left,
      multiplier: 1, constant: Dimensions.leftOffset))

    addConstraint(NSLayoutConstraint(item: flashButton, attribute: .CenterY,
      relatedBy: .Equal, toItem: self, attribute: .CenterY,
      multiplier: 1, constant: 0))

    addConstraint(NSLayoutConstraint(item: flashButton, attribute: .Width,
      relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute,
      multiplier: 1, constant: 55))

    addConstraint(NSLayoutConstraint(item: rotateCamera, attribute: .Right,
      relatedBy: .Equal, toItem: self, attribute: .Right,
      multiplier: 1, constant: -Dimensions.rightOffset))

    addConstraint(NSLayoutConstraint(item: rotateCamera, attribute: .CenterY,
      relatedBy: .Equal, toItem: self, attribute: .CenterY,
      multiplier: 1, constant: 0))
  }

  // MARK: - Action methods

  func flashButtonDidPress(button: UIButton) {
    if button.currentTitle! == "AUTO" {
      button.setImage(self.getImage("flashIconOn"), forState: .Normal)
      button.setTitleColor(UIColor.whiteColor(), forState: .Normal)
      button.setTitleColor(UIColor.whiteColor(), forState: .Highlighted)
      button.setTitle("ON", forState: .Normal)
    } else if button.currentTitle! == "ON" {
      button.setImage(self.getImage("flashIconOff"), forState: .Normal)
      button.setTitle("OFF", forState: .Normal)
    } else if button.currentTitle! == "OFF" {
      button.setImage(self.getImage("flashIcon"), forState: .Normal)
      button.setTitleColor(UIColor(red:0.98, green:0.98, blue:0.45, alpha:1), forState: .Normal)
      button.setTitleColor(UIColor(red:0.52, green:0.52, blue:0.24, alpha:1), forState: .Highlighted)
      button.setTitle("AUTO", forState: .Normal)
    }

    delegate?.flashButtonDidPress(button.currentTitle!)
  }

  func rotateCameraButtonDidPress(button: UIButton) {
    delegate?.rotateDeviceDidPress()
  }

  // MARK: - Private helpers

  func getImage(name: String) -> UIImage {
    let bundlePath = NSBundle(forClass: self.classForCoder).resourcePath?.stringByAppendingString("/ImagePicker.bundle")
    let bundle = NSBundle(path: bundlePath!)
    let traitCollection = UITraitCollection(displayScale: 3)
    let image = UIImage(named: name, inBundle: bundle, compatibleWithTraitCollection: traitCollection)

    return image!
  }
}
