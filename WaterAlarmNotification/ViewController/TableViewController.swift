
import UIKit


class TableViewController: UITableViewController {
    @IBOutlet weak var alarmAddButton: UIBarButtonItem!
    let appdelegate = UIApplication.shared.delegate as! AppDelegate
    var tableDateData: [TimeDateData] = []{
        didSet(oldval){
            self.saveTableData()
        }
        willSet(newVal){
         
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
    
        let nib = UINib(nibName: "TimeCell", bundle: nil)
        debugPrint("tableViewController - viewdidload - called")
        tableView.register(nib, forCellReuseIdentifier: "TimeCell")
        self.navigationController?.navigationBar.prefersLargeTitles = true
        alarmAddButton.target = self
        alarmAddButton.action = #selector(addAlarmBtnClicked(_:))
        loadData()
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(saveISonData(_ :)),
                                               name: Notification.Name("AlarmONoff"),
                                               object: nil)
    }
    fileprivate func saveTableData() {
        let saveData = self.tableDateData.map{
            [
                "uuid" : $0.uuid,
                "time" : $0.time,
                "year_Month_Day" : $0.year_Month_Day,
                "amORpm" : $0.amORpm,
                "isSelected" : $0.isSelected
            ]
        }
        print("saveTableData")
        let userDefault = UserDefaults.standard
        userDefault.set(saveData, forKey: "WaterAlarm")
       
    }
    
    fileprivate func loadData() {
        print("loadData - called")
        let userDefault = UserDefaults.standard
        guard let data = userDefault.object(forKey: "WaterAlarm") as? [[String : Any]] else {return}
        let tempArray: [TimeDateData] = data.compactMap{
            debugPrint("tableDateData - compactMap called1")
            guard let uuid = $0["uuid"] as? String else {print("1"); return nil}
            guard let time = $0["time"] as? String else {print("2"); return nil}
            guard let year_Month_Day = $0["year_Month_Day"] as? String else {print("3"); return nil}
            guard let amORpm = $0["amORpm"] as? String else {print("4"); return nil}
            guard let isSelected = $0["isSelected"] as? Bool else {print("5"); return nil}
            debugPrint("tableDateData - compactMap called2")
            return TimeDateData(uuid: uuid, year_Month_Day: year_Month_Day, time: time, amORpm: amORpm, isSelected: isSelected)
        }
        print(tempArray)
        self.tableDateData = tempArray
    }
    
    // MARK: - @OBJC method
    @objc fileprivate func addAlarmBtnClicked(_ sender: UIBarButtonItem){
        guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "ViewController") as? ViewController else {return}
        vc.dateDelegate = self
        vc.modalPresentationStyle = .pageSheet
        self.present(vc, animated: true, completion: nil)
    }
    
    @objc fileprivate func saveISonData(_ notification: Notification) {
        print("TableViewController - saveISonData Called")
        guard let timeData = notification.object as? TimeDateData else {return}
        guard let index = tableDateData.firstIndex(where: { $0.uuid == timeData.uuid}) else {return}
        let notifyRequestBool = timeData.isSelected
        self.tableDateData[index].isSelected = notifyRequestBool
        print(self.tableDateData)
        switch notifyRequestBool {
            
        case true:
            self.addUNnotification(timeData.uuid)
            break
            
        case false:
            
            break

        }
        
    }
    
    //MARK: - unNotification func
    fileprivate func addUNnotification(_ uuid: String) {
        let un = self.appdelegate.un
        un.getNotificationSettings { (setting) in
            if setting.authorizationStatus == .authorized {
                let content = UNMutableNotificationContent()
                content.title = "Time to Drink Water!"
                content.subtitle = "물마실 시간입니다!"
                content.body = "하루를 시작해 볼까요!"
                content.sound = UNNotificationSound.default
                content.badge = 1
            
                let url2 = AssetExtractor.createLocalUrl(forImageNamed: "신분증")
                do{
                    let attachment = try UNNotificationAttachment(identifier: "Test", url: url2!)
                    content.attachments = [attachment]
                }catch let error{
                    print(error.localizedDescription)
                }
                var date = DateComponents()
                guard let index = self.tableDateData.firstIndex(where: { $0.uuid == uuid}) else {return}
                let time = self.tableDateData[index].time.split(separator: ":").map{Int($0)!}
                date.hour = time[0]
                date.minute = time[1]
                let timeTrigger = UNCalendarNotificationTrigger(dateMatching: date, repeats: true)
                
                let request = UNNotificationRequest(identifier: uuid, content: content, trigger: timeTrigger)
                un.add(request) { error in
                    if error != nil {print(error?.localizedDescription as Any)}
                }
            }
            
        }
    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        
        return 1
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let sectionTitle: String?
        sectionTitle = "물마시기"
        return sectionTitle
    }
    

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.tableDateData.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = self.tableView.dequeueReusableCell(withIdentifier: "TimeCell") as? TimeCell else {return UITableViewCell()}
        cell.selectionStyle = .blue
        cell.cellData = self.tableDateData[indexPath.row]
        return cell
        
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("111")
        tableView.deselectRow(at: indexPath, animated: true)
        guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "ViewController") as? ViewController else {return}
        vc.dateDelegate = self
        vc.modalPresentationStyle = .pageSheet
        self.present(vc, animated: true, completion: nil)
    }
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCell.EditingStyle.delete {
            print("delete")
               tableDateData.remove(at: indexPath.row)
           }
    }
   
}
extension TableViewController: DateSendDelegate{
    
    func sendDate(_ data: String) {
        print("TableViewController - sendDate \(data)")
        let convertedData = convertDateToStruct(data)
        self.tableDateData.append(convertedData)
        self.tableView.reloadData()
    }
    fileprivate func convertDateToStruct(_ data: String) -> TimeDateData {
        let str = data.split(separator: "T").map{String($0)}
        let yymmdd = str.first!
        let timeAndAmOrPm = str.last!.split(separator: " ").map{String($0)}
        let uuid = UUID().uuidString
        let convertData = TimeDateData(uuid: uuid,year_Month_Day: yymmdd, time: timeAndAmOrPm[0], amORpm: timeAndAmOrPm[1], isSelected: false)
        return convertData
    }
}


//MARK: - 이미지 추출 클래스
class AssetExtractor {

    static func createLocalUrl(forImageNamed name: String) -> URL? {

        let fileManager = FileManager.default
        let cacheDirectory = fileManager.urls(for: .cachesDirectory, in: .userDomainMask)[0]
        let url = cacheDirectory.appendingPathComponent("\(name).png")

        guard fileManager.fileExists(atPath: url.path) else {
            guard
                let image = UIImage(named: name),
                let data = image.pngData()
            else { return nil }

            fileManager.createFile(atPath: url.path, contents: data, attributes: nil)
            print("not 신분증")
            return url
        }
        print("exist 신분증")
        return url
    }

}
