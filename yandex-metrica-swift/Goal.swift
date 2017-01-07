//
//  Goal.swift
//  yandex-metrica-swift
//
//  Created by Aleksey Pleshkov on 06.01.17.
//  Copyright © 2017 Aleksey Pleshkov. All rights reserved.
//

import Foundation

//
// Цели митрики
//

final class Goal {

    // ID цели
    public let id: Int

    // Название
    public let name: String

    // Тип
    public let type: String

    // Индитификатор
    public let url: String

    // Достижение цели
    public let reaches: Int

    // Процент конверсии
    public let percent: Double


    init(id: Int, name: String, type: String, url: String, reaches: Int, percent: Double) {
        self.id = id
        self.name = name
        self.type = type
        self.url = url
        self.reaches = reaches
        self.percent = percent
    }

}
