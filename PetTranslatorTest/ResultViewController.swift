import UIKit

class ResultViewController: UIViewController {
    
    @IBOutlet weak var petImage: UIImageView!
    
    @IBOutlet weak var closeBtn: UIButton!
    
    @IBOutlet weak var resultView: UIView!
    
    @IBOutlet weak var resultText: UILabel!
    
    @IBAction func closeBtnAction(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    var receivedImage: UIImage?
    var imageName: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        petImage.image = receivedImage
        
        resultView.layer.shadowColor = UIColor.black.cgColor
        resultView.layer.shadowOpacity = 0.15  // Прозрачность (0.0 - 1.0)
        resultView.layer.shadowRadius = 4  // Размытие тени
        resultView.layer.shadowOffset = CGSize(width: 0, height: 4)
        
        resultText.font = UIFont(name: "KonkhmerSleokchher-Regular", size: 12)
        
        if let name = imageName {
            switch name {
            case "dog":
                resultText.text = "I’m hungry, feed me!"
            case "cat":
                resultText.text = "What are you doing, human?"
            default:
                resultText.text = "Pet Translator"
            }
        } else {
            resultText.text = "Unknown pet voice detected"
        }
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [UIColor(hex: "#F3F5F6").cgColor, UIColor(hex: "#C9FFE0").cgColor]
        gradientLayer.locations = [0.0, 1.0]
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0.0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 1.0)
        gradientLayer.frame = view.frame
        view.layer.insertSublayer(gradientLayer, at: 0)
    }
}
