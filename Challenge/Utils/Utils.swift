//
//  Utils.swift
//  Challenge
//
//  Created by Nikita Merkel on 11/10/2018.
//  Copyright © 2018 Nikita Merkel. All rights reserved.
//

import Foundation

class Utils {
    static func convertDate(_ date: String?) -> String {
        if let receivedDate = date {
            let dateFormatterGet = DateFormatter()
            dateFormatterGet.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZZZZZ"
            
            let dateFormatterOut = DateFormatter()
            dateFormatterOut.dateFormat = "dd MMM yyyy, HH:mm"
            
            if let date = dateFormatterGet.date(from: receivedDate) {
                return dateFormatterOut.string(from: date)
            } else {
                return "Ошибка получения даты"
            }
        }
        return "Дата не выбрана"
    }
}
