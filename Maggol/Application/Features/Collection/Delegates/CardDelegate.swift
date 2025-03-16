//
//  CardDelegate.swift
//  Maggol
//
//  Created by Lars Beijaard on 21/02/2025.
//

import Foundation

protocol CardDelegate {
    func update(with card: Card)
    func edit(with original: Card, forCopy: Card)
}
