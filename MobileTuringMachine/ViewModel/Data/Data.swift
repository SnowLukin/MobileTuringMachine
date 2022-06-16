//
//  Data.swift
//  MobileTuringMachine
//
//  Created by Snow Lukin on 16.06.2022.
//

import Foundation

class Data {
    
    static let shared = Data().startState
    
    var tapes: [Tape] {
        [Tape(nameID: 0, components: getComponents())]
    }
    
    var startState: StateQ {
        var newState = StateQ(nameID: 0, options: [])
        newState.options = getOptionStates(state: newState)
        return newState
    }
    
    // MARK: Components
    func getComponents() -> [TapeContent] {
        var components: [TapeContent] = []
        for index in -10...10 {
            components.append(
                TapeContent(
                    id: index,
                    value: "_"
                )
            )
        }
        return components
    }
    
    private func getCombinationsTuple(combinations: [String]) -> [Combination] {
        var combinationsTuple: [Combination] = []
        for combination in combinations {
            combinationsTuple.append(Combination(character: combination, direction: .stay, toCharacter: combination))
        }
        return combinationsTuple
    }
    
    private func getCombinations(array: [[String]], word: [String], currentArrayIndex: Int, result: inout [[String]]) {
        if currentArrayIndex == array.count {
            result.append(word)
        } else {
            for element in array[currentArrayIndex] {
                var newWord = word
                newWord.append(element)
                getCombinations(array: array, word: newWord, currentArrayIndex: currentArrayIndex + 1, result: &result)
            }
        }
    }
    
    func getOptionStates(state: StateQ) -> [OptionState] {
        var alphabets: [[String]] = []
        for tape in tapes {
            var tapeAlphabet = tape.alphabet.map { String($0) }
            tapeAlphabet.append("_")
            alphabets.append(tapeAlphabet)
        }
        var combinations: [[String]] = []
        getCombinations(array: alphabets, word: [], currentArrayIndex: 0, result: &combinations)
        
        var optionStates: [OptionState] = []
        for combinationIndex in 0..<combinations.count {
            optionStates.append(
                OptionState(
                    toState: state,
                    combinations: getCombinationsTuple(combinations: combinations[combinationIndex])
                )
            )
        }
        return optionStates
    }
}
