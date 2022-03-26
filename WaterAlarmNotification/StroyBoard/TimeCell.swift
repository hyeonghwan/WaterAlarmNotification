//
//  timeCell.swift
//  WaterAlarmNotification
//
//  Created by 박형환 on 2022/03/14.
//

import Foundation
import UIKit


class TimeCell: UITableViewCell{
    @IBOutlet weak var amORpm: UILabel!
    @IBOutlet weak var toggle: UISwitch!
    @IBOutlet weak var time: UILabel!
    var uuid: String?
    var count: Int = 0
    var year: String?
    var cellData: TimeDateData? {
        didSet{
            self.uuid = cellData?.uuid
            self.amORpm.text = cellData?.amORpm
            self.time.text = cellData?.time
            self.year = cellData?.year_Month_Day
            self.toggle.setOn(cellData?.isSelected ?? false, animated: true)
            print("cellData didset called")
           
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        debugPrint("TimeCell - awakeFromNib called")
        toggle.addTarget(self, action: #selector(clickedToggle(_ :)), for: .touchUpInside)
    }
    
    @objc func clickedToggle(_ sender: UISwitch){
        self.cellData?.isSelected = sender.isOn
        print("clicekdToggle called")
        NotificationCenter.default.post(
            name: NSNotification.Name(rawValue: "AlarmONoff"),
            object: cellData)
      
    }
    
}
