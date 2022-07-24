//
//  AlgorithmViewModel2.swift
//  MobileTuringMachine
//
//  Created by Snow Lukin on 27.06.2022.
//

import SwiftUI

class AlgorithmViewModel: ObservableObject {
    
    enum userDefaultsKeys: String {
        case folder = "folder"
        case algorithm = "algorithm"
    }
    
    let dataManager = DataManager.shared
    let userDefaults = UserDefaults.standard
    
    @Published var isFullSecondaryScreen = false
    @Published var listSelection = Set<Algorithm>()
    @Published var selectedFolder: Folder? {
        didSet {
            print("Setting selected folder")
            if let folderName = selectedFolder?.name {
                print("Setting folder to userdefaults")
                userDefaults.set(folderName, forKey: userDefaultsKeys.folder.rawValue)
            } else {
                print("Removing folder in userdefaults")
                userDefaults.removeObject(forKey: userDefaultsKeys.folder.rawValue)
            }
        }
    }
    @Published var selectedAlgorithm: Algorithm? {
        didSet {
            print("Setting selected algorithm")
            if let algorithmID = selectedAlgorithm?.id?.uuidString {
                print("Setting algorithm to userdefaults")
                userDefaults.set(algorithmID, forKey: userDefaultsKeys.algorithm.rawValue)
            } else {
                print("Deleting algorithm in userdefaults")
                userDefaults.removeObject(forKey: userDefaultsKeys.algorithm.rawValue)
            }
        }
    }
    
    required init() {
        if !dataManager.isEmpty() {
            dataManager.getFolders()
            guard let startFolderName = userDefaults.value(forKey: "folder") as? String else {
                print("Start folder name wasnt found")
                return
            }
            guard let startFolder = dataManager.savedFolders.first(where: { $0.name == startFolderName }) else {
                print("Error getting start folder.")
                return
            }
            selectedFolder = startFolder
            guard let startAlgorithmID = userDefaults.value(forKey: "algorithm") as? String else {
                print("Start algorithm id wasnt found.")
                return
            }
            guard let startAlgorithm = startFolder.wrappedAlgorithms.first(where: { $0.id?.uuidString == startAlgorithmID }) else {
                print("Error getting start algorithm")
                return
            }
            selectedAlgorithm = startAlgorithm
        } else {
            print("Setting default data...")
            addFolder(name: "Algorithms")
            guard let algorithmsFolder = dataManager.savedFolders.first else {
                print("Error getting Algorithms Folder.")
                return
            }
            selectedFolder = algorithmsFolder
        }
    }
}

extension AlgorithmViewModel {
    // MARK: Export
    func convertToStruct(_ algorithm: Algorithm) -> AlgorithmJSON {
        var tapes: [TapeJSON] = []
        var states: [StateQJSON] = []
        for tape in algorithm.wrappedTapes {
            tapes.append(convertToStruct(tape))
        }
        for state in algorithm.wrappedStates {
            states.append(convertToStruct(state))
        }
        return AlgorithmJSON(name: algorithm.name, algorithmDescription: algorithm.algorithmDescription, states: states, tapes: tapes)
    }
    private func convertToStruct(_ tape: Tape) -> TapeJSON {
        TapeJSON(nameID: tape.nameID, headIndex: tape.headIndex, alphabet: tape.alphabet, input: tape.input)
    }
    private func convertToStruct(_ state: StateQ) -> StateQJSON {
        var options: [OptionJSON] = []
        for option in state.wrappedOptions {
            options.append(convertToStruct(option))
        }
        return StateQJSON(
            id: state.id!,
            nameID: state.nameID,
            isForReset: state.isForReset,
            isStarting: state.isStarting,
            options: options
        )
    }
    private func convertToStruct(_ option: Option) -> OptionJSON {
        var combinations: [CombinationJSON] = []
        for combination in option.wrappedCombinations {
            combinations.append(convertToStruct(combination))
        }
        return OptionJSON(id: option.id, toStateID: option.toStateID, combinations: combinations)
    }
    private func convertToStruct(_ combination: Combination) -> CombinationJSON {
        CombinationJSON(
            id: combination.id,
            character: combination.character,
            directionID: combination.directionID,
            toCharacter: combination.toCharacter
        )
    }
    
    // MARK: Import
    func importAlgorithm(_ algorithm: AlgorithmJSON, to folder: Folder) {
        let algorithmEntity = Algorithm(context: dataManager.container.viewContext)
        algorithmEntity.initValues(
            name: algorithm.name,
            algorithmDescription: algorithm.algorithmDescription,
            folder: folder,
            states: [],
            tapes: []
        )
        
        for tape in algorithm.tapes {
            importTape(tape, to: algorithmEntity)
        }
        for state in algorithm.states {
            importState(state, to: algorithmEntity)
        }
        
        folder.addToAlgorithms(algorithmEntity)
        dataManager.applyChanges()
        objectWillChange.send()
    }
    private func importTape(_ tape: TapeJSON, to algorithm: Algorithm) {
        let tapeEntity = Tape(context: dataManager.container.viewContext)
        tapeEntity.initValues(
            nameID: Int(tape.nameID),
            alphabet: tape.alphabet,
            input: tape.input,
            headIndex: Int(tape.headIndex),
            components: [],
            algorithm: algorithm
        )
        addComponent(tape: tapeEntity)
        updateComponents(for: tapeEntity)
        
        algorithm.addToTapes(tapeEntity)
    }
    private func importState(_ state: StateQJSON, to algorithm: Algorithm) {
        let stateEntity = StateQ(context: dataManager.container.viewContext)
        stateEntity.initValues(
            id: state.id,
            nameID: Int(state.nameID),
            isStarting: state.isStarting,
            isForReset: state.isForReset,
            options: [],
            algorithm: algorithm
        )
        for option in state.options {
            importOption(option, to: stateEntity)
        }
        algorithm.addToStates(stateEntity)
    }
    private func importOption(_ option: OptionJSON, to state: StateQ) {
        let optionEntity = Option(context: dataManager.container.viewContext)
        optionEntity.initValues(id: Int(option.id), toStateID: option.toStateID, combinations: [], state: state)
        for combination in option.combinations {
            importCombination(combination, to: optionEntity)
        }
        state.addToOptions(optionEntity)
    }
    private func importCombination(_ combination: CombinationJSON, to option: Option) {
        let combinationEntity = Combination(context: dataManager.container.viewContext)
        combinationEntity.initValues(id: Int(combination.id), character: combination.character, directionID: Int(combination.directionID), option: option)
        option.addToCombinations(combinationEntity)
    }
}

extension AlgorithmViewModel {
    
    func togglePinAlgorithm(_ algorithm: Algorithm) {
        algorithm.pinned.toggle()
        dataManager.applyChanges()
        objectWillChange.send()
    }
    
    func moveFolder(_ folder: Folder, to destination: Folder) {
        if let parent = folder.parentFolder {
            parent.removeFromSubFolders(folder)
        }
        destination.addToSubFolders(folder)
        dataManager.applyChanges()
        objectWillChange.send()
    }
    
    func moveAlgorithms(_ algorithms: [Algorithm], to destination: Folder) {
        guard let folder = algorithms.first?.folder else {
            print("Couldnt find folder.")
            return
        }
        for algorithm in algorithms {
            folder.removeFromAlgorithms(algorithm)
            destination.addToAlgorithms(algorithm)
        }
        dataManager.applyChanges()
        objectWillChange.send()
    }
    
    func handleRenamingFolder(_ folder: Folder, newName: String) -> Bool {
        let trimmedFolderNewName = newName.trimmingCharacters(in: .whitespaces)
        for savedFolder in dataManager.savedFolders.filter({ $0 != folder }) {
            let trimmedName = savedFolder.name.trimmingCharacters(in: .whitespaces)
            if trimmedName == trimmedFolderNewName {
                return true
            }
            continue
        }
        folder.name = newName
        dataManager.applyChanges()
        objectWillChange.send()
        return false
    }
    
    func handleAddingNewFolder(name newFolderName: String, parentFolder: Folder? = nil) -> Bool {
        let trimmedNewFolderNameResult = newFolderName.trimmingCharacters(in: .whitespaces)
        if trimmedNewFolderNameResult.isEmpty {
            return true
        }
        
        for folder in dataManager.savedFolders {
            let trimmedName = folder.name.trimmingCharacters(in: .whitespaces)
            if trimmedName == trimmedNewFolderNameResult {
                return true
            }
            continue
        }
        addFolder(name: newFolderName, parentFolder: parentFolder)
        return false
    }
    
    func addFolder(name: String, parentFolder: Folder? = nil) {
        let folder = Folder(context: dataManager.container.viewContext)
        folder.initValues(name: name, parentFolder: parentFolder)
        
        dataManager.applyChanges()
        objectWillChange.send()
    }
    
    func deleteFolder(_ folder: Folder) {
        dataManager.container.viewContext.delete(folder)
        dataManager.applyChanges()
        objectWillChange.send()
    }
    
    func updateName(with newName: String, for algorithm: Algorithm) {
        if newName.isEmpty {
            algorithm.name = "New Algorithm"
        } else {
            algorithm.name = newName
        }
        
        algorithm.editedDate = Date.now
        dataManager.applyChanges()
        objectWillChange.send()
    }
    
    func updateDescription(with newDescription: String, for algorithm: Algorithm) {
        algorithm.algorithmDescription = newDescription
        
        algorithm.editedDate = Date.now
        dataManager.applyChanges()
        objectWillChange.send()
    }
    
    func updateAllTapesComponents(for algorithm: Algorithm) {
        for tape in algorithm.wrappedTapes {
            updateComponents(for: tape)
            tape.headIndex = 0
        }
        
        algorithm.editedDate = Date.now
        dataManager.applyChanges()
        objectWillChange.send()
    }
    
    func getStartStateName(of algorithm: Algorithm) -> StateQ? {
        algorithm.wrappedStates.first(where: { $0.isStarting })
    }
    
    func reset(algorithm: Algorithm) {
        updateAllTapesComponents(for: algorithm)
        for state in algorithm.wrappedStates {
            state.isStarting = state.isForReset
        }
        
        dataManager.applyChanges()
        objectWillChange.send()
    }
    
    func makeStep(algorithm: Algorithm) {
        
        var combination: [String] = []
        
        // Gathering the components that are under tapes' head index
        for tape in algorithm.wrappedTapes {
            guard let component = tape.wrappedComponents.first(where: { $0.id == tape.headIndex }) else {
                print("Error finding component equals to tape head index")
                return
            }
            combination.append(component.value)
        }
        
        // Finding starting state
        guard let startState = algorithm.wrappedStates.first(where: { $0.isStarting }) else {
            print("Error getting start state")
            return
        }
        
        // Finding needed option in state
        guard let currentOption = startState.wrappedOptions.first(where: { $0.wrappedCombinations.map { $0.character } == combination }) else {
            print("Error finding current option")
            return
        }
        
        for index in 0..<combination.count {
            let currentTape = algorithm.wrappedTapes[index]
            guard let component = currentTape.wrappedComponents.first(where: { $0.id == currentTape.headIndex }) else {
                print("Error finding component")
                return
            }
            
            DispatchQueue.main.async {
                component.value = currentOption.wrappedCombinations[index].toCharacter
            }
            switch currentOption.wrappedCombinations[index].directionID {
                
            case 0:
                break
            case 1:
                DispatchQueue.main.async {
                    currentTape.headIndex -= 1
                }
            default:
                DispatchQueue.main.async {
                    currentTape.headIndex += 1
                }
            }
        }
        objectWillChange.send()
        // Setting new start state
        DispatchQueue.main.async {
            startState.isStarting.toggle()
            guard let toState = algorithm.wrappedStates.first(where: { $0.id == currentOption.toStateID }) else {
                print("Error. Couldnt find toState.")
                return
            }
            toState.isStarting.toggle()
            self.objectWillChange.send()
        }
    }
    
}

// MARK: - Tape
extension AlgorithmViewModel {
    func changeHeadIndex(to component: TapeComponent) {
        component.tape.headIndex = component.id
        
        component.tape.algorithm.editedDate = Date.now
        dataManager.applyChanges()
        objectWillChange.send()
    }
    
    func setNewInputValue(_ text: String, for tape: Tape) {
        var text = text
        
        // Return if nothin changed
        if tape.input == text {
            return
        }
        
        // Poping last element if possible.
        guard let lastCharacter = text.popLast() else {
            // If not possible -> text is empty.
            updateInput(text, for: tape)
            return
        }
        
        // if new character is "space" change it to "_"
        if lastCharacter == " " {
            text.append("_")
            updateInput(text, for: tape)
            return
        }
        // if there is such character in alphabet - save it
        // otherwise delete it
        if tape.alphabet.contains(lastCharacter) {
            text.append(lastCharacter)
        }
        updateInput(text, for: tape)
    }
    
    private func removeInputCharactersWhichAreNotInAlphabet(for tape: Tape) {
        let filteredInput = tape.input.filter { tape.alphabet.contains($0)}
        updateInput(filteredInput, for: tape)
    }
    
    func setNewAlphabetValue(_ text: String, for tape: Tape) {
        var text = text
        // Return if nothin changed
        if tape.alphabet == text {
            return
        }
        // Poping last element if possible.
        guard let lastCharacter = text.popLast() else {
            // If not possible -> text is empty.
            updateAlphabet(text, for: tape)
            removeInputCharactersWhichAreNotInAlphabet(for: tape)
            return
        }
        // If last character is a "space". Remove it.
        if lastCharacter == " " {
            return
        }  else if !text.contains(lastCharacter) {  // Checking new character already exist
            // if it isn't - add it
            text.append(String(lastCharacter))
            updateAlphabet(text, for: tape)
            removeInputCharactersWhichAreNotInAlphabet(for: tape)
        }
    }
    
    private func updateAlphabet(_ text: String, for tape: Tape) {
        tape.alphabet = text
        updateStates(for: tape.algorithm)
        
        tape.algorithm.editedDate = Date.now
        dataManager.applyChanges()
        objectWillChange.send()
    }
    
    private func updateInput(_ text: String, for tape: Tape) {
        tape.input = text
        updateComponents(for: tape)
        
        tape.algorithm.editedDate = Date.now
        dataManager.applyChanges()
        objectWillChange.send()
    }
    
    private func updateStates(for algorithm: Algorithm) {
        for state in algorithm.wrappedStates {
            for option in state.wrappedOptions {
                state.removeFromOptions(option)
                dataManager.container.viewContext.delete(option)
            }
            let combinations = getPossibleCombinations(for: state)
            addOptions(to: state, combinations: combinations)
        }
        algorithm.editedDate = Date.now
        dataManager.applyChanges()
        objectWillChange.send()
    }
}

// MARK: - State
extension AlgorithmViewModel {
    func changeStartState(to state: StateQ) {
        guard let currentStartingState = state.algorithm.wrappedStates.first(where: { $0.isStarting } ) else {
            print("Error finding current starting state")
            return
        }
        currentStartingState.isStarting.toggle()
        currentStartingState.isForReset.toggle()
        
        state.isStarting.toggle()
        state.isForReset.toggle()
        
        state.algorithm.editedDate = Date.now
        dataManager.applyChanges()
        objectWillChange.send()
    }
}

// MARK: - Option
extension AlgorithmViewModel {
    func updateOptionToState(option: Option, currentState: StateQ) {
        guard let id = currentState.id else {
            print("Error getting current state's id")
            return
        }
        option.toStateID = id
        
        option.state.algorithm.editedDate = Date.now
        dataManager.applyChanges()
        objectWillChange.send()
    }
    
    func isChosenToState(option: Option, currentState: StateQ) -> Bool {
        option.toStateID == currentState.id
    }
    
    func getToStateName(for option: Option) -> Int {
        Int(option.state.algorithm.wrappedStates.first(where: { $0.id == option.toStateID })?.nameID ?? -1)
    }
    
}

// MARK: - Combination
extension AlgorithmViewModel {
    func updateCombinationToChar(combination: Combination, alphabetElement: String) {
        combination.toCharacter = alphabetElement
        
        combination.option.state.algorithm.editedDate = Date.now
        dataManager.applyChanges()
        objectWillChange.send()
    }
    
    func updateCombinationDirection(combination: Combination, directionID: Int) {
        combination.directionID = Int16(directionID)
        
        combination.option.state.algorithm.editedDate = Date.now
        dataManager.applyChanges()
        objectWillChange.send()
    }
    
    func isChosenChar(combination: Combination, alphabetElement: String) -> Bool {
        combination.toCharacter == alphabetElement
    }
    
    func isChosenDirection(combination: Combination, directionID: Int) -> Bool {
        combination.directionID == Int16(directionID)
    }
}


// Working with data
extension AlgorithmViewModel {
    
    func addAlgorithm(to folder: Folder) {
        let algorithm = Algorithm(context: dataManager.container.viewContext)
        algorithm.initValues(folder: folder, states: [], tapes: [])
        addTape(algorithm: algorithm)
        addState(algorithm: algorithm)
        
        folder.addToAlgorithms(algorithm)
        dataManager.applyChanges()
        objectWillChange.send()
    }
    
    func deleteAlgorithm(_ algorithm: Algorithm) {
        algorithm.folder.removeFromAlgorithms(algorithm)
        dataManager.container.viewContext.delete(algorithm)
        dataManager.applyChanges()
        objectWillChange.send()
    }
    
    func addTape(algorithm: Algorithm) {
        if algorithm.wrappedTapes.isEmpty {
            let tape = Tape(context: dataManager.container.viewContext)
            tape.initValues(nameID: 0, components: [], algorithm: algorithm)
            addComponent(tape: tape)
            algorithm.addToTapes(tape)
            
            algorithm.editedDate = Date.now
            dataManager.applyChanges()
            objectWillChange.send()
            return
        }
        // Getting the name
        let nameIDArray = algorithm.wrappedTapes.map { $0.nameID }
        guard let max = nameIDArray.max() else {
            print("Error finding max")
            return
        }
        let fullArray = Array(0...max)
        let arrayOfDifferentElements = fullArray.filter { !nameIDArray.contains($0) }
        
        let tape = Tape(context: dataManager.container.viewContext)
        
        if let firstElement = arrayOfDifferentElements.first {
            // In case there ARE gaps between name ids
            tape.initValues(nameID: Int(firstElement), components: [], algorithm: algorithm)
        } else {
            // In case there ARE NO gaps between name ids
            guard let endElement = algorithm.wrappedTapes.last else {
                print("Error finding end element")
                return
            }
            tape.initValues(nameID: Int(endElement.nameID + 1), components: [], algorithm: algorithm)
        }
        addComponent(tape: tape)
        algorithm.addToTapes(tape)
        updateStates(for: algorithm)
        
        algorithm.editedDate = Date.now
        dataManager.applyChanges()
        objectWillChange.send()
    }
    
    func deleteTape(_ tape: Tape) {
        let algorithm = tape.algorithm
        algorithm.removeFromTapes(tape)
        dataManager.container.viewContext.delete(tape)
        updateStates(for: algorithm)
        dataManager.applyChanges()
        objectWillChange.send()
    }
    
    func addComponent(tape: Tape) {
        for index in -100...100 {
            let component = TapeComponent(context: dataManager.container.viewContext)
            component.initValues(id: index, tape: tape)
            tape.addToComponents(component)
        }
        dataManager.applyChanges()
        objectWillChange.send()
    }
    
    func updateComponents(for tape: Tape) {
        // Update components values according to input
        for component in tape.wrappedComponents {
            if (0..<tape.input.count).contains(Int(component.id)) {
                component.value = tape.input.map { String($0) }[Int(component.id)]
            } else {
                component.value = "_"
            }
        }
        dataManager.applyChanges()
        objectWillChange.send()
    }
    
    func addState(algorithm: Algorithm) {
        if algorithm.wrappedStates.isEmpty {
            let state = StateQ(context: dataManager.container.viewContext)
            state.initValues(
                id: UUID(),
                nameID: 0,
                isStarting: true, isForReset: true,
                options: [], algorithm: algorithm
            )
            let combinations = getPossibleCombinations(for: state)
            addOptions(to: state, combinations: combinations)
            algorithm.addToStates(state)
            
            algorithm.editedDate = Date.now
            dataManager.applyChanges()
            objectWillChange.send()
            return
        }
        
        // Getting the name
        let nameIDArray = algorithm.wrappedStates.map { $0.nameID }
        guard let max = nameIDArray.max() else {
            print("Error finding max")
            return
        }
        let fullArray = Array(0...max)
        let arrayOfDifferentElements = fullArray.filter { !nameIDArray.contains($0) }
        
        let state = StateQ(context: dataManager.container.viewContext)
        
        if let firstElement = arrayOfDifferentElements.first {
            // In case there ARE gaps between name ids
            state.initValues(id: UUID(), nameID: Int(firstElement), options: [], algorithm: algorithm)
        } else {
            // In case there ARE NO gaps between name ids
            guard let endElement = algorithm.wrappedStates.last else {
                print("Error finding end element")
                return
            }
            state.initValues(id: UUID(), nameID: Int(endElement.nameID + 1), options: [], algorithm: algorithm)
        }
        let combinations = getPossibleCombinations(for: state)
        addOptions(to: state, combinations: combinations)
        algorithm.addToStates(state)
        
        algorithm.editedDate = Date.now
        dataManager.applyChanges()
        objectWillChange.send()
    }
    
    func deleteState(_ state: StateQ) {
        if state.isStarting {
            if state.nameID == 0 {
                updateStartState(state: state, id: 1)
            } else {
                updateStartState(state: state, id: 0)
            }
        }
        state.algorithm.removeFromStates(state)
        dataManager.container.viewContext.delete(state)
        dataManager.applyChanges()
        objectWillChange.send()
    }
    
    private func updateStartState(state: StateQ, id: Int) {
        state.isStarting.toggle()
        state.algorithm.wrappedStates.first(where: { $0.nameID == Int16(id) })?.isStarting.toggle()
        
        state.algorithm.editedDate = Date.now
        dataManager.applyChanges()
        objectWillChange.send()
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
    
    func getTapesAlphabets(of algorithm: Algorithm) -> [[String]] {
        var alphabets: [[String]] = []
        for tape in algorithm.wrappedTapes {
            var tapeAlphabet = tape.alphabet.map { String($0) }
            tapeAlphabet.append("_")
            alphabets.append(tapeAlphabet)
        }
        return alphabets
    }
    
    func getPossibleCombinations(for state: StateQ) -> [[String]] {
        let alphabets: [[String]] = getTapesAlphabets(of: state.algorithm)
        var combinations: [[String]] = []
        getCombinations(array: alphabets, word: [], currentArrayIndex: 0, result: &combinations)
        return combinations
    }
}

extension AlgorithmViewModel {
    
    func addOptions(to state: StateQ, combinations: [[String]]) {
        for combinationIndex in 0..<combinations.count {
            let option = Option(context: dataManager.container.viewContext)
            option.initValues(id: combinationIndex, toStateID: state.id!, combinations: [], state: state)
            addCombinations(combinations: combinations[combinationIndex], option: option)
            state.addToOptions(option)
        }
        dataManager.applyChanges()
        objectWillChange.send()
    }
    
    func addCombinations(combinations: [String], option: Option) {
        for combinationIndex in 0..<combinations.count {
            let combination = Combination(context: dataManager.container.viewContext)
            combination.initValues(id: combinationIndex, character: combinations[combinationIndex], directionID: 0, option: option)
            option.addToCombinations(combination)
        }
        dataManager.applyChanges()
        objectWillChange.send()
    }
    
    func getSearchResult(_ searchText: String, sorting: Sortings, sortingOrder: SortingOrder, folder: Folder) -> [Algorithm] {
        let filteredAlgorithms = getSearchedAlgorithms(searchText, folder: folder)
        switch sorting {
        case .name:
            return filteredAlgorithms
                .sorted { lhs, rhs in
                    if lhs.name == rhs.name {
                        return sortingOrder == .down ? lhs.wrappedEditedDate < rhs.wrappedEditedDate : lhs.wrappedEditedDate > rhs.wrappedEditedDate
                    }
                    return sortingOrder == .down ? lhs.name < rhs.name : lhs.name > rhs.name
                }
        case .dateCreated:
            return filteredAlgorithms.sorted(by: {
                sortingOrder == .down
                ? $0.wrappedCreationDate < $1.wrappedCreationDate
                : $0.wrappedCreationDate > $1.wrappedCreationDate
            })
        case .dateEdited:
            return filteredAlgorithms.sorted(by: {
                sortingOrder == .down
                ? $0.wrappedEditedDate < $1.wrappedEditedDate
                : $0.wrappedEditedDate > $1.wrappedEditedDate
            })
        }
    }
    
    private func getSearchedAlgorithms(_ searchText: String, folder: Folder) -> [Algorithm] {
        searchText.isEmpty
        ? folder.wrappedAlgorithms
        : folder.wrappedAlgorithms.filter { $0.name.contains(searchText) }
    }
    
    func getAlgorithmEditedTimeForTextView(_ algorithm: Algorithm) -> String {
        if Calendar.current.isDateInYesterday(algorithm.wrappedEditedDate) {
            return "Yesterday"
        }
        
        let formatter = DateFormatter()
        if Calendar.current.isDateInToday(algorithm.wrappedEditedDate) {
            formatter.dateFormat = "HH:mm"
            return formatter.string(from: algorithm.wrappedEditedDate)
        }
        formatter.dateFormat = "d MMM y"
        return formatter.string(from: algorithm.wrappedEditedDate)
    }
}
