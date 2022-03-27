//
//  TableViewextension.swift
//  WaterAlarmNotification
//
//  Created by 박형환 on 2022/03/27.
//

import Foundation
import UIKit
import UserNotifications

extension TableViewController: DateSendDelegate{
    // TableView 에 데이터 가 추가될때 switch 옵션을 자동으로 활성화
    // UNnotificationCenter 에 알림을 추가한다
    func sendDate(_ data: String) {
        print("TableViewController - sendDate \(data)")
        let convertedData = convertDateToStruct(data)
        self.tableDateData.append(convertedData)
        self.appdelegate.un.addUNnotification(convertedData.uuid, tableDateData)
        self.tableView.reloadData()
    }
    fileprivate func convertDateToStruct(_ data: String) -> TimeDateData {
        let str = data.split(separator: "T").map{String($0)}
        let yymmdd = str.first!
        let timeAndAmOrPm = str.last!.split(separator: " ").map{String($0)}
        let uuid = UUID().uuidString
        let convertData = TimeDateData(uuid: uuid,year_Month_Day: yymmdd, time: timeAndAmOrPm[0], amORpm: timeAndAmOrPm[1], isSelected: true)
        return convertData
    }
}
extension UNUserNotificationCenter{
    func addUNnotification(_ uuid: String,_ tableDateData: [TimeDateData]) {
       let appdelegate = UIApplication.shared.delegate as! AppDelegate
        let un = appdelegate.un
        un.getNotificationSettings { (setting) in
           if setting.authorizationStatus == .authorized {
               let content = UNMutableNotificationContent()
               content.title = "Time to Drink Water!"
               content.subtitle = "물마실 시간입니다!"
               content.body = "하루를 시작해 볼까요!"
               content.sound = UNNotificationSound.default
               content.badge = 1
           
               // unnotification 에 image 삽입 코드 AssetExtractor 호출
               let url2 = AssetExtractor.createLocalUrl(forImageNamed:"신분증")
               do{
                   let attachment = try UNNotificationAttachment(identifier: "image", url: url2!)
                   content.attachments = [attachment]
               }catch let error{
                   print(error.localizedDescription)
               }
               
               var date = DateComponents()
               guard let index = tableDateData.firstIndex(where: { $0.uuid == uuid}) else {return}
               let time = tableDateData[index].time.split(separator: ":").map{Int($0)!}
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
    func removeUNnotification(_ uuid: String) {
       let appdelegate = UIApplication.shared.delegate as! AppDelegate
        let un = appdelegate.un
       un.removePendingNotificationRequests(withIdentifiers: [uuid])
   }
}
