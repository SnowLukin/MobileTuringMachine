//
//  AlgorithmViewModel.swift
//  MobileTuringMachine
//
//  Created by Snow Lukin on 19.06.2022.
//

import Foundation
import Combine

class AlgorithmViewModel: ObservableObject {
    
    @Published var algorithms: [Algorithm] = []
    
    static let fileExtension = "mtm"
    
    let fileManager = LocalFileManager.shared
    
    let tasksDocURL = URL(
      fileURLWithPath: "TuringMachineAlgorithm",
      relativeTo: FileManager.documentsDirectoryURL
    ).appendingPathExtension(fileExtension)
    
    required init() {
        if let savedAlgorithms = fileManager.getData() {
            print("getting saved data")
            algorithms = savedAlgorithms
            return
        }
        print("setting default data")
        
        algorithms = [DefaultData.shared.algorithm]
    }
    
    func saveData() {
        fileManager.saveData(algorithms: algorithms)
    }
}

// MARK: Algorithm
extension AlgorithmViewModel {
    
    func addAlgorithm() {
        var newAlgorithm = DefaultData.shared.algorithm
        // Updating id
        newAlgorithm.id = UUID()
        algorithms.append(newAlgorithm)
//        saveData()
    }
    
    func addImportedAlgorithm(algorithm: Algorithm) {
        var newAlgorithm = algorithm
        // Update id
        newAlgorithm.id = UUID()
        algorithms.append(newAlgorithm)
        saveData()
    }
    
    func removeAlgorithm(_ algorithm: Algorithm) {
        guard let algorithmIndex = algorithms.firstIndex(where: { $0.id == algorithm.id }) else { return }
        algorithms.remove(at: algorithmIndex)
        saveData()
    }
    
    func getAlgorithm(_ algorithm: Algorithm) -> Algorithm {
        guard let algorithmIndex = algorithms.firstIndex(where: { $0.id == algorithm.id }) else { return algorithms[0] }
        return algorithms[algorithmIndex]
    }
    
    func updateName(with newName: String, for algorithm: Algorithm) {
        guard let algorithmIndex = algorithms.firstIndex(where: { $0.id == algorithm.id }) else { return }
        if newName.isEmpty {
            algorithms[algorithmIndex].name = "New Algorithm"
            return
        }
        algorithms[algorithmIndex].name = newName
        saveData()
    }
    
    func updateDescription(with newDescription: String, for algorithm: Algorithm) {
        guard let algorithmIndex = algorithms.firstIndex(where: { $0.id == algorithm.id }) else { return }
        algorithms[algorithmIndex].description = newDescription
        saveData()
    }
    
}

// MARK: - States
extension AlgorithmViewModel {
    // MARK: Add State
    func addState(for algorithm: Algorithm) {
        guard let algorithmIndex = algorithms.firstIndex(where: { $0.id == algorithm.id }) else {
            print("Error couldnt find algorithm index in AlgorithmViewModel line 34")
            return
        }
            
        // Getting the name
        let nameIDArray = algorithms[algorithmIndex].states.map { $0.nameID }
        guard let max = nameIDArray.max() else { return }
        let fullArray = Array(0...max)
        
        let arrayOfDifferentElements = fullArray.filter { !nameIDArray.contains($0) }
        
        if let firstElement = arrayOfDifferentElements.first {
            // In case there ARE gaps between name ids
            var newState = StateQ(nameID: firstElement, options: [])
            newState.options = getOptions(for: newState, of: algorithm)
            if let indexToInsert = nameIDArray.firstIndex(where: { firstElement < $0 }) {
                algorithms[algorithmIndex].states.insert(newState, at: indexToInsert)
            } else {
                // Shouldn't happen
                algorithms[algorithmIndex].states.append(newState)
            }
        } else {
            // In case there ARE NO gaps between name ids
            guard let endElement = algorithms[algorithmIndex].states.last else { return }
            var newState = StateQ(nameID: endElement.nameID + 1, options: [])
            newState.options = getOptions(for: newState, of: algorithm)
            algorithms[algorithmIndex].states.append(newState)
        }
        saveData()
    }
    
    // MARK: Remove
    func removeState(algorithm: Algorithm, state: StateQ) {
        guard let algorithmIndex = algorithms.firstIndex(where: { $0.id == algorithm.id }) else {
            print("Error couldnt find algorithm index in AlgorithmViewModel line 67")
            return
        }
        if let stateIndex = algorithms[algorithmIndex].states.firstIndex(where: { $0.id == state.id }) {
            // if state that is being deleted is a starting state
            // before deleting we need to set different statring state
            if algorithms[algorithmIndex].states[stateIndex].isStarting {
                if stateIndex == 0 {
                    changeStartState(to: algorithms[algorithmIndex].states[1], of: algorithm)
                } else {
                    changeStartState(to: algorithms[algorithmIndex].states[0], of: algorithm)
                }
            }
            algorithms[algorithmIndex].states.remove(at: stateIndex)
        }
        saveData()
    }
    
    // MARK: Update
    func updateStates(for algorithm: Algorithm) {
        guard let algorithmIndex = algorithms.firstIndex(where: { $0.id == algorithm.id }) else {
            print("Error couldnt find algorithm index in AlgorithmViewModel line 87")
            return
        }
        for index in 0..<algorithms[algorithmIndex].states.count {
            algorithms[algorithmIndex].states[index].options = getOptions(for: algorithms[algorithmIndex].states[index], of: algorithm)
        }
        saveData()
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
    
    func getOptions(for state: StateQ, of algorithm: Algorithm) -> [Option] {
        guard let algorithmIndex = algorithms.firstIndex(where: { $0.id == algorithm.id }) else {
            let newOption = Option(toState: state, combinations: [])
            return [newOption]
            
        }
        var alphabets: [[String]] = []
        for tape in algorithms[algorithmIndex].tapes {
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


// MARK: - Tape
extension AlgorithmViewModel {
    
    // MARK: Change head index
    func changeHeadIndex(of tape: Tape, to component: TapeComponent, algorithm: Algorithm) {
        guard let algorithmIndex = algorithms.firstIndex(where: { $0.id == algorithm.id }) else {
            print("Error. Couldnt find algorithm index AlgorithmViewModel line 150.")
            return
        }
        if let tapeIndex = algorithms[algorithmIndex].tapes.firstIndex(where: { $0.id == tape.id }) {
            algorithms[algorithmIndex].tapes[tapeIndex].headIndex = component.id
            saveData()
        }
    }
    
    // MARK: Add
    func addTape(to algorithm: Algorithm) {
        
        guard let algorithmIndex = algorithms.firstIndex(where: { $0.id == algorithm.id }) else {
            print("Error. Couldnt find algorithm index AlgorithmViewModel line 161.")
            return
        }
        
        // Getting the name
        let nameIDArray = algorithms[algorithmIndex].tapes.map { $0.nameID }
        guard let max = nameIDArray.max() else { return }
        
        let fullArray = Array(0...max)
        
        let arrayOfDifferentElements = fullArray.filter { !nameIDArray.contains($0) }
        if let firstElement = arrayOfDifferentElements.first {
            // In case there ARE gaps between name ids
            let newTape = Tape(nameID: firstElement, components: getComponents())
            if let indexToInsert = nameIDArray.firstIndex(where: { firstElement < $0 }) {
                algorithms[algorithmIndex].tapes.insert(newTape, at: indexToInsert)
            } else {
                // Shouldn't happen
                algorithms[algorithmIndex].tapes.append(newTape)
            }
        } else {
            // In case there ARE NO gaps between name ids
            guard let endElement = algorithms[algorithmIndex].tapes.last else { return }
            algorithms[algorithmIndex].tapes.append(Tape(nameID: endElement.nameID + 1, components: getComponents()))
        }
        updateStates(for: algorithms[algorithmIndex])
        saveData()
    }
    
    // MARK: Remove
    func removeTape(tape: Tape, from algorithm: Algorithm) {
        guard let algorithmIndex = algorithms.firstIndex(where: { $0.id == algorithm.id }) else {
            print("Error. Couldnt find algorithm index AlgorithmViewModel line 192.")
            return
        }
        if let index = algorithms[algorithmIndex].tapes.firstIndex(where: { $0.id == tape.id }) {
            algorithms[algorithmIndex].tapes.remove(at: index)
        }
        updateStates(for: algorithms[algorithmIndex])
        saveData()
    }
    
    // MARK: Alphabet
    func setNewAlphabet(_ text: String, tape: Tape, algorithm: Algorithm) {
        
        guard let algorithmIndex = algorithms.firstIndex(where: { $0.id == algorithm.id }) else {
            print("Error. Couldnt find algorithm index AlgorithmViewModel line 205.")
            return
        }
        
        guard let tapeIndex = algorithms[algorithmIndex].tapes.firstIndex(where: { $0.id == tape.id }) else {
            print("viewModel couldnt find tape index for setNewAlphabet function")
            return
        }
        // Update alphabet
        algorithms[algorithmIndex].tapes[tapeIndex].alphabet = text
        updateStates(for: algorithms[algorithmIndex])
        saveData()
    }
    
    // MARK: Input
    func setNewInput(_ text: String, tape: Tape, algorithm: Algorithm) {
        
        guard let algorithmIndex = algorithms.firstIndex(where: { $0.id == algorithm.id }) else {
            print("Error. Couldnt find algorithm index AlgorithmViewModel line 222.")
            return
        }
        guard let tapeIndex = algorithms[algorithmIndex].tapes.firstIndex(where: { $0.id == tape.id }) else {
            print("viewModel couldnt find tape index for setNewInput function")
            return
        }
        
        // Update input
        algorithms[algorithmIndex].tapes[tapeIndex].input = text
        
        updateComponents(tape: tape, algorithm: algorithms[algorithmIndex])
        saveData()
    }
    
    func updateComponents(tape: Tape, algorithm: Algorithm) {
        guard let algorithmIndex = algorithms.firstIndex(where: { $0.id == algorithm.id }) else {
            print("Error. Couldnt find algorithm index AlgorithmViewModel line 239.")
            return
        }
        guard let tapeIndex = algorithms[algorithmIndex].tapes.firstIndex(where: { $0.id == tape.id }) else {
            print("viewModel couldnt find tape index for setNewInput function")
            return
        }
        
        // Reset values
        for componentIndex in 0..<algorithms[algorithmIndex].tapes[tapeIndex].components.count {
            algorithms[algorithmIndex].tapes[tapeIndex].components[componentIndex].value = "_"
        }
        
        // Update values according to input
        for characterID in 0..<algorithms[algorithmIndex].tapes[tapeIndex].input.count {
            if let componentIndex = algorithms[algorithmIndex].tapes[tapeIndex].components.firstIndex(where: { $0.id == characterID }) {
                algorithms[algorithmIndex].tapes[tapeIndex].components[componentIndex].value = algorithms[algorithmIndex].tapes[tapeIndex].input.map { String($0) }[characterID]
            }
        }
    }
    
    func updateAllTapesComponents(for algorithm: Algorithm) {
        guard let algorithmIndex = algorithms.firstIndex(where: { $0.id == algorithm.id }) else {
            print("Error. Couldnt find algorithm index AlgorithmViewModel line 239.")
            return
        }
        
        for tapeIndex in 0..<algorithms[algorithmIndex].tapes.count {
            updateComponents(tape: algorithms[algorithmIndex].tapes[tapeIndex], algorithm: algorithm)
            algorithms[algorithmIndex].tapes[tapeIndex].headIndex = 0
        }
    }
    
    // MARK: Components
    func getComponents() -> [TapeComponent] {
        var components: [TapeComponent] = []
        for index in -10...10 {
            components.append(
                TapeComponent(
                    id: index,
                    value: "_"
                )
            )
        }
        return components
    }
}

// MARK: - ChooseStateView
extension AlgorithmViewModel {
    func updateOptionToState(algorithm: Algorithm, state: StateQ, option: Option, currentState: StateQ) {
        guard let algorithmIndex = algorithms.firstIndex(where: { $0.id == algorithm.id }) else { return }
        guard let stateIndex = algorithms[algorithmIndex].states.firstIndex(where: { $0.id == state.id }) else { return }
        guard let optionIndex = algorithms[algorithmIndex].states[stateIndex].options.firstIndex(where: { $0.id == option.id }) else { return }
        algorithms[algorithmIndex].states[stateIndex].options[optionIndex].toState = currentState
        saveData()
    }
    
    func isChosenToState(algorithm: Algorithm, state: StateQ, option: Option, currentState: StateQ) -> Bool {
        guard let algorithmIndex = algorithms.firstIndex(where: { $0.id == algorithm.id }) else { return false }
        guard let stateIndex = algorithms[algorithmIndex].states.firstIndex(where: { $0.id == state.id }) else { return false }
        guard let optionIndex = algorithms[algorithmIndex].states[stateIndex].options.firstIndex(where: { $0.id == option.id }) else { return false }
        return algorithms[algorithmIndex].states[stateIndex].options[optionIndex].toState.id == currentState.id
    }
}

// MARK: - CombinationView
extension AlgorithmViewModel {
    func getMatchingTape(algorithm: Algorithm, state: StateQ, option: Option, combination: Combination) -> Tape {
        guard let algorithmIndex = algorithms.firstIndex(where: { $0.id == algorithm.id }) else { return algorithms[0].tapes[0] }
        guard let stateIndex = algorithms[algorithmIndex].states.firstIndex(where: { $0.id == state.id }) else { return algorithms[algorithmIndex].tapes[0] }
        guard let optionIndex = algorithms[algorithmIndex].states[stateIndex].options.firstIndex(where: { $0.id == option.id }) else { return algorithms[algorithmIndex].tapes[0] }
        guard let combinationIndex = algorithms[algorithmIndex].states[stateIndex].options[optionIndex].combinations.firstIndex(
            where: { $0.id == combination.id }
        ) else { return algorithms[algorithmIndex].tapes[0] }
        return algorithms[algorithmIndex].tapes[combinationIndex]
    }
    
    func getOptionToState(algorithm: Algorithm, state: StateQ, option: Option) -> Int {
        guard let algorithmIndex = algorithms.firstIndex(where: { $0.id == algorithm.id }) else { return 0 }
        guard let stateIndex = algorithms[algorithmIndex].states.firstIndex(where: { $0.id == state.id }) else { return 0 }
        guard let optionIndex = algorithms[algorithmIndex].states[stateIndex].options.firstIndex(where: { $0.id == option.id }) else { return 0 }
        return algorithms[algorithmIndex].states[stateIndex].options[optionIndex].toState.nameID
    }
}

extension AlgorithmViewModel {
    
    func getCombination(algorithm: Algorithm, state: StateQ, option: Option, combination: Combination) -> Combination? {
        guard let algorithmIndex = algorithms.firstIndex(where: { $0.id == algorithm.id }) else { return nil }
        guard let stateIndex = algorithms[algorithmIndex].states.firstIndex(where: { $0.id == state.id }) else { return nil }
        guard let optionIndex = algorithms[algorithmIndex].states[stateIndex].options.firstIndex(
            where: { $0.id == option.id }
        ) else { return nil }
        guard let combinationIndex = algorithms[algorithmIndex].states[stateIndex].options[optionIndex].combinations.firstIndex(
            where: { $0.id == combination.id }
        ) else { return nil }
        
        return algorithms[algorithmIndex].states[stateIndex].options[optionIndex].combinations[combinationIndex]
    }
    
    func updateCombinationToChar(algorithm: Algorithm, state: StateQ, option: Option, combination: Combination, alphabetElement: String) {
        guard let algorithmIndex = algorithms.firstIndex(where: { $0.id == algorithm.id }) else { return }
        guard let stateIndex = algorithms[algorithmIndex].states.firstIndex(where: { $0.id == state.id }) else { return }
        guard let optionIndex = algorithms[algorithmIndex].states[stateIndex].options.firstIndex(
            where: { $0.id == option.id }
        ) else { return }
        guard let combinationIndex = algorithms[algorithmIndex].states[stateIndex].options[optionIndex].combinations.firstIndex(
            where: { $0.id == combination.id }
        ) else { return }
        
        algorithms[algorithmIndex].states[stateIndex].options[optionIndex].combinations[combinationIndex].toCharacter = alphabetElement
        saveData()
    }
    
    func updateCombinationDirection(algorithm: Algorithm, state: StateQ, option: Option, combination: Combination, direction: Direction) {
        guard let algorithmIndex = algorithms.firstIndex(where: { $0.id == algorithm.id }) else { return }
        guard let stateIndex = algorithms[algorithmIndex].states.firstIndex(where: { $0.id == state.id }) else { return }
        guard let optionIndex = algorithms[algorithmIndex].states[stateIndex].options.firstIndex(
            where: { $0.id == option.id }
        ) else { return }
        guard let combinationIndex = algorithms[algorithmIndex].states[stateIndex].options[optionIndex].combinations.firstIndex(
            where: { $0.id == combination.id }
        ) else { return }
        
        algorithms[algorithmIndex].states[stateIndex].options[optionIndex].combinations[combinationIndex].direction = direction
        saveData()
    }
    
    func isChosenChar(algorithm: Algorithm, state: StateQ, option: Option, tape: Tape, combination: Combination, alphabetElement: String) -> Bool {
        guard let algorithmIndex = algorithms.firstIndex(where: { $0.id == algorithm.id }) else { return false }
        guard let stateIndex = algorithms[algorithmIndex].states.firstIndex(where: { $0.id == state.id }) else { return false }
        guard let optionIndex = algorithms[algorithmIndex].states[stateIndex].options.firstIndex(
            where: { $0.id == option.id }
        ) else { return false }
        guard let tapeIndex = algorithms[algorithmIndex].tapes.firstIndex(where: { $0.id == tape.id }) else { return false }
        guard let combinationIndex = algorithms[algorithmIndex].states[stateIndex].options[optionIndex].combinations.firstIndex(
            where: { $0.id == combination.id }
        ) else { return false}
        
        guard let alphabetElementIndex = algorithms[algorithmIndex].tapes[tapeIndex].alphabetArray.firstIndex(where: { $0 == alphabetElement}) else { return false }
        
        return algorithms[algorithmIndex].states[stateIndex].options[optionIndex].combinations[combinationIndex].toCharacter == algorithms[algorithmIndex].tapes[tapeIndex].alphabetArray[alphabetElementIndex]
    }
    
    func isChosenDirection(algorithm: Algorithm, state: StateQ, option: Option, tape: Tape, combination: Combination, direction: Direction) -> Bool {
        guard let algorithmIndex = algorithms.firstIndex(where: { $0.id == algorithm.id }) else { return false }
        guard let stateIndex = algorithms[algorithmIndex].states.firstIndex(where: { $0.id == state.id }) else { return false }
        guard let optionIndex = algorithms[algorithmIndex].states[stateIndex].options.firstIndex(
            where: { $0.id == option.id }
        ) else { return false }
        guard let combinationIndex = algorithms[algorithmIndex].states[stateIndex].options[optionIndex].combinations.firstIndex(
            where: { $0.id == combination.id }
        ) else { return false}
        
        return algorithms[algorithmIndex].states[stateIndex].options[optionIndex].combinations[combinationIndex].direction == direction
    }
}

// MARK: - Tape View
extension AlgorithmViewModel {
    
    func getTape(tape: Tape, of algorithm: Algorithm) -> Tape {
        guard let algorithmIndex = algorithms.firstIndex(where: { $0.id == algorithm.id }) else { return algorithms[0].tapes[0] }
        guard let tapeIndex = algorithms[algorithmIndex].tapes.firstIndex(where: { $0.id == tape.id }) else {
            return algorithms[algorithmIndex].tapes[0]
        }
        return algorithms[algorithmIndex].tapes[tapeIndex]
    }
    
    func getTapeComponent(algorithm: Algorithm, tape: Tape, component: TapeComponent) -> TapeComponent {
        let currentTape = getTape(tape: tape, of: algorithm)
        guard let componentIndex = currentTape.components.firstIndex(where: { $0.id == component.id }) else {
            return currentTape.components[0]
        }
        return currentTape.components[componentIndex]
    }
    
    func getStartState(of algorithm: Algorithm) -> StateQ {
        guard let algorithmIndex = algorithms.firstIndex(where: { $0.id == algorithm.id }) else {
            return algorithms[0].states[0]
        }
        guard let startStateIndex = algorithms[algorithmIndex].states.firstIndex(where: { $0.isStarting }) else {
            print("Error. Couldnt find start state: TapeContentViewModel, line 337")
            return algorithms[algorithmIndex].states[0]
        }
        return algorithms[algorithmIndex].states[startStateIndex]
    }
    
    func changeStartState(to state: StateQ, of algorithm: Algorithm) {
        guard let algorithmIndex = algorithms.firstIndex(where: { $0.id == algorithm.id }) else { return }
        guard let startStateIndex = algorithms[algorithmIndex].states.firstIndex(where: { $0.isStarting }) else {
            print("Error. Couldnt find start state")
            return
        }
        algorithms[algorithmIndex].states[startStateIndex].isStarting.toggle()
        guard let newStartStateIndex = algorithms[algorithmIndex].states.firstIndex(where: { $0.id == state.id }) else { return }
        algorithms[algorithmIndex].states[newStartStateIndex].isStarting.toggle()
        algorithms[algorithmIndex].stateForReset = algorithms[algorithmIndex].states[newStartStateIndex]
        saveData()
    }
}


// MARK: - Magic
extension AlgorithmViewModel {
    
    func reset(algorithm: Algorithm) {
        guard let algorithmIndex = algorithms.firstIndex(where: { $0.id == algorithm.id }) else { return }
        updateAllTapesComponents(for: algorithm)
        for stateIndex in 0..<algorithms[algorithmIndex].states.count {
            algorithms[algorithmIndex].states[stateIndex].isStarting = false
        }
        guard let startStateIndex = algorithms[algorithmIndex].states.firstIndex(where: { $0.id == algorithms[algorithmIndex].stateForReset.id }) else {
            print("Error. Couldnt find startStateIndex for reset. TapeContentViewModel, line 365")
            return
        }
        algorithms[algorithmIndex].states[startStateIndex].isStarting.toggle()
    }
    
    func makeStep(algorithm: Algorithm) {
        guard let algorithmIndex = algorithms.firstIndex(where: { $0.id == algorithm.id }) else { return }
        
        var combination: [String] = []
        
        // Gathering the components that are under tapes' head index
        for tape in algorithms[algorithmIndex].tapes {
            if let componentIndex = tape.components.firstIndex(where: { $0.id == tape.headIndex }) {
                combination.append(tape.components[componentIndex].value)
            }
        }
        
        // Finding index of starting state
        guard let startStateIndex = algorithms[algorithmIndex].states.firstIndex(where: { $0.isStarting }) else {
            print("Error. Couldnt find start state index: TapeContentViewModel, line 383")
            return
        }
        
        // Finding needed option in state
        guard let optionCombination = algorithms[algorithmIndex].states[startStateIndex].options.first(where: { $0.combinations.map { $0.character } == combination }) else {
            print("Error. Couldnt find optionCombination")
            return
        }
        
        for index in 0..<combination.count {
            guard let componentIndex = algorithms[algorithmIndex].tapes[index].components.firstIndex(where: { $0.id == algorithms[algorithmIndex].tapes[index].headIndex }) else { return }
            DispatchQueue.main.async {
                self.algorithms[algorithmIndex].tapes[index].components[componentIndex].value = optionCombination.combinations[index].toCharacter
            }
            switch optionCombination.combinations[index].direction {
                
            case .stay:
                break
            case .left:
                DispatchQueue.main.async {
                    self.algorithms[algorithmIndex].tapes[index].headIndex -= 1
                }
            case .right:
                DispatchQueue.main.async {
                    self.algorithms[algorithmIndex].tapes[index].headIndex += 1
                }
            }
        }
        
        // Setting new start state
        DispatchQueue.main.async {
            self.algorithms[algorithmIndex].states[startStateIndex].isStarting.toggle()
            guard let toStateIndex = self.algorithms[algorithmIndex].states.firstIndex(where: { $0.id == optionCombination.toState.id }) else {
                print("Error. Couldnt find index of toState.")
                return
            }
            self.algorithms[algorithmIndex].states[toStateIndex].isStarting.toggle()
        }
    }
    
}
