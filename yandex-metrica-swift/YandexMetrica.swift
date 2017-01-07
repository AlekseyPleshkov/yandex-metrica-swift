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
    private final var counters: [Counter]


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

        guard let jsonRequest = request(link: configMetrica.linkGetCounters) else {
            // Ошибка выводится в функции
            return self
        }
        let jsonObject = JsonObject(jsonRequest: jsonRequest)
        guard let jsonCounters = jsonObject.getArrayKeyValue("counters") else {
            print("Error, initCounters: Не найден ключ counters")
            return self
        }

        for counter: [String: Any] in jsonCounters {
            let counterObject = JsonObject(jsonAny: counter)

            // Если в JSON ответе есть данные по нужному счетчику
            // То создаем экземпляр счетчика и записываем его в общий список
            guard let id = counterObject.getInt("id"),
                  let name = counterObject.getString("name"),
                  let site = counterObject.getString("site") else {
                print("Error, initCounters: Не найден один из элементов счетчика")
                return self
            }

            let counter = Counter(id: id, name: name, site: site)
            self.counters.append(counter)
        }

        return self
    }


    //
    // Подгружаем только один счетчик из аккаунта метрики
    //
    func initSingleCounter(counterId: Int) -> YandexMetrica {
        counters.removeAll()

        let linkStats = configMetrica.linkGetSingleCounter
                .replacingOccurrences(of: "REPLACE_ID", with: String(counterId))
        guard let jsonRequest = request(link: linkStats) else {
            // Ошибка выводится в функции
            return self
        }
        let jsonObject = JsonObject(jsonRequest: jsonRequest)
        guard let jsonCounter = jsonObject.getAny("counter") else {
            print("Error, initSingleCounter: Не найден ключ counter")
            return self
        }

        // Если в JSON ответе есть данные по нужному счетчику
        // То создаем экземпляр счетчика и записываем его в общий список
        let counterObject = JsonObject(jsonAny: jsonCounter)
        guard let id = counterObject.getInt("id"),
              let name = counterObject.getString("name"),
              let site = counterObject.getString("site") else {
            print("Error, initSingleCounter: Не найден один из ключей в counter")
            return self
        }
        let counter = Counter(id: id, name: name, site: site)
        counters.append(counter)

        return self
    }


    //
    // Подгрузка данных показов и визитов
    // Для работы данного метода, нужно изначально прогрузить счетчики initCounters()
    //
    func initMetrics() -> YandexMetrica {

        // Запретить запуск метода, если счетчики не прогружены
        if counters.count == 0 {
            print("Error, initMetrics: Ошибка иницилизации, требуется запустить initCounters")
            return self
        }

        for counter in self.counters {
            counter.metrics.removeAll()

            // Стандартная ссылка для получения статистики
            // Заменяем в ней некоторые данные на актуальные
            let linkStats = configMetrica.linkGetStandartStats
                    .replacingOccurrences(of: "REPLACE_ID", with: String(counter.id))
            guard let jsonRequest = request(link: linkStats) else {
                return self
            }
            let jsonObject = JsonObject(jsonRequest: jsonRequest)

            // Получаем суммированные актуальные данные
            guard let totalsArray = jsonObject.getArray("totals") else {
                print("Error, initMetrics: Не найден элемент totals")
                break
            }

            if totalsArray.count == 4 {
                guard let visits = totalsArray[0] as? Int,
                      let pageViews = totalsArray[1] as? Int,
                      let users = totalsArray[2] as? Int else {
                    print("Error, initMetrics: Не найден один из элементов totals")
                    break
                }
                let metrica = Metrica(id: "total",
                        name: "total",
                        favicon: "none",
                        visits: visits,
                        pageViews: pageViews,
                        users: users)
                counter.metrics.append(metrica)
            }

            // Получаем данные по группам (по рекламе, внутренние переходы..)
            guard let dataArray = jsonObject.getArrayKeyValue("data") else {
                print("Error, initMetrics: Не найден один из элементов data")
                break
            }

            for data in dataArray {
                let dataObject = JsonObject(jsonAny: data)

                if dataObject.has("dimensions") && dataObject.has("metrics") {
                    guard let dimensions = dataObject.getArray("dimensions"),
                          let metrics = dataObject.getArray("metrics") else {
                        print("Error, initMetrics: Не найден один из элементов dimensions || metrics")
                        break
                    }

                    if dimensions.count == 2 && metrics.count == 4 {

                        // Разбито на два массива, получаем каждый для парсинга информации
                        let dimensionsOne = dataObject.getJsonObject(dimensions[0])
                        let dimensionsTwo = dataObject.getJsonObject(dimensions[1])

                        // ID и название перехода (реклама, поисковые системы..)
                        guard let dimensionsId = dimensionsOne.getString("id"),
                              let dimensionsName = String("\(dimensionsOne.getString("name")) " +
                                      "| \(dimensionsTwo.getString("name"))"),
                              let dimensionsFavicon = dimensionsTwo.getString("favicon") else {
                            print("Error, initMetrics: Не найден один из ключей в dimensions")
                            break
                        }

                        // Статистика этого источника
                        guard let visitsSource = metrics[0] as? Int,
                              let pageViewsSource = metrics[1] as? Int,
                              let usersSource = metrics[2] as? Int else {
                            print("Error, initMetrics: Не найден один из ключей в metrics")
                            break
                        }

                        // Проверяем, есть ли такая статистика уже в списке у счетчика
                        // Если есть, то добавляем данные к уже имеющимся
                        if counter.hasMetrica(id: dimensionsId) {
                            guard let metricaExists = counter.getMetricaFromId(id: dimensionsId) else {
                                print("Error, initMetrics: Ошибка извлечения метрики по ID")
                                break
                            }
                            metricaExists.visits += visitsSource
                            metricaExists.pageViews += pageViewsSource
                            metricaExists.users += usersSource
                        } else {
                            let newMetrica = Metrica(id: dimensionsId,
                                    name: dimensionsName,
                                    favicon: dimensionsFavicon,
                                    visits: visitsSource,
                                    pageViews: pageViewsSource,
                                    users: usersSource)
                            counter.metrics.append(newMetrica)
                        }
                    }
                }
            }
        }

        return self
    }


    //
    //
    //
    func initGoals() -> YandexMetrica {

        // Запретить запуск метода, если счетчики не прогружены
        if counters.count == 0 {
            print("Error, initMetrics: Ошибка иницилизации, требуется запустить initCounters")
            return self
        }

        // Перебираем список счетчиков
        // И получаем список целей по каждому счетчику
        for counter in counters {
            counter.goals.removeAll()

            let linkStats: String = configMetrica.linkGetGoals.replacingOccurrences(of: "REPLACE_ID", with: String(counter.id))
            guard let jsonRequest = request(link: linkStats) else {
                return self
            }
            let jsonObject = JsonObject(jsonRequest: jsonRequest)

            // Проверка на существование данных
            guard let jsonData = jsonObject.getArrayKeyValue("goals") else {
                print("Error, initGoals: Ошибка получения ключа goals")
                break
            }

            for goalsData in jsonData {
                let goals = jsonObject.getJsonObject(jsonAny: goalsData)

                // Основные данные
                guard let id = goals.getInt("id"),
                      let name = goals.getString("name") else {
                    print("Error, initGoals: Ошибка получения ключей из goals")
                    break
                }
                var type: String = ""
                var url = ""

                // Получаем тип цели и индитификатор
                guard let conditions = goals.getArrayKeyValue("conditions") else {
                    print("Error, initGoals: Ошибка получения ключа conditions")
                    break
                }

                for condition in conditions {
                    let cond = JsonObject(jsonAny: condition)
                    guard let type = cond.getString("type"), let url = cond.getString("url") else {
                        print("Error, initGoals: Ошибка получения ключей из conditions")
                        break
                    }
                }

                // Формируем ссылку для получения данных по цели
                let linkGoalStats = configMetrica.linkGetGoalStats
                        .replacingOccurrences(of: "REPLACE_ID", with: String(counter.id))
                        .replacingOccurrences(of: "REPLACE_GOAL_ID", with: String(id))
                // Получаем данные о выполнении и конверсии цели
                guard let goalStatsRequest = request(link: linkGoalStats) else {
                    return self
                }
                let jsonGoals = JsonObject(jsonRequest: goalStatsRequest)

                guard let goalsStats = jsonGoals.getArray("totals") else {
                    print("Error, initGoals: Ошибка получения ключа totals")
                    break
                }

                guard let reaches = goalsStats[0] as? Int, let percent = goalsStats[1] as? Double else {
                    print("Error, initGoals: Ошибка получения ключей из totals")
                    break
                }

                let goal = Goal(id: id, name: name, type: type, url: url, reaches: reaches, percent: percent)
                counter.goals.append(goal)
            }
        }

        return self
    }


    //
    // Получения содержимого страницы сайта по URL
    //
    public func request(link: String) -> String? {
        let url = URL(string: link)

        do {
            return try String(contentsOf: url!, encoding: .utf8)
        } catch {
            print("Error, request: Ошибка при обращении к URL \(link)")
        }

        return nil
    }


    // Возвращаем список счетчиков
    func getCounters() -> [Counter] {
        return counters
    }


    // Возвращаем только один счетчик по ID
    func getCounterFromId(counterId: Int) -> Counter? {
        for counter in counters {
            if counter.id == counterId {
                return counter
            }
        }
        return nil
    }

}

