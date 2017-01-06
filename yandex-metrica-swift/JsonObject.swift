//
//  Json.swift
//  yandex-metrica-swift
//
//  Created by Aleksey Pleshkov on 05.01.17.
//  Copyright © 2017 Aleksey Pleshkov. All rights reserved.
//

import Foundation

//
// Небольшой инструмент для облегчения работы с JSON
//
class JsonObject {
    
    private let json: [String: Any]
    
    
    //
    // Конструктор класса
    // Преобразуем String в JsonObject
    //
    init(jsonRequest: String) throws {
        let data: Data = jsonRequest.data(using: .utf8)!
        let json = try? JSONSerialization.jsonObject(with: data)
        
        guard let result = json as? [String: Any] else {
            throw MetricaError.InvalidValue
        }

        self.json = result
    }
    
    
    //
    // Конструктор класса
    // Преобразует Any в JsonObject
    //
    init(jsonAny: Any) throws {
        let data = try? JSONSerialization.data(withJSONObject: jsonAny, options: [])
        let json = try? JSONSerialization.jsonObject(with: data!, options: [])
        
        guard let result = json as? [String: Any] else {
            throw MetricaError.InvalidValue
        }
        
        self.json = result
    }
    
    
    //
    // Возврат значений
    //
    
    
    public func has(_ jsonParam: String) -> Bool {
        if self.json[jsonParam] != nil {
            return true
        }
        return false
    }
    
    
    public func getInt(_ jsonParam: String) -> Int? {
        guard let result: Int = self.json[jsonParam] as? Int else {
            return nil
        }
        return result
    }
    
    
    public func getString(_ jsonParam: String) -> String? {
        guard let result: String = self.json[jsonParam] as? String else {
            return nil
        }
        return result
    }
    
    
    public func getArray(_ jsonParam: String) -> [Any]? {
        guard let result: [Any] = self.json[jsonParam] as? [Any] else {
            return nil
        }
        return result
    }
    
    
    public func getArrayKeyValue(_ jsonParam: String) -> [[String: Any]]? {
        guard let result: [[String: Any]] = self.json[jsonParam] as? [[String: Any]] else {
            return nil
        }
        return result
    }
    
    
    public func getAny(_ jsonParam: String) -> Any? {
        guard let result: Any = self.json[jsonParam] else {
            return nil
        }
        return result
    }
    
}
