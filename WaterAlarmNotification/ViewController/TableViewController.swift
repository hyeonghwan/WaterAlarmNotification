
import UIKit


class TableViewController: UITableViewController {
    @IBOutlet weak var alarmAddButton: UIBarButtonItem!
    let appdelegate = UIApplication.shared.delegate as! AppDelegate
    var tableDateData: [TimeDateData] = []{
        didSet{
            print("tableDateData - didset - called")
            self.saveTableData()
            print(1111)
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
        NotificationCenter.default.addObserver(self, selector: #selector(saveISonData(_ :)), name: Notification.Name("AlarmONoff"), object: nil)
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
        let userDefault = UserDefaults.standard
        userDefault.set(saveData, forKey: "WaterAlarm")
        print("Save Data")
        self.tableView.reloadData()
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
        self.tableDateData = tempArray
    }
    
    // MARK: - @OBJC method
    @objc fileprivate func addAlarmBtnClicked(_ sender: UIBarButtonItem){
        guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "ViewController") as? ViewController else {return}
        vc.dateDelegate = self
        vc.modalPresentationStyle = .pageSheet
        self.present(vc, animated: true, completion: nil)
    }
    
    @objc func saveISonData(_ notification: Notification) {
        print("TableViewController - saveISonData Called")
        guard let timeData = notification.object as? TimeDateData else {return}
        guard let index = tableDateData.firstIndex(where: { $0.uuid == timeData.uuid}) else {return}
        let notifyRequestBool = timeData.isSelected
        self.tableDateData[index].isSelected = notifyRequestBool
        
        switch notifyRequestBool {
            
        case true:
//            print("true")
//            let notificationContent = self.appdelegate.content
////            let time = self.tableDateData[index].time
//            let notification_ID = self.tableDateData[index].uuid
//            var date = DateComponents()
//            date.calendar = Calendar.current
//            print(date)
//            date.hour = 20
//            date.minute = 35
//            let trigger = UNCalendarNotificationTrigger(dateMatching: date, repeats: false)
//            let request = UNNotificationRequest(identifier: notification_ID, content: notificationContent, trigger: trigger)
//            let center = UNUserNotificationCenter.current()
//            center.add(request) { (error : Error?) in
//                if let theError = error {
//                    print(theError.localizedDescription)
//                }
//            }
            break
            
        case false: break

            
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
   
}
extension TableViewController: DateSendDelegate{
    
    func sendDate(_ data: String) {
        print("TableViewController - sendDate \(data)")
        let convertedData = convertDateToStruct(data)
        self.tableDateData.append(convertedData)
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

