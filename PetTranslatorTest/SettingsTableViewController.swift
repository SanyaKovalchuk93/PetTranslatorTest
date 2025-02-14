import UIKit

class SettingsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet var tableViewNew: UITableView!
    
    let settingListItemText = ["Rate Us", "Share App", "Contact Us", "Restore Purchases", "Privacy Policy", "Terms of Use"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableViewNew.dataSource = self
        tableViewNew.delegate = self
        tableViewNew.register(UINib(nibName: "SettingsTableViewCell", bundle: nil), forCellReuseIdentifier: "settingCell")
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [UIColor(hex: "#F3F5F6").cgColor, UIColor(hex: "#C9FFE0").cgColor]
        gradientLayer.locations = [0.0, 1.0]
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0.0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 1.0)
        gradientLayer.frame = view.frame
        view.layer.insertSublayer(gradientLayer, at: 0)
        
        titleLabel.font = UIFont(name: "KonkhmerSleokchher-Regular", size: 32)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {  // Убрали private
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "settingCell", for: indexPath) as? SettingsTableViewCell else {
            return UITableViewCell()
        }
        cell.selectionStyle = .none
        cell.settingListText.font = UIFont(name: "KonkhmerSleokchher-Regular", size: 16)
        cell.settingListText.text = settingListItemText[indexPath.row]
        
        return cell
    }
}
