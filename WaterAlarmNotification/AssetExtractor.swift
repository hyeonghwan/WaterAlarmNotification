//
//  AssetExtractor.swift
//  WaterAlarmNotification
//
//  Created by 박형환 on 2022/03/27.
//

import Foundation
import UIKit

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
