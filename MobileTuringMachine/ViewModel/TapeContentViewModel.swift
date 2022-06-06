//
//  TapeContentViewModel.swift
//  MobileTuringMachine
//
//  Created by Snow Lukin on 13.03.2022.
//

import Foundation

class TapeContentViewModel: ObservableObject {
    
    @Published var amountOfTapes = 3
    @Published var tapes: [Tape] = [Tape(id: 0), Tape(id: 1), Tape(id: 2)]
    @Published var states: [StateQ] = [
        StateQ(
            id: 0,
            options: [
                OptionState(
                    id: 0,
                    combinations: ["a", "b", "c"],
                    toStateID: 0,
                    combinationTuple: [("a", Direction.stay, "a"), ("b", Direction.stay, "b"), ("c", Direction.stay, "c")] )
            ])
    ]
    
    @Published var firstElementInGrid = true
    
    @Published var test = 0
}



// MARK: Option States
extension TapeContentViewModel {
    
    private func getCombinationsTuple(combinations: [String]) -> [(character: String, direction: Direction, toCharacter: String)] {
        var combinationsTuple: [(character: String, direction: Direction, toCharacter: String)] = []
        for combination in combinations {
            combinationsTuple.append((combination, .stay, combination))
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
    
    private func getOptionStates(stateID: Int) -> [OptionState] {
        var alphabets: [[String]] = []
        for tape in tapes {
            alphabets.append(tape.alphabet.map { String($0) })
        }
        var combinations: [[String]] = []
        getCombinations(array: alphabets, word: [], currentArrayIndex: 0, result: &combinations)
        
        var optionStates: [OptionState] = []
        for combinationIndex in 0..<combinations.count {
            optionStates.append(OptionState(id: combinationIndex, combinations: combinations[combinationIndex], toStateID: stateID, combinationTuple: getCombinationsTuple(combinations: combinations[combinationIndex])))
        }
        return optionStates
    }
    
    func updateOptionStates() {
        for index in 0..<states.count {
            states[index].options = getOptionStates(stateID: index)
        }
    }
}

extension TapeContentViewModel {
    
    func addTape() {
        amountOfTapes += 1
        tapes.append(Tape(id: amountOfTapes - 1))
        updateOptionStates()
    }
    
    func removeTape(id: Int) {
        amountOfTapes -= 1
        tapes.remove(at: id)
        
        // Rewriting IDs
        for index in 0..<amountOfTapes {
            tapes[index].id = index
        }
        
        updateOptionStates()
    }
    
//    func updateExits() {
//        exits.removeAll()
//        let newExits = getArrayOfAllExits()
//        for exit in newExits {
//            let index = exits.count - 1
//            exits.append(Exit(id: index, expectedLetters: exit, toLetters: [exit], moving: [.stay]))
//        }
//    }
    
    func setNewAlphabet(_ text: String, id: Int) {
        tapes[id].alphabet = text
        updateOptionStates()
    }
    
    func setNewInput(_ text: String, id: Int) {
        tapes[id].input = text
    }
    
}
