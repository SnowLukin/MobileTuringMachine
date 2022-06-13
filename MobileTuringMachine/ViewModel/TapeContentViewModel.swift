//
//  TapeContentViewModel.swift
//  MobileTuringMachine
//
//  Created by Snow Lukin on 13.03.2022.
//

import Foundation

class TapeContentViewModel: ObservableObject {
    
    @Published var tapes: [Tape] = [
        Tape(
            id: 0,
            components: [
                TapeContent(id: -10, value: "_"),
                TapeContent(id: -9, value: "_"),
                TapeContent(id: -8, value: "_"),
                TapeContent(id: -7, value: "_"),
                TapeContent(id: -5, value: "_"),
                TapeContent(id: -4, value: "_"),
                TapeContent(id: -3, value: "_"),
                TapeContent(id: -2, value: "_"),
                TapeContent(id: -1, value: "_"),
                TapeContent(id: 0, value: "_"),
                TapeContent(id: 1, value: "_"),
                TapeContent(id: 2, value: "_"),
                TapeContent(id: 3, value: "_"),
                TapeContent(id: 4, value: "_"),
                TapeContent(id: 5, value: "_"),
                TapeContent(id: 6, value: "_"),
                TapeContent(id: 7, value: "_"),
                TapeContent(id: 8, value: "_"),
                TapeContent(id: 9, value: "_"),
                TapeContent(id: 10, value: "_"),
            ]
        )
    ]
    @Published var states: [StateQ] = [
        StateQ(
            id: 0,
            options: [
                OptionState(
                    id: 0,
                    toStateID: 0,
                    combinationsTuple: [("_", Direction.stay, "_")] )
            ])
    ]
    @Published var startState = 0
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
        // Update indexes
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
            var tapeAlphabet = tape.alphabet.map { String($0) }
            tapeAlphabet.append("_")
            alphabets.append(tapeAlphabet)
        }
        var combinations: [[String]] = []
        getCombinations(array: alphabets, word: [], currentArrayIndex: 0, result: &combinations)
        
        var optionStates: [OptionState] = []
        for combinationIndex in 0..<combinations.count {
            optionStates.append(OptionState(id: combinationIndex, toStateID: stateID, combinationsTuple: getCombinationsTuple(combinations: combinations[combinationIndex])))
        }
        return optionStates
    }
}


// MARK: - Tape
extension TapeContentViewModel {
    
    // MARK: Add
    func addTape() {
        tapes.append(Tape(id: tapes.count, components: getComponents()))
        updateStates()
    }
    
    // MARK: Remove
    func removeTape(id: Int) {
        // Update indexes
        for index in 0..<tapes.count {
            if index == id {
                // Setting to -1 to avoid unexpected errors with matching IDs
                tapes[index].id = -1
            } else if index > id {
                tapes[index].id = tapes[index].id - 1
            }
        }
        tapes.remove(at: id)
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
        
        // TODO: Improve this later
        for index in 0..<tapes[id].components.count {
            tapes[id].components[index].value = "_"
        }
        
        for characterID in 0..<text.count {
            let componentIndex = tapes[id].components.firstIndex { $0.id == characterID }!
            tapes[id].components[componentIndex].value = text.map { String($0) }[characterID]
        }
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
}


// MARK: - Magic
extension TapeContentViewModel {
    
    func makeStep() {
        var combination: [String] = []
        
        // Gathering the components that are under tapes' head index
        for tape in tapes {
            combination.append(tape.components.first(where: { $0.id == tape.headIndex })!.value)
            // TODO: Delete
            print(tape.headIndex)
        }
        
        // MARK: Force unwrapping here cuz its cant happen
        // MARK: Would rather get a crash than continue with that mistake
        // Finding needed option in state
        let optionCombination = states[startState].options.first { option in
            option.combinationsTuple.map { $0.character } == combination
        }!
        
        // TODO: Make it work parallel
        for index in 0..<combination.count {
            let componentIndex = tapes[index].components.firstIndex(where: { $0.id == tapes[index].headIndex }) ?? 0
            tapes[index].components[componentIndex].value = optionCombination.combinationsTuple[index].toCharacter
            switch optionCombination.combinationsTuple[index].direction {
                
            case .stay:
                break
            case .left:
                tapes[index].headIndex -= 1
            case .right:
                tapes[index].headIndex += 1
            }
            // TODO: Delete
            print(tapes[index].headIndex)
        }
        
        // TODO: Publishing changes from background threads is not allowed;
        // TODO: make sure to publish values from the main thread
        // TODO: (via operators like receive(on:)) on model updates.
        startState = optionCombination.toStateID
    }
    
}
