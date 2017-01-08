//
//  Metrica.swift
//  yandex-metrica-swift
//
//  Created by Aleksey Pleshkov on 04.01.17.
//  Copyright © 2017 Aleksey Pleshkov. All rights reserved.
//

import Foundation

//
// Сущность статистики счетчика
//

final class Metrica {

    // ID/тип статистики. К примеру - реклама или прямые заходы
    public let id: String

    // Название
    public let name: String

    // Источник перехода
    public let favicon: String

    // Визитов
    public var visits: Int

    // Просмотра страниц
    public var pageViews: Int

    // Пользователи
    public var users: Int
    
    // Отказы
    // Доля визитов, в рамках которых состоялся лишь один просмотр страницы, продолжавшийся менее 15 секунд.
    public var bounceRate: Double
    
    // Глубина просмотра
    // Количество страниц, просмотренных посетителем во время визита.
    public var pageDepth: Double

    // Время на сайте
    // Средняя продолжительность визита в минутах и секундах.
    public var avgVisitDurationSeconds: Double

    // Доля новых посетителей
    // Процент уникальных посетителей, посетивших сайт в отчетном периоде, 
    // активность которых включала их самый первый за всю историю накопления данных визит на сайт.
    public var percentNewVisitors: Double
    
    // Количество новых посетителей.
    public var newUsers: Int
    
    // Доля визитов новых посетителей.
    public var newUserVisitsPercentage: Double
    
    
    init(id: String, name: String, favicon: String, visits: Int, pageViews: Int, users: Int,
         bounceRate: Double, pageDepth: Double, avgVisitDurationSeconds: Double, percentNewVisitors: Double,
         newUsers: Int, newUserVisitsPercentage: Double) {
        self.id = id
        self.name = name
        self.favicon = favicon
        self.visits = visits
        self.pageViews = pageViews
        self.users = users
        self.bounceRate = bounceRate
        self.pageDepth = pageDepth
        self.avgVisitDurationSeconds = avgVisitDurationSeconds
        self.percentNewVisitors = percentNewVisitors
        self.newUsers = newUsers
        self.newUserVisitsPercentage = newUserVisitsPercentage
    }

}
