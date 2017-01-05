//
//  Metrica.swift
//  yandex-metrica-swift
//
//  Created by Aleksey Pleshkov on 04.01.17.
//  Copyright © 2017 Aleksey Pleshkov. All rights reserved.
//

import Foundation

//
// Сущность счетчика
//
final class Metrica {
    
    // Номер счетчика
    public let id: String
    
    // Название
    public let name: String
    
    // Источник перехода
    public let favicon: String
    
    // Визитов
    public let visits: Int
    
    // Просмотра страниц
    public let pageViews: Int
    
    // Пользователи
    public let users: Int
 
    
    init(id: String, name: String, favicon: String, visits: Int, pageViews: Int, users: Int) {
        self.id = id
        self.name = name
        self.favicon = favicon
        self.visits = visits
        self.pageViews = pageViews
        self.users = users
    }
    
}
