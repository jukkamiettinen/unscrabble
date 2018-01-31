//
//  Utils.swift
//  Unscrabble2000
//
//  Created by Jukka Miettinen on 26/01/2018.
//

import Foundation

public class Utils {
    /**
     Returns all possible permuations of passed in string
     - parameter str: String to calculate permutation for
     - parameter left: Starting index
     - parameter right: End index
     - parameter output: All possible permuations of passed in string
     */
    static func permute(str: String, left: Int, right: Int, output: inout [String]) {
        var input = str
        if (left == right) {
            output.append(input)
        }
        else {
            for index in left...right {
                var characters = Array(input)
                characters.swapAt(index, left)
                input = String(characters)

                permute(str: input, left: left + 1, right: right, output: &output);

                characters.swapAt(index, left)
                input = String(characters)
                if !output.contains(input) {
                    output.append(input)
                }
            }
        }
    }
}
