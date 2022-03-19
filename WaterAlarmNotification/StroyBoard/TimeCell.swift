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
    var cellData: TimeDateData? {
        didSet{
            self.uuid = cellData?.uuid
            self.amORpm.text = cellData?.amORpm
            self.toggle.isOn = cellData?.isSelected ?? false
            self.time.text = cellData?.time
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        debugPrint("TimeCell - awakeFromNib called")
        toggle.addTarget(self, action: #selector(clickedToggle(_ :)), for: .valueChanged)
        
    }
    
    @objc func clickedToggle(_ sender: UISwitch){
        let value = sender.isOn
        cellData?.isSelected = value
        NotificationCenter.default.post(
            name: NSNotification.Name(rawValue: "AlarmONoff"),
            object: cellData)
    }
    
}
