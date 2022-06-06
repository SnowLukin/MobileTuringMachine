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
}

// MARK: - States
extension TapeContentViewModel {
    
    // MARK: Add
    func addState() {
        let id = states.count
        states.append(StateQ(id: id, options: getOptionStates(stateID: id)))
    }
    
    // MARK: Remove
    func removeState(atID: Int) {
        // Update ID's
        for index in 0..<states.count {
            if index == atID {
                // Setting to -1 to avoid unexpected errors with matching IDs
                states[index].id = -1
            } else if index > atID {
                states[index].id = states[index].id - 1
            }
        }
        
        states.remove(at: atID)
    }
    
    // MARK: Update
    func updateStates() {
        for index in 0..<states.count {
            states[index].options = getOptionStates(stateID: index)
        }
    }
    
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
}


// MARK: - Tape
extension TapeContentViewModel {
    
    // MARK: Add
    func addTape() {
        amountOfTapes += 1
        tapes.append(Tape(id: amountOfTapes - 1))
        updateStates()
    }
    
    // MARK: Remove
    func removeTape(id: Int) {
        amountOfTapes -= 1
        tapes.remove(at: id)
        
        // Updating IDs
        for index in 0..<amountOfTapes {
            tapes[index].id = index
        }
        updateStates()
    }
    
    // MARK: Alphabet
    func setNewAlphabet(_ text: String, id: Int) {
        tapes[id].alphabet = text
        updateStates()
    }
    
    // MARK: Input
    func setNewInput(_ text: String, id: Int) {
        tapes[id].input = text
    }
    
}
