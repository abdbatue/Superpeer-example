//
//  ViewController.swift
//  Superpeer
//
//  Created by abdbatue on 19.09.2020.
//

import UIKit
import AVFoundation

class ViewController: UIViewController, UITextFieldDelegate {
    
    // For camera
    private var videoDeviceInput: AVCaptureDeviceInput?
    private var sessionQueue: DispatchQueue!
    private var session: AVCaptureSession?
    
    // Views for camera
    private var previewBackView: UIView!
    private var previewView: AVCaptureVideoPreviewLayer!
    
    // Views
    private var containerView: UIView!
    
    // CircleButtons
    private let circleCameraButton = CircleButton(image: Icons.camera!)
    private let circleMicrophoneButton = CircleButton(image: Icons.microphone!)
    
    // Sizes
    private var containerViewHeight: CGFloat = Device.screenSize.height
    
    // After Call Views
    private var calledTopView: UIView!
    
    // Status
    private var joined: Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder .keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        self.view.backgroundColor = Colors.gray90
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        
        // Camera Preview
        self.previewBackView = UIView(frame: self.view.bounds)
        self.previewBackView.layer.masksToBounds = true
        self.view.addSubview(previewBackView)
        
        let session: AVCaptureSession = AVCaptureSession()
        self.session = session
        
        self.previewView = AVCaptureVideoPreviewLayer()
        self.previewView.session = session
        self.previewView.frame = previewBackView.bounds
        self.previewView.videoGravity = .resizeAspectFill
        
        self.previewBackView.layer.addSublayer(previewView)
        
        self.sessionQueue = DispatchQueue(label: "superpeer.Superpeer")
        self.sessionQueue.async {
            let videoDevice: AVCaptureDevice = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .front)?
                        
            var videoDeviceInput: AVCaptureDeviceInput?
            do {
                videoDeviceInput = try AVCaptureDeviceInput(device: videoDevice)
            } catch {
                print("Unable to add camera device.")
            }

            if session.canAddInput(videoDeviceInput!){
                session.addInput(videoDeviceInput!)
                self.videoDeviceInput = videoDeviceInput
                
                DispatchQueue.main.async {
                    let orientation: AVCaptureVideoOrientation = AVCaptureVideoOrientation(rawValue: UIInterfaceOrientation.portrait.rawValue)!
            
                    self.previewView.connection?.videoOrientation = orientation
                }
            }
            
            let audioDevice: AVCaptureDevice = AVCaptureDevice.default(for: .audio)!
            var audioInput: AVCaptureDeviceInput?
            do {
                audioInput = try AVCaptureDeviceInput(device: audioDevice)
            } catch {
                print("Unable to add audio device.")
            }
            
            if session.canAddInput(audioInput!){
                session.addInput(audioInput!)
            }
        }
        // Show Camera
        self.session?.startRunning()
        
        // Container View
        containerView = UIView(frame: CGRect(x: 0, y: 0, width: Device.screenSize.width, height: containerViewHeight))
        
        let containerViewCorners = CAShapeLayer()
        containerViewCorners.bounds = containerView.frame
        containerViewCorners.position = containerView.center
        containerViewCorners.path = UIBezierPath(roundedRect: containerView.bounds, byRoundingCorners: [.topRight , .topLeft], cornerRadii: CGSize(width: Data.cornerRadius * 2, height: Data.cornerRadius * 2)).cgPath
        
        containerView.layer.backgroundColor = UIColor.white.cgColor
        containerView.layer.mask = containerViewCorners
        self.view.addSubview(containerView)
        
        // Top little primary text
        let topText = UILabel(frame: CGRect(x: 40, y: 32, width: Device.screenSize.width - 80, height: 16))
        topText.textAlignment = .center
        topText.textColor = Colors.primary
        topText.font = Fonts.smallRegular
        topText.text = "Call with"
        containerView.addSubview(topText)
        
        // Title big text
        let titleText = UILabel(frame: CGRect(x: 40, y: calculateY(topText, addY: 4), width: Device.screenSize.width - 80, height: 29))
        titleText.textAlignment = .center
        titleText.textColor = Colors.gray90
        titleText.font = Fonts.h3Bold
        titleText.text = "Niloya Kayıkçı"
        containerView.addSubview(titleText)
        
        
        // Date Time Box for Border
        let dateTimeBox = UIView(frame: CGRect(x: 40, y: calculateY(titleText, addY: 16), width: Device.screenSize.width - 80, height: 50))
        dateTimeBox.layer.cornerRadius = Data.cornerRadius
        dateTimeBox.layer.borderWidth = 1
        dateTimeBox.layer.borderColor = Colors.gray40.cgColor
        containerView.addSubview(dateTimeBox)
        
        // Calendar Icon
        let calendarIcon = UIImageView(frame: CGRect(x: 16, y: 16, width: 18, height: 18))
        calendarIcon.image = Icons.calendar?.withRenderingMode(.alwaysTemplate)
        calendarIcon.tintColor = Colors.primary
        dateTimeBox.addSubview(calendarIcon)
        
        // Date UILabel
        let dateText = UILabel()
        dateText.textColor = Colors.gray90
        dateText.font = Fonts.smallRegular
        dateText.text = "7 Oct, Weds"
        dateText.sizeToFit()
        dateText.frame = CGRect(x: calculateX(calendarIcon, addX: 8), y: 17, width: dateText.frame.width, height: 16)
        dateTimeBox.addSubview(dateText)
        
        // Time UILabel
        let timeText = UILabel()
        timeText.textColor = Colors.gray90
        timeText.font = Fonts.smallRegular
        timeText.text = "10:15AM - 10:30AM"
        timeText.sizeToFit()
        timeText.frame = CGRect(x: dateTimeBox.frame.width - 16 - timeText.frame.width, y: 17, width: timeText.frame.width, height: 16)
        dateTimeBox.addSubview(timeText)
        
        // Clock Icon
        let clockIcon = UIImageView(frame: CGRect(x: timeText.frame.origin.x - 18 - 8, y: 16, width: 18, height: 18))
        clockIcon.image = Icons.clock?.withRenderingMode(.alwaysTemplate)
        clockIcon.tintColor = Colors.primary
        dateTimeBox.addSubview(clockIcon)
        
        // Time Zone UILabel
        let timeZoneText = UILabel(frame: CGRect(x: 40, y: calculateY(dateTimeBox, addY: 8), width: Device.screenSize.width - 80, height: 16))
        timeZoneText.textAlignment = .center
        timeZoneText.textColor = Colors.gray80
        timeZoneText.font = Fonts.smallRegular
        timeZoneText.text = "Timezone: Europe/Amsterdam"
        containerView.addSubview(timeZoneText)
        
        // Name Text Field
        let userIconView = UIView(frame: CGRect(x: 0, y: 0, width: 40, height: 48))
        let userIcon = UIImageView(frame: CGRect(x: 16, y: 15, width: 18, height: 18))
        userIcon.image = Icons.user?.withRenderingMode(.alwaysTemplate)
        userIcon.tintColor = Colors.primary
        userIconView.addSubview(userIcon)
        
        let nameField = UITextField(frame: CGRect(x: 24, y: calculateY(timeZoneText, addY: 26), width: Device.screenSize.width - 48, height: 48))
        nameField.layer.cornerRadius = Data.cornerRadius
        nameField.layer.borderWidth = 1
        nameField.layer.borderColor = Colors.gray40.cgColor
//        nameField.text = "Adem ilter"
        nameField.attributedPlaceholder =
            NSAttributedString(string: "Your Name", attributes: [NSAttributedString.Key.foregroundColor: Colors.gray40])
        nameField.font = Fonts.bodyRegular
        nameField.textColor = Colors.gray90
        nameField.delegate = self
        nameField.keyboardType = .default
        nameField.returnKeyType = .done
        nameField.leftViewMode = .always
        nameField.leftView = userIconView
        nameField.rightViewMode = .always
        nameField.rightView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: 48))
        containerView.addSubview(nameField)
        
        // Test Buttons
        let soundTest = TestButton(frame: CGRect(x: 24, y: calculateY(nameField, addY: 12), width: ((Device.screenSize.width-48)/2) - 6, height: 48))
        soundTest.setTitle("Sound Test", for: .normal)
        containerView.addSubview(soundTest)
        
        let micTest = TestButton(frame: CGRect(x: calculateX(soundTest, addX: 12), y: soundTest.frame.origin.y, width: soundTest.frame.width, height: 48))
        micTest.setTitle("Microphone Test", for: .normal)
        containerView.addSubview(micTest)
        
        // Join Call Button
        let joinCallButton = UIButton(frame: CGRect(x: 24, y: calculateY(micTest, addY: 12), width: Device.screenSize.width - 48, height: 48))
        joinCallButton.backgroundColor = Colors.primary
        joinCallButton.layer.cornerRadius = Data.cornerRadius
        joinCallButton.setTitleColor(Colors.white, for: .normal)
        joinCallButton.setTitle("Join Call", for: .normal)
        joinCallButton.titleLabel?.font = Fonts.bodyRegular
        joinCallButton.addTarget(self, action: #selector(joinCall), for: .touchUpInside)
        containerView.addSubview(joinCallButton)
        
        // Container View Height
        containerViewHeight = joinCallButton.frame.origin.y + joinCallButton.frame.height + 32 + 10 // Notch
        containerView.frame.origin.y = Device.screenSize.height - containerViewHeight
        containerView.frame.size.height = containerViewHeight
        
        // Circle Buttons
        circleMicrophoneButton.frame.origin.x = (self.view.frame.width / 2) - circleCameraButton.frame.width - 6
        circleMicrophoneButton.frame.origin.y = containerView.frame.origin.y - circleMicrophoneButton.frame.height - 12
        circleMicrophoneButton.tag = 0
        circleMicrophoneButton.addTarget(self, action: #selector(toggleCircleButton(button:)), for: .touchUpInside)
        self.view.insertSubview(circleMicrophoneButton, belowSubview: containerView)
        
        circleCameraButton.frame.origin.x = (self.view.frame.width / 2) + 6
        circleCameraButton.frame.origin.y = circleMicrophoneButton.frame.origin.y
        circleCameraButton.tag = 1
        circleCameraButton.addTarget(self, action: #selector(toggleCircleButton(button:)), for: .touchUpInside)
        self.view.insertSubview(circleCameraButton, belowSubview: containerView)
        
        // Setting for animations
        containerView.alpha = 0
        containerView.frame.origin.y = Device.screenSize.height

        circleMicrophoneButton.alpha = 0
        circleMicrophoneButton.frame.origin.x -= 20
        
        circleCameraButton.alpha = 0
        circleCameraButton.frame.origin.x += 20
        
        // Animations
        UIView.animate(withDuration: 0.75, delay: 0, usingSpringWithDamping: 1.1, initialSpringVelocity: 0.8, options: [.curveEaseOut, .allowUserInteraction], animations: {
            
            self.containerView.frame.origin.y = Device.screenSize.height - self.containerViewHeight
            self.containerView.alpha = 1
            
        }, completion: nil)
        
        UIView.animate(withDuration: 0.75, delay: 0.25, usingSpringWithDamping: 1.1, initialSpringVelocity: 0.8, options: [.curveEaseOut, .allowUserInteraction], animations: {
            
            self.circleMicrophoneButton.alpha = 1
            self.circleMicrophoneButton.frame.origin.x += 20
            
        }, completion: nil)
        
        UIView.animate(withDuration: 1, delay: 0.5, usingSpringWithDamping: 1.1, initialSpringVelocity: 0.8, options: [.curveEaseOut, .allowUserInteraction], animations: {
            
            self.circleCameraButton.alpha = 1
            self.circleCameraButton.frame.origin.x -= 20
            
        }, completion: nil)
        
        
        for (index, view) in containerView.subviews.enumerated() {
            view.alpha = 0
            view.frame.origin.y += 40
            UIView.animate(withDuration: 1.5, delay: TimeInterval(CGFloat(index) / CGFloat(containerView.subviews.count-1)), usingSpringWithDamping: 0.5, initialSpringVelocity: 0.8, options: [.curveEaseOut, .allowUserInteraction], animations: {
                
                view.frame.origin.y -= 40
                view.alpha = 1
                
            }, completion: nil)
        }
        
        // Join Call Button After Top View
        calledTopView = UIView(frame: CGRect(x: 0, y: -200, width: Device.screenSize.width, height: 200))
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = calledTopView.bounds
        gradientLayer.colors = [UIColor.black.cgColor, UIColor.clear.cgColor]
        gradientLayer.locations = [0.0, 1]
        calledTopView.layer.addSublayer(gradientLayer)
        
        let nTopText = try! topText.copyObject() as! UILabel
        let nTitleText = try! titleText.copyObject() as! UILabel
        
        nTopText.frame.origin.y += 30
        nTopText.textColor = Colors.gray10
        calledTopView.addSubview(nTopText)

        nTitleText.frame.origin.y += 30
        nTitleText.textColor = Colors.gray10
        calledTopView.addSubview(nTitleText)
        
        self.view.addSubview(calledTopView)
    }
    
    @objc private func toggleCircleButton(button: UIButton) {
        // tag = 0 is microphone && tag = 1 is camera
        if button.backgroundColor == Colors.gray10 {
            button.backgroundColor = Colors.primary
            button.tintColor = Colors.white
        } else {
            button.backgroundColor = Colors.gray10
            button.tintColor = Colors.gray90
        }
        
    }
    
    // Keyboard Done Button
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
    
    @objc func joinCall() {
        
        joined = true
        self.view.endEditing(true)
        
        let loadingText = UILabel()
        loadingText.text = "Connecting..."
        loadingText.font = Fonts.smallRegular
        loadingText.textColor = Colors.gray80
        loadingText.sizeToFit()
        loadingText.center = self.view.center
        self.view.addSubview(loadingText)
        
        UIView.animate(withDuration: 0.75, delay: 0, usingSpringWithDamping: 1.1, initialSpringVelocity: 0.8, options: [.curveEaseOut, .allowUserInteraction], animations: {
            
            self.calledTopView.frame.origin.y = 0
            
            self.containerView.frame.origin.y = Device.screenSize.height
            self.circleCameraButton.frame.origin.y = Device.screenSize.height + 60
            self.circleMicrophoneButton.frame.origin.y = Device.screenSize.height + 60

            self.previewBackView.frame = CGRect(x: 24, y: Device.screenSize.height - 234, width: 125, height: 200)
            self.previewBackView.layer.cornerRadius = Data.cornerRadius
            self.previewView.frame = self.previewBackView.bounds

        }, completion: nil)
    }
    
    private func calculateY(_ view: UIView, addY: CGFloat) -> CGFloat {
        return view.frame.origin.y + view.frame.height + addY
    }
    
    private func calculateX(_ view: UIView, addX: CGFloat) -> CGFloat {
        return view.frame.origin.x + view.frame.width + addX
    }
    
    @objc func keyboardWillShow(notification: Notification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
                    
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1.5, initialSpringVelocity: 1.2, options: [.curveEaseOut], animations: {
                
                self.containerView.frame.origin.y = Device.screenSize.height - self.containerViewHeight - keyboardSize.height

            }, completion: nil)
        }
    }

    @objc func keyboardWillHide(notification: Notification) {
        if joined {
            return
        }
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1.5, initialSpringVelocity: 1.2, options: [.curveEaseOut], animations: {
            
            self.containerView.frame.origin.y = Device.screenSize.height - self.containerViewHeight
            
        }, completion: nil)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

}

