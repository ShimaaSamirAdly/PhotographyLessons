//
//  DictionaryExtension.swift
//  PhotographyLessons
//
//  Created by Shimaa on 30/12/2022.
//

import Foundation

extension Dictionary {
    var queryString: String {
        var outputString: String = "?"
        for (key, value) in self {
            outputString += "\(key)=\(value)&".addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) ?? ""
        }
        outputString = String(outputString.dropLast())
        return outputString
    }
}
