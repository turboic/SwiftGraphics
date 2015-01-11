// Playground - noun: a place where people can play

import SwiftGraphicsPlayground

let rnd = Random()

let suites = "♣️,♦️,♠️,♥️".componentsSeparatedByString(",")
let values = "A,1,2,3,4,5,6,7,8,9,J,Q,K".componentsSeparatedByString(",")

var cards = [].join(suites.map() {
    (suite:String) -> [String] in
    return values.map() {
        (value:String) -> String in
        return "\(value)\(suite)"
    }
})

// Simpler and easier way.
var cards2:[String] = (0..<52).map() {
    let suite = suites[$0 / 13]
    let value = values[$0 % 13]
    return "\(value)\(suite)"
}

rnd.shuffle(&cards)
cards

let b = rnd.random_array(52, initial:0) { $0 }
b

cards2 = rnd.shuffled(cards2)

















