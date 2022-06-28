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
    func getComponents() -> [TapeComponent] {
        var components: [TapeComponent] = []
        for index in -100...100 {
            components.append(
                TapeComponent(
                    id: index,
                    value: "_"
                )
            )
        }
        return components
    }
    
    private func getCombinationsTuple(combinations: [String]) -> [Combination] {
        var combinationsTuple: [Combination] = []
        for combinationIndex in 0..<combinations.count {
            combinationsTuple.append(Combination(id: combinationIndex, character: combinations[combinationIndex], direction: .stay, toCharacter: combinations[combinationIndex]))
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
                    id: combinationIndex, toState: state,
                    combinations: getCombinationsTuple(combinations: combinations[combinationIndex])
                )
            )
        }
        return optionStates
    }
}
