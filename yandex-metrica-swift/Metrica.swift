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


    init(id: String, name: String, favicon: String, visits: Int, pageViews: Int, users: Int) {
        self.id = id
        self.name = name
        self.favicon = favicon
        self.visits = visits
        self.pageViews = pageViews
        self.users = users
    }

}
