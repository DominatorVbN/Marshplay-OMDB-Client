//
//  Dateformatter+short.swift
//  Marshplay OMDB Client
//
//  Created by dominator on 08/01/20.
//  Copyright © 2020 dominator. All rights reserved.
//

import Foundation

extension DateFormatter{
    static var short: DateFormatter{
        let formatter = DateFormatter()
        formatter.dateFormat = "YYYY"
        return formatter
    }
}
