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
    public final var counters: [Counter]
    
    
    //
    // Стандартный конструктор ЯндекvarМетрики
    //
    init(configMetrica: ConfigMetrica) {
        self.counters = []
        self.configMetrica = configMetrica
    }
    
    
    //
    // Подгружаем все счетчики из аккаунта метрики
    //
    func initCounters() -> YandexMetrica {
        counters.removeAll()
        
        let jsonRequest: String = request(link: configMetrica.linkGetCounters)
        
        do {
            let jsonObject = try JsonObject(jsonRequest: jsonRequest)
            let jsonCounters = jsonObject.getArrayKeyValue("counters")
            
            for counters: [String: Any] in jsonCounters! {
                let counterJson = try JsonObject(jsonAny: counters)
                
                // Если в JSON ответе есть данные по нужному счетчику
                // То создаем экземпляр счетчика и записываем его в общий список
                if counterJson.has("id") && counterJson.has("name") && counterJson.has("site") {
                    let id: Int? = counterJson.getInt("id")
                    let name: String? = counterJson.getString("name")
                    let site: String? = counterJson.getString("site")
                    
                    if (id != nil && name != nil && site != nil) {
                        let counter = Counter(id: id!, name: name!, site: site!)
                        self.counters.append(counter)
                    }
                }
            }
        } catch MetricaError.InvalidValue {
            print("Error: initCounters - InvalidValue");
        } catch {
            print("Error: initCounters - None");
        }
        
        return self
    }
    
    
    //
    // Иницилизация данных о показах и визитах
    // Для работы данного метода, нужно изначально прогрузить счетчики initCounters()
    //
    func initMetrics() -> YandexMetrica {
        
        // Запретить запуск метода, если счетчики не прогружены
        if counters.count == 0 {
            print("Error: Need start initCounters");
        }
        
        for counter in self.counters {
            
            // Стандартная ссылка для получения статистики
            // Заменяем в ней некоторые данные на актуальные
            let linkStats = configMetrica.linkGetStandartStats.replacingOccurrences(of: "REPLACE_ID", with: String(counter.id))
            let jsonRequest = request(link: linkStats)
            
            do {
                let jsonObject = try JsonObject(jsonRequest: jsonRequest)
                
                // Получаем суммированные актуальные данные
                if jsonObject.has("totals") {
                    let totalsArray = jsonObject.getArray("totals")
                    if totalsArray?.count == 4 {
                        let visits: Int = totalsArray?[0] as! Int
                        let pageViews: Int = totalsArray?[1] as! Int
                        let users: Int = totalsArray?[2] as! Int
                        let metrica = Metrica(id: "total", name: "total", favicon: "none", visits: visits, pageViews: pageViews, users: users)
                        counter.metrics.append(metrica)
                    }
                }
                
                // Получаем данные по группам (по рекламе, внутренние переходы..)
                if jsonObject.has("data") {
                    let dataArray = jsonObject.getArrayKeyValue("data")!
                    for data in dataArray {
                        let dataObject = try JsonObject(jsonAny: data)
                        
                        if dataObject.has("dimensions") && dataObject.has("metrics") {
                            let dimensions = dataObject.getArray("dimensions")
                            let metrics = dataObject.getArray("metrics")
                            
                            if dimensions?.count == 2 && metrics?.count == 4 {
                                
                                // Разбито на два массива, получаем каждый для парсинга информации
                                let dimensionsOne = try JsonObject(jsonAny: dimensions?[0])
                                let dimensionsTwo = try JsonObject(jsonAny: dimensions?[1])
                            
                                if dimensionsOne.has("id") && dimensionsOne.has("name") && dimensionsTwo.has("favicon") && dimensionsTwo.has("name") {
                                    
                                    // ID и название перехода (реклама, поисковые системы..)
                                    let dimensionsId: String = dimensionsOne.getString("id")!
                                    let dimensionsName: String = "\(dimensionsOne.getString("name")!) | \(dimensionsTwo.getString("name")!)"
                                    let dimensionsFavicon: String = dimensionsTwo.getString("favicon")!
                                    
                                    // Статистика этого источника
                                    let visitsSource = metrics?[0] as! Int
                                    let pageViewsSource = metrics?[1] as! Int
                                    let usersSource = metrics?[2] as! Int
                                    
                                    // Проверяем, есть ли такая статистика уже в списке у счетчика
                                    // Если есть, то добавляем данные к уже имеющимся
                                    if counter.hasMetrica(id: dimensionsId) {
                                        
                                        let metricaExists = counter.getMetricaFromId(id: dimensionsId)
                                        if (metricaExists != nil) {
                                            metricaExists?.visits += visitsSource
                                            metricaExists?.pageViews += pageViewsSource
                                            metricaExists?.users += usersSource
                                        }
                                    } else {
                                        
                                        let newMetrica = Metrica(id: dimensionsId, name: dimensionsName, favicon: dimensionsFavicon, visits: visitsSource, pageViews: pageViewsSource, users: usersSource)
                                        counter.metrics.append(newMetrica)
                                    }
                                }
                            }
                        }
                    }
                }
                
            } catch MetricaError.InvalidValue {
                print("Error: initMetrica - InvalidValue");
            } catch {
                print("Error: initMetrica - None");
            }
            
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

