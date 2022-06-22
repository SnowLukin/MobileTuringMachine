//
//  DefaultData.swift
//  MobileTuringMachine
//
//  Created by Snow Lukin on 16.06.2022.
//

import Foundation

class DefaultData {
    
    static let shared = DefaultData()
    
    lazy var tapes: [Tape] = {
        [Tape(nameID: 0, components: getComponents())]
    }()
    lazy var state: StateQ = {
        var newState = StateQ(nameID: 0, options: [], isStarting: true)
        newState.options = getOptionStates(state: newState)
        return newState
    }()
    
    lazy var algorithm: Algorithm = {
        Algorithm(name: "New Algorithm", tapes: tapes, states: [state], stateForReset: state)
    }()
    
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
    
    func getOptionStates(state: StateQ) -> [Option] {
        var alphabets: [[String]] = []
        for tape in tapes {
            var tapeAlphabet = tape.alphabet.map { String($0) }
            tapeAlphabet.append("_")
            alphabets.append(tapeAlphabet)
        }
        var combinations: [[String]] = []
        getCombinations(array: alphabets, word: [], currentArrayIndex: 0, result: &combinations)
        
        var optionStates: [Option] = []
        for combinationIndex in 0..<combinations.count {
            optionStates.append(
                Option(
                    toState: state,
                    combinations: getCombinationsTuple(combinations: combinations[combinationIndex])
                )
            )
        }
        return optionStates
    }
}
