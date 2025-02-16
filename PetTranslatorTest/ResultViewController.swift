import UIKit
import AVFoundation

class ResultViewController: UIViewController {
    
    @IBOutlet weak var petImage: UIImageView!
    @IBOutlet weak var closeBtn: UIButton!
    @IBOutlet weak var resultView: UIView!
    @IBOutlet weak var resultText: UILabel!
    @IBOutlet weak var repeatText: UILabel!
    @IBOutlet weak var repeatBtn: UIView!
    
    var receivedImage: UIImage?
    var imageName: String?
    var selecetedTranslator: Bool?
    var audioPlayer: AVAudioPlayer?
    
    @IBAction func closeBtnAction(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupGestureRecognizers()
        handleTranslation()
    }
    
    private func setupUI() {
        petImage.image = receivedImage
        
        resultView.layer.applyShadow()
        
        resultText.font = UIFont(name: "KonkhmerSleokchher-Regular", size: 12)
        repeatText.font = UIFont(name: "KonkhmerSleokchher-Regular", size: 12)
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [UIColor(hex: "#F3F5F6").cgColor, UIColor(hex: "#C9FFE0").cgColor]
        gradientLayer.locations = [0.0, 1.0]
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0.0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 1.0)
        gradientLayer.frame = view.frame
        view.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    private func setupGestureRecognizers() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(viewTapped))
        repeatBtn.isUserInteractionEnabled = true
        repeatBtn.addGestureRecognizer(tapGesture)
    }
    
    private func handleTranslation() {
        guard let name = imageName else {
            resultText.text = "Unknown pet voice detected"
            return
        }
        
        if selecetedTranslator ?? false {
            playSound(named: name + "-sound")
            resultView.isHidden = true
        } else {
            resultText.text = getTranslation(for: name)
            repeatBtn.isHidden = true
            resultView.isHidden = false
        }
    }
    
    private func getTranslation(for pet: String) -> String {
        switch pet {
        case "dog": return "I’m hungry, feed me!"
        case "cat": return "What are you doing, human?"
        default: return "Pet Translator"
        }
    }
    
    private func playSound(named fileName: String) {
        guard let url = Bundle.main.url(forResource: fileName, withExtension: "mp3") else {
            print("Файл \(fileName).mp3 не найден")
            return
        }
        
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer?.prepareToPlay()
            audioPlayer?.play()
        } catch {
            print("Ошибка воспроизведения: \(error.localizedDescription)")
        }
    }
    
    @objc private func viewTapped() {
        if let name = imageName {
            playSound(named: name + "-sound")
        }
    }
}

// Расширение для удобного добавления тени к UIView
extension CALayer {
    func applyShadow(color: UIColor = .black, opacity: Float = 0.15, radius: CGFloat = 4, offset: CGSize = CGSize(width: 0, height: 4)) {
        shadowColor = color.cgColor
        shadowOpacity = opacity
        shadowRadius = radius
        shadowOffset = offset
    }
}
