//
//  main.swift
//  yandex-metrica-swift
//
//  Created by Aleksey Pleshkov on 04.01.17.
//  Copyright © 2017 Aleksey Pleshkov. All rights reserved.
//

import Foundation

class YandexMetrica {
    
    // Конфигурационный класс
    private let configMetrica: ConfigMetrica
    
    // Список всех счетчиков
    public final var metrics: [Metrica]
    
    
    //
    // Стандартный конструктор Яндекс.Метрики
    //
    init(configMetrica: ConfigMetrica) {
        self.metrics = []
        self.configMetrica = configMetrica
    }
    
    
    //
    // Подгружаем все счетчики из аккаунта метрики
    //
    func initMetrics() -> YandexMetrica {
        metrics.removeAll()
        
        let jsonRequest: String = request(link: configMetrica.linkGetCounters)
        
        do {
            let jsonObject = try JsonObject(jsonRequest: jsonRequest)
            let jsonCounters = jsonObject.getArray(jsonParam: "counters")
            
            for counters: [String: Any] in jsonCounters! {
                let counter = try JsonObject(jsonAny: counters)
                
                // Наполняем список счетчиков
                let id: String = counter.getString(jsonParam: "id") ?? "0"
                let name: String = counter.getString(jsonParam: "name")  ?? "none"
                
                let metrica = Metrica(id: id, name: name, favicon: "", visits: 0, pageViews: 0, users: 0)
                self.metrics.append(metrica)
            }
        } catch MetricaError.InvalidValue {
            print("Error: initMetrica - InvalidValue");
        } catch {
            print("Error: initMetrica - None");
        }
        
        return self
    }
    

    //
    // Получения содержимого страницы сайта по URL
    //
    public func request(link: String) -> String {
        var result = "none"
        
        let url = URL(string: link)
        do {
            result = try String(contentsOf: url!, encoding: .utf8)
        } catch MetricaError.InvalidRequest {
            print("Error: request - InvalidRequest")
        } catch {
            print("Error: request - None")
        }
        
        return result
    }
    
}

