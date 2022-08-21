//
//  ExpenseItem.swift
//  iExpense
//
//  Created by Michael Page on 21/8/2022.
//

import Foundation

struct ExpenseItem: Identifiable, Codable {
    var id = UUID()
    let name: String
    let type: String
    let amount: Double
}
