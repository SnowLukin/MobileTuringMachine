//
//  TapeContentViewModel.swift
//  MobileTuringMachine
//
//  Created by Snow Lukin on 13.03.2022.
//

import Foundation

class TapeContentViewModel: ObservableObject {
    @Published var tapes: [Tape] = Data().tapes
    @Published var states: [StateQ] = [Data.shared]
    @Published var startState: StateQ = Data.shared
}

// MARK: - States
extension TapeContentViewModel {
    
    // MARK: Add
    func addState() {
        // Getting the name
        let nameIDArray = states.map { $0.nameID }
        guard let max = nameIDArray.max() else { return }
        let fullArray = Array(0...max)
        
        let arrayOfDifferentElements = fullArray.filter { !nameIDArray.contains($0) }
        
        if let firstElement = arrayOfDifferentElements.first {
            // In case there ARE gaps between name ids
            var newState = StateQ(nameID: firstElement, options: [])
            newState.options = getOptionStates(state: newState)
            if let indexToInsert = nameIDArray.firstIndex(where: { firstElement < $0 }) {
                states.insert(newState, at: indexToInsert)
            } else {
                // Shouldn't happen
                states.append(newState)
            }
        } else {
            // In case there ARE NO gaps between name ids
            guard let endElement = states.last else { return }
            var newState = StateQ(nameID: endElement.nameID + 1, options: [])
            newState.options = getOptionStates(state: newState)
            states.append(newState)
        }
    }
    
    // MARK: Remove
    func removeState(state: StateQ) {
        if let stateIndex = states.firstIndex(where: { $0.id == state.id }) {
            states.remove(at: stateIndex)
        }
    }
    
    // MARK: Update
    func updateStates() {
        for index in 0..<states.count {
            states[index].options = getOptionStates(state: states[index])
        }
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


// MARK: - Tape
extension TapeContentViewModel {
    
    // MARK: Change head index
    func changeHeadIndex(of tape: Tape, to component: TapeContent) {
        if let tapeIndex = tapes.firstIndex(where: { $0.id == tape.id }) {
            tapes[tapeIndex].headIndex = component.id
        }
    }
    
    // MARK: Add
    func addTape() {
        
        // Getting the name
        let nameIDArray = tapes.map { $0.nameID }
        guard let max = nameIDArray.max() else { return }
        
        let fullArray = Array(0...max)
        
        let arrayOfDifferentElements = fullArray.filter { !nameIDArray.contains($0) }
        if let firstElement = arrayOfDifferentElements.first {
            // In case there ARE gaps between name ids
            let newTape = Tape(nameID: firstElement, components: getComponents())
            if let indexToInsert = nameIDArray.firstIndex(where: { firstElement < $0 }) {
                tapes.insert(newTape, at: indexToInsert)
            } else {
                // Shouldn't happen
                tapes.append(newTape)
            }
        } else {
            // In case there ARE NO gaps between name ids
            guard let endElement = tapes.last else { return }
            tapes.append(Tape(nameID: endElement.nameID + 1, components: getComponents()))
        }
        updateStates()
    }
    
    // MARK: Remove
    func removeTape(tape: Tape) {
        if let index = tapes.firstIndex(where: { $0.id == tape.id }) {
            tapes.remove(at: index)
        }
        updateStates()
    }
    
    // MARK: Alphabet
    func setNewAlphabet(_ text: String, tape: Tape) {
        guard let tapeIndex = tapes.firstIndex(where: { $0.id == tape.id }) else { return }
        // Update alphabet
        tapes[tapeIndex].alphabet = text
        updateStates()
    }
    
    // MARK: Input
    func setNewInput(_ text: String, tape: Tape) {
        guard let tapeIndex = tapes.firstIndex(where: { $0.id == tape.id }) else { return }
        
        // Update input
        tapes[tapeIndex].input = text
        
        // Reset values
        for componentIndex in 0..<tapes[tapeIndex].components.count {
            tapes[tapeIndex].components[componentIndex].value = "_"
        }
        
        // Update values according to input
        for characterID in 0..<text.count {
            if let componentIndex = tapes[tapeIndex].components.firstIndex(where: { $0.id == characterID }) {
                tapes[tapeIndex].components[componentIndex].value = text.map { String($0) }[characterID]
            }
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

// MARK: - ChooseStateView
extension TapeContentViewModel {
    func updateOptionToState(state: StateQ, option: OptionState, currentState: StateQ) {
        guard let stateIndex = states.firstIndex(where: { $0.id == state.id }) else { return }
        guard let optionIndex = states[stateIndex].options.firstIndex(where: { $0.id == option.id }) else { return }
        states[stateIndex].options[optionIndex].toState = currentState
    }
    
    func isChosenToState(state: StateQ, option: OptionState, currentState: StateQ) -> Bool {
        guard let stateIndex = states.firstIndex(where: { $0.id == state.id }) else { return false }
        guard let optionIndex = states[stateIndex].options.firstIndex(where: { $0.id == option.id }) else { return false }
        return states[stateIndex].options[optionIndex].toState.id == currentState.id
    }
}

// MARK: - CombinationView
extension TapeContentViewModel {
    func getMatchingTape(state: StateQ, option: OptionState, combination: Combination) -> Tape {
        guard let stateIndex = states.firstIndex(where: { $0.id == state.id }) else { return tapes[0] }
        guard let optionIndex = states[stateIndex].options.firstIndex(where: { $0.id == option.id }) else { return tapes[0] }
        guard let combinationIndex = states[stateIndex].options[optionIndex].combinations.firstIndex(
            where: { $0.id == combination.id }
        ) else { return tapes[0] }
        return tapes[combinationIndex]
    }
    
    func getOptionToState(state: StateQ, option: OptionState) -> Int {
        guard let stateIndex = states.firstIndex(where: { $0.id == state.id }) else { return 0 }
        guard let optionIndex = states[stateIndex].options.firstIndex(where: { $0.id == option.id }) else { return 0 }
        return states[stateIndex].options[optionIndex].toState.nameID
    }
}

extension TapeContentViewModel {
    
    func getCombination(state: StateQ, option: OptionState, combination: Combination) -> Combination? {
        guard let stateIndex = states.firstIndex(where: { $0.id == state.id }) else { return nil }
        guard let optionIndex = states[stateIndex].options.firstIndex(
            where: { $0.id == option.id }
        ) else { return nil }
        guard let combinationIndex = states[stateIndex].options[optionIndex].combinations.firstIndex(
            where: { $0.id == combination.id }
        ) else { return nil }
        
        return states[stateIndex].options[optionIndex].combinations[combinationIndex]
    }
    
    func updateCombinationToChar(state: StateQ, option: OptionState, combination: Combination, alphabetElement: String) {
        guard let stateIndex = states.firstIndex(where: { $0.id == state.id }) else { return }
        guard let optionIndex = states[stateIndex].options.firstIndex(
            where: { $0.id == option.id }
        ) else { return }
        guard let combinationIndex = states[stateIndex].options[optionIndex].combinations.firstIndex(
            where: { $0.id == combination.id }
        ) else { return }
        
        states[stateIndex].options[optionIndex].combinations[combinationIndex].toCharacter = alphabetElement
    }
    
    func updateCombinationDirection(state: StateQ, option: OptionState, combination: Combination, direction: Direction) {
        guard let stateIndex = states.firstIndex(where: { $0.id == state.id }) else { return }
        guard let optionIndex = states[stateIndex].options.firstIndex(
            where: { $0.id == option.id }
        ) else { return }
        guard let combinationIndex = states[stateIndex].options[optionIndex].combinations.firstIndex(
            where: { $0.id == combination.id }
        ) else { return }
        
        states[stateIndex].options[optionIndex].combinations[combinationIndex].direction = direction
    }
    
    func isChosenChar(state: StateQ, option: OptionState, tape: Tape, combination: Combination, alphabetElement: String) -> Bool {
        guard let stateIndex = states.firstIndex(where: { $0.id == state.id }) else { return false }
        guard let optionIndex = states[stateIndex].options.firstIndex(
            where: { $0.id == option.id }
        ) else { return false }
        guard let tapeIndex = tapes.firstIndex(where: { $0.id == tape.id }) else { return false }
        guard let combinationIndex = states[stateIndex].options[optionIndex].combinations.firstIndex(
            where: { $0.id == combination.id }
        ) else { return false}
        
        guard let alphabetElementIndex = tapes[tapeIndex].alphabetArray.firstIndex(where: { $0 == alphabetElement}) else { return false }
        
        return states[stateIndex].options[optionIndex].combinations[combinationIndex].toCharacter == tapes[tapeIndex].alphabetArray[alphabetElementIndex]
    }
    
    func isChosenDirection(state: StateQ, option: OptionState, tape: Tape, combination: Combination, direction: Direction) -> Bool {
        guard let stateIndex = states.firstIndex(where: { $0.id == state.id }) else { return false }
        guard let optionIndex = states[stateIndex].options.firstIndex(
            where: { $0.id == option.id }
        ) else { return false }
        guard let combinationIndex = states[stateIndex].options[optionIndex].combinations.firstIndex(
            where: { $0.id == combination.id }
        ) else { return false}
        
        return states[stateIndex].options[optionIndex].combinations[combinationIndex].direction == direction
    }
}


// MARK: - Magic
extension TapeContentViewModel {
    
    func makeStep() {
        var combination: [String] = []
        
        // Gathering the components that are under tapes' head index
        for tape in tapes {
            if let componentIndex = tape.components.firstIndex(where: { $0.id == tape.headIndex }) {
                combination.append(tape.components[componentIndex].value)
            }
        }
        
        // Finding needed option in state
        guard let optionCombination = startState.options.first(where: { $0.combinations.map { $0.character } == combination }) else {
            return
        }
        
        for index in 0..<combination.count {
            guard let componentIndex = tapes[index].components.firstIndex(where: { $0.id == tapes[index].headIndex }) else { return }
            DispatchQueue.main.async {
                self.tapes[index].components[componentIndex].value = optionCombination.combinations[index].toCharacter
            }
            switch optionCombination.combinations[index].direction {
                
            case .stay:
                break
            case .left:
                DispatchQueue.main.async {
                    self.tapes[index].headIndex -= 1
                }
            case .right:
                DispatchQueue.main.async {
                    self.tapes[index].headIndex += 1
                }
            }
        }
        DispatchQueue.main.async {
            self.startState = optionCombination.toState
        }
    }
    
}
