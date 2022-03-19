
import UIKit

protocol DateSendDelegate: AnyObject {
    func sendDate(_ data: String)
}

class ViewController: UIViewController {

    @IBOutlet weak var datePicker: UIDatePicker!
    var navBar: UINavigationBar?
    var rightStringItem: UIBarButtonItem?
    var navItem: UINavigationItem?
    var leftItem: UIBarButtonItem?
    var result: String?
    var dateDelegate: DateSendDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navBar = self.setNavBarToTheView()
        guard let bar = navBar else {return}
        self.view.addSubview(bar)
        self.navItem?.setRightBarButtonItems(isEnabled: false)
        datePicker.preferredDatePickerStyle = .automatic
        datePicker.datePickerMode = .dateAndTime
        datePicker.locale = Locale(identifier: "ko-KR")
        datePicker.timeZone = .autoupdatingCurrent
        datePicker.addTarget(self, action: #selector(datePick(_ :)), for: .valueChanged)
    }
    
    fileprivate func setNavBarToTheView() -> UINavigationBar {
        let navBar: UINavigationBar = UINavigationBar(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 32.0))
        navItem = UINavigationItem(title: "알람 추가");
        leftItem = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(cancelAction(_:)))
         rightStringItem = UIBarButtonItem(title: "확인", style: .done, target: self, action: #selector(addAction(_:)))
        guard let navigationItem = navItem else {return UINavigationBar()}
        navigationItem.leftBarButtonItem = leftItem
        navigationItem.rightBarButtonItem = rightStringItem
        navBar.setItems([navigationItem], animated: true);
        return navBar
    }
    
    @objc fileprivate func cancelAction(_ sender: UIBarButtonItem){
        self.dismiss(animated: true, completion: nil)
    }
    @objc fileprivate func addAction(_ sender: UIBarButtonItem){
        guard let dateString = result else {return}
        self.dateDelegate?.sendDate(dateString)
        self.dismiss(animated: true, completion: nil)
    }
    @objc fileprivate func datePick(_ sender: UIDatePicker){
        self.navItem?.setRightBarButtonItems(isEnabled: true)
        let fommater = DateFormatter()
        fommater.dateStyle = .full
        fommater.timeStyle = .short
        fommater.dateFormat = "yyyy-MM-dd'T'HH:mm a"
        self.result = fommater.string(from: sender.date)
    }

}
extension UINavigationItem {
func setRightBarButtonItems(isEnabled:Bool){
    for button in self.rightBarButtonItems ?? [UIBarButtonItem()] {
        button.isEnabled = isEnabled
    }
}
}
