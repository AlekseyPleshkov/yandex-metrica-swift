//
//  MetricaError.swift
//  yandex-metrica-swift
//
//  Created by Aleksey Pleshkov on 05.01.17.
//  Copyright © 2017 Aleksey Pleshkov. All rights reserved.
//

import Foundation

//
// Список ошибок и исключений
//
enum MetricaError: Error {
    
    // Метрика вернула ошибку или нечитабельный ответ
    case InvalidRequest
    
    // Невозможное преобразование типов
    case ErrorCastType
    
    // Нет такого элемента в JSON
    case InvalidValue
    
}
