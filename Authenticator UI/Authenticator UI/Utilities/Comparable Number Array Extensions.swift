//
//  Comparable Number Array Extensions.swift
//  Authenticator UI
//
//  Created by Ben Leggiero on 5/4/19.
//  Copyright © 2019 Ben Leggiero. All rights reserved.
//

import Foundation



public extension Array where
    Element: Comparable,
    Element: SignedNumeric
{
    
    /// Finds the value in this array which is closest to the given one.
    /// In the event of a tie, the smaller value is chosen.
    ///
    /// - Note: There is no defined behavior when using special values, like `Double.infinity` or `Double.nan`
    ///
    /// - Parameter other: The value you which is close to one in this array
    /// - Returns: The closest element in this array, or `nil` if it is an empty array
    func closest(to other: Element) -> Element? {
        let sorted = self.sorted()
        return sorted
            .min(by: { abs($0 - other) < abs($1 - other) })
            ?? sorted.last
    }
}



public extension Array where
    Element: Comparable,
    Element: RawRepresentable,
    Element.RawValue: Comparable,
    Element.RawValue: SignedNumeric
{
    /// Finds the value in this array which is closest to the given one
    ///
    /// - Parameter other: The value you which is close to one in this array
    /// - Returns: The closest element in this array, or `nil` if it is an empty array
    func closest(toRawValue otherRawValue: Element.RawValue) -> Element? {
        let sorted = self.sorted()
        return sorted
            .enumerated()
            .min(by: { abs($0.1.rawValue - otherRawValue) < abs($1.1.rawValue - otherRawValue) })?
            .element
            ?? sorted.last
    }
}



public extension RawRepresentable where
    Self: Comparable,
    RawValue: Comparable
{
    static func < (lhs: Self, rhs: Self) -> Bool {
        return lhs.rawValue < rhs.rawValue
    }
}
