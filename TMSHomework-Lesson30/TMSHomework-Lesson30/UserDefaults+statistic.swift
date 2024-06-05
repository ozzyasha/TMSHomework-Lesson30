//
//  UserDefaults+statistic.swift
//  TMSHomework-Lesson30
//
//  Created by Наталья Мазур on 28.03.24.
//

import Foundation

extension UserDefaults {
    enum UserDefaultsKeys: String {
        case numberOfAttemptsLabelText = "numberOfAttemptsLabelText"
        case numberOfAttempts = "numberOfAttempts"
        case guessedNumbers = "guessedNumbers"
        case randomNumber = "randomNumber"
        case resultLabelText = "resultLabelText"
    }
    
    func setValue(_ value: Any?, forKey key: UserDefaultsKeys) {
        setValue(value, forKey: key.rawValue)
    }
    
    func value(forKey key: UserDefaultsKeys) -> Any? {
        value(forKey: key.rawValue)
    }
}
