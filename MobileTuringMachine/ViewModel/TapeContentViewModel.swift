//
//  TapeContentViewModel.swift
//  MobileTuringMachine
//
//  Created by Snow Lukin on 13.03.2022.
//

import Foundation

class TapeContentViewModel: ObservableObject {
    
    @Published var amountOfTapes = 2
    @Published var tapes: [Tape] = [Tape(id: 0), Tape(id: 1)]
    @Published var amountOfStates: Int = 5
    @Published var exits: [Exit] = [Exit(id: 0), Exit(id: 1), Exit(id: 2), Exit(id: 3), Exit(id: 4)]
    
    @Published var firstElementInGrid = true
    
    var optionStateArray: [OptionState] {
        var result: [OptionState] = []
        
        for stateIndex in 0..<amountOfStates {
            let combinations = getArrayOfAllExits()
            for combinationIndex in 0..<combinations.count {
                let optionState = OptionState(
                    idInRow: combinationIndex,
                    combination: combinations[combinationIndex],
                    stateID: stateIndex
                )
                result.append(optionState)
            }
        }
        return result
    }
}

extension TapeContentViewModel {
    
    func addState(expectedString: String) {
        amountOfStates += 1
    }
    
    func deleteExitState(exitID: Int, stateID: Int) {
        exits[exitID].toLetters.remove(at: stateID)
    }
    
    func editExitStateToLetters(exitID: Int, stateID: Int, string: String) {
        exits[exitID].toLetters[stateID] = string
    }
    
    func addExit() {
        let lastIndex = exits.count - 1
//        exits.append(Exit(id: lastIndex, expectedLetters: getArrayOfAllExits().last!, toLetters: <#T##[String]#>, moving: <#T##[Exit.Side]#>))ч
    }
    
    func updateExits(exitID: Int, expectedString: String) {
        exits[exitID].expectedLetters = expectedString
        for _ in 0..<amountOfStates {
            exits[exitID].toLetters.append(expectedString)
        }
    }
    
    func getArrayOfStates() -> [Int] {
        var array: [Int] = []
        
        for value in 0..<amountOfStates {
            array.append(value)
        }
        return array
    }
    
    func getAmountOfExits() -> Int {
        var result = 1
        for tape in tapes {
            result *= tape.alphabetArray.count
        }
        return result
    }
    
    func addTape() {
        amountOfTapes += 1
        tapes.append(Tape(id: amountOfTapes - 1))
//        updateExitExpectedLetters(exitID: amountOfStates - 1, expectedString: <#T##String#>)
    }
    
    func removeTape(id: Int) {
        amountOfTapes -= 1
        tapes.remove(at: id)
        
        // Rewriting IDs
        for index in 0..<amountOfTapes {
            tapes[index].id = index
        }
        
        updateExits()
    }
    
    func updateExits() {
        exits.removeAll()
        let newExits = getArrayOfAllExits()
        for exit in newExits {
            let index = exits.count - 1
            exits.append(Exit(id: index, expectedLetters: exit, toLetters: [exit], moving: [.stay]))
        }
    }
    
    func setNewAlphabet(_ text: String, id: Int) {
        tapes[id].alphabet = text
    }
    
    func setNewInput(_ text: String, id: Int) {
        tapes[id].input = text
    }
    
}

// MARK: - Get combinations with of all tapes' alphabets
// where First char - first tape, Second char - second tape etc.
extension TapeContentViewModel {
    func getArrayOfAllExits() -> [String] {
        var allArrays: [[String]] = []
        
        for tape in tapes {
            allArrays.append(tape.alphabetArray)
        }
        
        var result: [String] = [""]
        
        for index in 0..<allArrays.count {
            var temp: [String] = []
            
            for word in result {
                temp += subGetArrayOfAllExit(word, from: allArrays[index])
                result.removeAll(where: { $0.count == index || $0.isEmpty })
            }
            result += temp
        }
        return result
    }
    
    private func subGetArrayOfAllExit(_ word: String, from array: [String]) -> [String] {
        
        var result: [String] = []
        
        for letter in array {
            result.append(word + letter)
        }
        return result
    }
}
