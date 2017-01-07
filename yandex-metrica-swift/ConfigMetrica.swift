//
//  ConfigMetrica.swift
//  yandex-metrica-swift
//
//  Created by Aleksey Pleshkov on 05.01.17.
//  Copyright © 2017 Aleksey Pleshkov. All rights reserved.
//

import Foundation

//
// Конфигурационный файл метрики
//

final class ConfigMetrica {

    private let token: String
    private let dateStart: String
    private let dateEnd: String

    // Ссылки для получения данных в формате JSON
    public let linkGetCounters: String
    public let linkGetSingleCounter: String
    public let linkGetStandartStats: String
    public let linkGetGoals: String
    public let linkGetGoalStats: String


    //
    // Стандартный конструктор
    //
    init(token: String, dateStart: String, dateEnd: String) {
        self.token = token
        self.dateStart = dateStart
        self.dateEnd = dateEnd

        // Ссылки для получения данных в формате JSON
        self.linkGetCounters = "https://api-metrika.yandex.ru/management/v1/counters?oauth_token=\(token)";
        self.linkGetSingleCounter = "https://api-metrika.yandex.ru/management/v1/counter/REPLACE_ID?oauth_token=\(token)";
        self.linkGetStandartStats = "https://api-metrika.yandex.ru/stat/v1/data?preset=sources_summary&metrics=ym:s:visits,ym:s:pageviews,ym:s:users,ym:s:bounceRate&id=REPLACE_ID&date1=\(dateStart)&date2=\(dateEnd)&oauth_token=\(token)";
        self.linkGetGoals = "https://api-metrika.yandex.ru/management/v1/counter/REPLACE_ID/goals?oauth_token=\(token)";
        self.linkGetGoalStats = "https://api-metrika.yandex.ru/stat/v1/data?metrics=ym:s:goalREPLACE_GOAL_IDreaches,ym:s:goalREPLACE_GOAL_IDconversionRate&id=REPLACE_ID&date1=\(dateStart)&date2=\(dateEnd)&oauth_token=\(token)";
    }

}
