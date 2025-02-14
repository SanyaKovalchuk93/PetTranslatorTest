import UIKit
import Lottie
import AVFoundation

class ViewController: UIViewController, AVAudioRecorderDelegate {
    
    @IBAction func btnSwap(_ sender: Any) {
        if labelHuman.text == "HUMAN" {
            labelHuman.text = "PET"
            labelPet.text = "HUMAN"
        } else {
            labelHuman.text = "HUMAN"
            labelPet.text = "PET"
        }
    }
    
    @IBOutlet weak var selectedSpeaker: UIStackView!
    
    @IBOutlet var btnCatOutlet: UIButton!
    
    @IBOutlet var btnDogOutlet: UIButton!
    
    @IBOutlet var btnStart: UIView!
    
    @IBOutlet var btnStartImage: UIImageView!
    
    @IBOutlet var labelHuman: UILabel!
    
    @IBOutlet var labelPet: UILabel!
    
    @IBOutlet var textStartSpeak: UILabel!
    
    @IBOutlet var btnStartSpeak: UIView!
    
    @IBOutlet var label: UILabel!
    
    @IBAction func btnCat(_ sender: Any) {
        imageMainCatDog.image = UIImage(named: "cat.pdf")
        btnDogOutlet.alpha = 0.6
        btnCatOutlet.alpha = 1
    }
    
    @IBAction func btnDog(_ sender: Any) {
        imageMainCatDog.image = UIImage(named: "dog.pdf")
        btnCatOutlet.alpha = 0.6
        btnDogOutlet.alpha = 1
    }
    
    @IBOutlet var imageMainCatDog: UIImageView!
    var animationView: LottieAnimationView = .init()
    var audioRecorder: AVAudioRecorder?
    var audioPlayer: AVAudioPlayer?
    var audioURL: URL?
    var audioEngine: AVAudioEngine!
    var audioAnalyzer: AVAudioPlayerNode!
    let labelNew = UILabel()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        resetToInitialState()
    }
    
    func resetToInitialState() {
        label.isHidden = false
        selectedSpeaker.isHidden = false
        labelNew.isHidden = true
        btnStartSpeak.isHidden = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupAudioSession()
    }
    
    func setupUI() {
        label.font = UIFont(name: "KonkhmerSleokchher-Regular", size: 32)
        textStartSpeak.font = UIFont(name: "KonkhmerSleokchher-Regular", size: 16)
        labelHuman.font = UIFont(name: "KonkhmerSleokchher-Regular", size: 16)
        labelPet.font = UIFont(name: "KonkhmerSleokchher-Regular", size: 16)
        
        imageMainCatDog.image = UIImage(named: "dog.pdf")
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [UIColor(hex: "#F3F5F6").cgColor, UIColor(hex: "#C9FFE0").cgColor]
        gradientLayer.locations = [0.0, 1.0]
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0.0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 1.0)
        gradientLayer.frame = view.frame
        view.layer.insertSublayer(gradientLayer, at: 0)
        
        btnStartSpeak.layer.shadowColor = UIColor.black.cgColor
        btnStartSpeak.layer.shadowOpacity = 0.25
        btnStartSpeak.layer.shadowRadius = 14.8
        btnStartSpeak.layer.shadowOffset = CGSize(width: 0, height: 4)
        
        let tapStartSpeak = UITapGestureRecognizer(target: self, action: #selector(viewTapped))
        btnStart.addGestureRecognizer(tapStartSpeak)
        
        btnCatOutlet.alpha = 0.6
        
        animationView = .init(name: "animation-recording")
        animationView.frame = btnStart.bounds
        animationView.loopMode = .loop
        animationView.play()
    }
    
    @objc func viewTapped() {
        btnStartImage.isHidden = true
        btnStart.addSubview(animationView)
        animationView.translatesAutoresizingMaskIntoConstraints = false
        textStartSpeak.text = "Recording..."
        
        NSLayoutConstraint.activate([
            animationView.centerXAnchor.constraint(equalTo: btnStart.centerXAnchor),
            animationView.centerYAnchor.constraint(equalTo: btnStart.topAnchor, constant: 67),
            animationView.widthAnchor.constraint(equalToConstant: 163),
            animationView.heightAnchor.constraint(equalToConstant: 95)
        ])
        
        startRecording()
    }
    
    func setupAudioSession() {
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setCategory(.playAndRecord, mode: .default, options: .defaultToSpeaker)
            try audioSession.setActive(true)
        } catch {
            print("Audio session setup failed: \(error.localizedDescription)")
        }
        
        let url = FileManager.default.temporaryDirectory.appendingPathComponent("myRecording.m4a")
        audioURL = url
        
        let settings: [String: Any] = [
            AVFormatIDKey: kAudioFormatMPEG4AAC,
            AVSampleRateKey: 44100.0,
            AVNumberOfChannelsKey: 1,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
        ]
        
        do {
            audioRecorder = try AVAudioRecorder(url: url, settings: settings)
            audioRecorder?.delegate = self
        } catch {
            print("Failed to initialize audio recorder: \(error.localizedDescription)")
        }
    }
    
    @objc func startRecording() {
        if audioRecorder?.isRecording == false {
            audioRecorder?.record()
            textStartSpeak.text = "Recording..."
            animationView.play()
            animationView.isHidden = false
        } else {
            audioRecorder?.stop()
            textStartSpeak.text = "Start Speak"
            animationView.stop()
            animationView.isHidden = true
            btnStartImage.isHidden = false
            label.isHidden = true
            selectedSpeaker.isHidden = true
            hideUiElement()
        }
    }
    
    @objc func playRecording() {
        guard let url = audioURL else { return }
        audioPlayer = try? AVAudioPlayer(contentsOf: url)
        audioPlayer?.play()
    }
    
    func hideUiElement() {
        labelNew.isHidden = false
        labelNew.font = UIFont(name: "KonkhmerSleokchher-Regular", size: 16)
        labelNew.text = "Process of translation..."
        labelNew.textAlignment = .center
        labelNew.textColor = .black
        
        if let superview = btnStartSpeak.superview {
            superview.addSubview(labelNew)
            
            labelNew.frame = CGRect(x: btnStartSpeak.frame.origin.x,
                                    y: btnStartSpeak.frame.maxY - 30,
                                    width: 310,
                                    height: 22)
            
            btnStartSpeak.isHidden = true
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            let resultVC = ResultViewController(nibName: "ResultViewController", bundle: nil)
            resultVC.modalPresentationStyle = .fullScreen
            resultVC.receivedImage = self.imageMainCatDog.image
            resultVC.imageName = self.imageMainCatDog.image == UIImage(named: "cat.pdf") ? "cat" : "dog"
            self.present(resultVC, animated: true, completion: nil)
        }
    }
}
