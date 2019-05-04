//
//  DescribableByVagueValue.swift
//  Authenticator UI
//
//  Created by Ben Leggiero on 5/4/19.
//  Copyright © 2019 Ben Leggiero. All rights reserved.
//

import Foundation



public protocol DescribableByVagueValue {
    
    var vagueValue: VagueValue { get set }
}



public enum VagueValue: Double, CaseIterable, Comparable {
    
    case minimum    = 0
    case low        = 0.1
    case mediumLow  = 0.25
    case medium     = 0.5
    case mediumHigh = 0.75
    case high       = 0.9
    case maximum    = 1
    
    
    init(minValue: RawValue, actualValue: RawValue, maxValue: RawValue) {
        let shiftedValue = actualValue - minValue
        let shiftedMax = maxValue - minValue
        
        let percentage = min(1, max(0, shiftedValue / shiftedMax))
        
        self.init(closestToPercentage: percentage)
    }
    
    
    init(closestToPercentage percentage: RawValue) {
        self = VagueValue.allCases.closest(toRawValue: percentage) ?? .minimum
    }
    
    
    func realize(minValue: RawValue, maxValue: RawValue) -> RawValue {
        let percentage = self.rawValue
        let shiftedMax = maxValue - minValue
        let shiftedValue = percentage * shiftedMax
        let realizedValue = shiftedValue + minValue
        return realizedValue
    }
}
