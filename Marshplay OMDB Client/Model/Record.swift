//
//  Record.swift
//  Marshplay OMDB Client
//
//  Created by dominator on 07/01/20.
//  Copyright © 2020 dominator. All rights reserved.
//

import Foundation

// MARK: - Record
struct Record: Codable,Hashable {
    let title, imdbID: String
    let year: String
    let type: String
    let poster: String
    let id = UUID()
    
    var ago: String{
        getElapsedInterval(string: year, dateFormate: DateFormatter.short)
    }
    
    private func getElapsedInterval(string: String, dateFormate: DateFormatter) -> String {
        
        let yearText = string[..<string.index(string.startIndex, offsetBy: 4)]
        guard let date = dateFormate.date(from: String(yearText))else{ return string }
        
        let interval = Calendar.current.dateComponents([.year, .month, .day, .hour], from: date, to: Date())
        
        if let year = interval.year, year > 0 {
            return year == 1 ? "\(year)" + " " + "year ago" :
                "\(year)" + " " + "years ago"
        }else{
            return string
        }
        
    }

    enum CodingKeys: String, CodingKey {
        case title = "Title"
        case year = "Year"
        case imdbID
        case type = "Type"
        case poster = "Poster"
    }
}
