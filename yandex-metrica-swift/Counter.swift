//
//  Counter.swift
//  yandex-metrica-swift
//
//  Created by Aleksey Pleshkov on 06.01.17.
//  Copyright © 2017 Aleksey Pleshkov. All rights reserved.
//

import Foundation

//
// Сущность счетчика
//
class Counter {
    
    // ID
    public let id: Int
    
    // Название
    public let name: String
    
    // Ссылка на сайт
    public let site: String
    
    // Данные счетчика посещений
    public var metrics: [Metrica]
    
    
    init(id: Int, name: String, site: String) {
        self.id = id
        self.name = name
        self.site = site
        self.metrics = []
    }
    
    //
    // Проверяем, есть ли в списке счетчиков - счетчик с таким же ID
    //
    func hasMetrica(id: String) -> Bool {
        for metrica in metrics {
            if metrica.id == id {
                return true
            }
        }
        return false
    }
    
    
    //
    // Возвращаем сущность статистики по ID
    //
    func getMetricaFromId(id: String) -> Metrica? {
        for metrica in metrics {
            if metrica.id == id {
                return metrica
            }
        }
        return nil
    }
}
