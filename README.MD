# Yandex Metrica Swift

![Swift](http://img.shields.io/badge/swift-3.0-brightgreen.svg)
[![Build Status](https://travis-ci.org/AlekseySkynox/yandex-metrica-swift.svg?branch=master)](https://travis-ci.org/AlekseySkynox/yandex-metrica-swift)

Небольшая библиотека для работы с `Yandex.Metrica`, написанная на языке `Swift`. Разрабатывается как учебный проект.

## 📖 Основная инструкция

Для начала требуется [получить TOKEN](https://tech.yandex.ru/metrika/doc/api2/intro/authorization-docpage/) у Metrika API.

```Swift
let configMetrica = ConfigMetrica(token, dateStart: "YYYY-MM-DD", dateEnd: "YYYY-MM-DD")
let yandexMetrica = YandexMetrica(configMetrica)
.initCounters() // Подгружаем все счетчики
.initMetrics() // Подгружаем статистику счетчиков
.initGoals() // Подгружаем данные по целям
```

## 🚀 Возможности

### Metrica

ID/тип статистики. К примеру - реклама или прямые заходы

`Metrica.id: String`

Название

`Metrica.name: String`

Источник перехода

`Metrica.favicon: String`

Визитов

`Metrica.visits: Int`

Просмотра страниц

`Metrica.pageViews: Int`

Пользователи

`Metrica.users: Int`

Отказы. Доля визитов, в рамках которых состоялся лишь один просмотр страницы, продолжавшийся менее 15 секунд.

`Metrica.bounceRate: Double`

Глубина просмотра. Количество страниц, просмотренных посетителем во время визита.

`Metrica.pageDepth: Double`

Время на сайте. Средняя продолжительность визита в минутах и секундах.

`Metrica.avgVisitDurationSeconds: Double`

Доля новых посетителей. Процент уникальных посетителей, посетивших сайт в отчетном периоде, активность которых включала их самый первый за всю историю накопления данных визит на сайт.

`Metrica.percentNewVisitors: Double`

Количество новых посетителей.

`Metrica.newUsers: Int`

Доля визитов новых посетителей.

`Metrica.newUserVisitsPercentage: Double`

### Goal

ID

`Goal.id: Int`

Название

`Goal.name: String`

Тип

`Goal.type: String`

Индитификатор

`Goal.url: String`

Количество достижения

`Goal.reaches: Int`

Процент конверсии

`Goal.percent: Double`
