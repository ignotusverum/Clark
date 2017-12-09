//
//  AutocompleteView.swift
//  Clark
//
//  Created by Vladislav Zagorodnyuk on 7/31/17.
//  Copyright © 2017 Clark. All rights reserved.
//

import CoreStore
import Foundation

// Used for passing info to and from autocomplete cells
public struct AutoCompleteString {
    var body: String
    var suffix: String?
    var entitySuffix: Bool?
    
    init(body: String, suffix: String? = nil, entitySuffix: Bool? = nil) {
        self.body = body
        self.suffix = suffix
        self.entitySuffix = entitySuffix
    }
    
    init(autoComplete: AutoCompleteModel) {
        self.body = autoComplete.body
        if let firstChild = autoComplete.childSwitches?.first {
            switch firstChild.type {
            case .entity(_):
                self.suffix = " " + firstChild.body
                if firstChild.childSwitches != nil {
                    self.suffix = " " + firstChild.body + "..."
                } else {
                    self.suffix = " " + firstChild.body
                }
                self.entitySuffix = true
            case .text, .values(_):
                self.suffix = "..."
                self.entitySuffix = false
            }
        }
    }
}

protocol AutocompleteViewDelegate {
    /// Called when text is valid
    func autocomplete(valid: Bool, newString: String, intent: String?)
    
    /// Called when should animate presentation
    func stateChanged(shouldShow: Bool)
}

enum AutocompleteViewState {
    case dataReady
    case empty
}

class AutocompleteView: UIView {
    
    /// Delegate
    var delegate: AutocompleteViewDelegate?
    
    /// Is presented
    var isPresented: Bool = false
    
    var state: AutocompleteViewState {
        return currentAutoCompleteData == nil ? .empty : .dataReady
    }
    
    /// Datasource
    fileprivate var currentToolbarText = ""
    fileprivate var currentConfirmedString: String?
    fileprivate var currentPath: [AutoCompleteModel]?
    fileprivate var currentAutoCompleteData: AutoCompleteDataType?
    
    /// Collection view
    lazy var collectionView: UICollectionView = {
       
        /// Layout
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        
        /// Collection node
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        /// Node setup
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        
        collectionView.backgroundColor = UIColor.white
        collectionView.alwaysBounceVertical = true
        
        /// Register items
        collectionView.register(AutocompleteCollectionViewCell.self, forCellWithReuseIdentifier: "\(AutocompleteCollectionViewCell.self)")
        
        return collectionView
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        /// Collection view
        addSubview(collectionView)
        collectionView.delegate = self
        collectionView.dataSource = self
        
        /// Collection view layout
        collectionView.snp.updateConstraints { maker in
            maker.left.equalTo(self)
            maker.right.equalTo(self)
            maker.top.equalTo(self)
            maker.bottom.equalTo(self)
        }
    }
    
    // MARK: - Autocomplete data methods
    fileprivate enum AutoCompleteDataType {
        case text([AutoCompleteString])         // FOR TEXT AND VALUE MODELS: This is a list of all strings to display in the autocomplete view. ****If the end of the path is an entity model, ignore this field****
        case entity([AutocompleteCategory])    // ONLY FOR ENTITY MODELS: list of all valid entities based on the current text. ****If the end of the path is a text or value model, ignore this field****
    }
    
    // Returns all data necessary to set up the UI for autocomplete
    // Valid = if the current text is a valid autocomplete path at all
    // Complete = if the current text exactly matches an autocomplete option, no extra characters
    // Path = the path from the root autocomplete model to the furthest down the line. The last model on this path is important in that it's children are shown as the next suggestions in the autocomplete view and its "valid_end_of_command" value determines if the keyboard is enabled.
    // Confirmed string = The portion of the textfield string that has been confirmed to fully match autocomplete values
    // Data to show: this is how data will be returned based on the current text string in the toolbar. This is what is to be shown in the autocomplete list.
    private func relevantAutocompleteData(for text: String) -> (valid: Bool, complete: Bool, path: [AutoCompleteModel], confirmedString: String?, dataToShow: AutoCompleteDataType?) {
        let words = text.trimmingCharacters(in: .whitespacesAndNewlines).components(separatedBy: " ")
        guard let firstWord = words.first?.lowercased() else {
            return (false, false, [], nil, nil)
        }
        
        let config = Config.shared
        let roots = config.autocompleteData.filter { $0.body.lowercased().hasPrefix(firstWord) }
        
        guard roots.count > 0 else { return (false, false, [], nil, nil) }

        return findFinalModel(for: nil, currentChildren: roots, confirmedPath: "", remainingText: text.lowercased())
    }
    
    // looping function that iterates on the original text handed in. Will move up the chain of text, making sure each part of the string is still a valid autocomplete value. Once it runs into an invalid string, it will return valid=false and nil info. Once it runs through all the text without hitting an invalid string, it will return valid=true and all relevant data.
    private func findFinalModel(for path:[AutoCompleteModel]?, currentChildren:[AutoCompleteModel]? = nil, confirmedPath:String, remainingText:String) -> (valid:Bool, complete:Bool, path:[AutoCompleteModel], confirmedString:String?, dataToShow:AutoCompleteDataType?) {
        var currentPath:[AutoCompleteModel] = []
        if let path = path { currentPath = path }
        var children:[AutoCompleteModel]!
        if let pathChildren = currentPath.last?.childSwitches {
            children = pathChildren
        } else if let currentChildren = currentChildren {
            children = currentChildren
        } else {
            return (false, false, [], nil, nil)
        }
        
        var validStrings:[AutoCompleteString] = []
        var validEntities:[AutocompleteCategory] = []
        var nextChildFound:AutoCompleteModel?
        for child in children {
            switch child.type {
            case .text:
                if remainingText.hasPrefix(child.body.lowercased()) {
                    // Good, this option will only happen if the toolbar text exactly matches a child. This option is the only valid option, just need to remove the fullText and continue parsing the rest of the string
                    validStrings.append(AutoCompleteString(autoComplete: child))
                    nextChildFound = child
                    break
                } else if child.body.lowercased().hasPrefix(remainingText) {
                    // Good, this means this child's body hasn't been completely filled out but has been started.
                    validStrings.append(AutoCompleteString(autoComplete: child))
                } else {
                    // Bad, this string is not valid with this child
                }
            case .values(let values):
                var suffix:String?
                if let count = child.childSwitches?.count, count > 0 {
                    suffix = "..."
                }
                for value in values {
                    if remainingText.hasPrefix(value.lowercased()) {
                        // Good, this option will only happen if the toolbar text exactly matches a value. This option is the only valid option, just need to remove the fullText and continue parsing the rest of the string
                        validStrings.append(AutoCompleteString(body:value, suffix: suffix))
                        nextChildFound = child
                        break
                    } else if value.lowercased().hasPrefix(remainingText) {
                        // Good, this means this value hasn't been completely filled out but has been started.
                        validStrings.append(AutoCompleteString(body:value, suffix: suffix))
                    } else {
                        // Bad, this string is not valid with this value
                    }
                }
            case .entity(let category):
                // ANYTIME an entity child is found it should be the ONLY child of its parent. This is the end of the loop. Search through all entities: if a valid one is found, continue, if not end with invalid
                let containedIn = category.valuesContainingIn(searchString: remainingText)
                let contains = category.valuesContaining(searchString: remainingText)
                if containedIn.count > 1 {
                    // Good, this option will only happen if the toolbar text exactly matches a child. This option is the only valid option, just need to remove the fullText and continue parsing the rest of the string
                    validEntities = containedIn
                    nextChildFound = child
                } else if contains.count > 0 {
                    // Good, this means this child's body hasn't been completely filled out but has been started. Since no more text is valid to search through, this is the final point of this function
                    validEntities = contains
                } else {
                    // Bad, this string is not valid. Since this is the only child (entity switches have no siblings) this entire string is now invalid.
                    return (false, false, [], nil, nil)
                }
                break  // Nothing else to loop through
            }
        }
        if let nextChild = nextChildFound {
            var childText:String
            if let string = validStrings.first {
                childText = string.body
            } else if let entity = validEntities.first {
                childText = entity.body
            } else {
                fatalError("Either an entity or string will be set up by this point")
            }
            let remaining = remainingStringAfterRemovingText(childText, originalString: remainingText)
            var newPath = currentPath
            newPath.append(nextChild)
            let newConfirmed = confirmedPath.characters.count > 0 ? confirmedPath + " " + childText:childText.capitalizedFirst()  // If confirmed path hasn't been started, dont add a space, just set the child text to the variable
            if remaining.characters.count == 0 {
                // This is the final confirmed value, return this path and value
                delegate?.autocomplete(valid: false, newString: newConfirmed, intent: nextChild.intent)  // Always set to false, once the string is updated in the toolbar it will call the "configureForToolbarText" method which will determine if the string is actually valid
                return (true, true, newPath, newConfirmed, returnData(for: nextChild.childSwitches))
            } else {
                return findFinalModel(for: newPath, confirmedPath:newConfirmed, remainingText: remaining)
            }
        } else if validStrings.count > 0 {
            // No need to move down the path any further, these are all the valid children to be shown.
            if confirmedPath.characters.count == 0 {
                var capitalized:[AutoCompleteString] = []
                for string in validStrings {
                    let updatedString = AutoCompleteString(body: string.body.capitalizedFirst(),
                                                           suffix: string.suffix,
                                                           entitySuffix: string.entitySuffix)
                    capitalized.append(updatedString)
                }
                validStrings = capitalized
            }
            return (true, false, currentPath, confirmedPath, .text(validStrings))
        } else if validEntities.count > 0 {
            // No need to move down the path any further, these are all the valid entities to be shown.
            return (true, false, currentPath, confirmedPath, .entity(validEntities))
        } else {
            // Invalid
            return (false, false, [], nil, nil)
        }
    }
    
    // Called when a new word has been completed. This is used to parse the raw child objects of a new AutoCompleteModel and convert the data into a valid displayable data list.
    private func returnData(for models: [AutoCompleteModel]?) -> AutoCompleteDataType? {
        guard let models = models else {return nil}
        
        var strings:[AutoCompleteString] = []
        for model in models {
            switch model.type {
            case .text:
                strings.append(AutoCompleteString(autoComplete: model))
            case .values(let values):
                var suffix:String?
                if let count = model.childSwitches?.count, count > 0 {
                    suffix = "..."
                }
                let valuesArray = values.map({AutoCompleteString(body: $0, suffix: suffix)})
                strings += valuesArray
            case .entity(let objectType):
                // ONLY ONE child will exist so just return here. If other children exist, default to entity type anyway.
                let allData = objectType.valuesContaining(searchString: "")  // fetch ALL values
                // **** IMPORTANT **** Make sure this is only called when we want to show the values for all entities in this class
                return AutoCompleteDataType.entity(allData)
            }
        }
        if strings.count > 0 {
            return AutoCompleteDataType.text(strings)
        }
        return nil
    }
    
    // This function takes out ONLY the first instance of a substring and returns the remaining text
    func remainingStringAfterRemovingText(_ text:String, originalString:String) -> String {
        
        var newString = originalString
        if let firstRange = originalString.lowercased().rangesOfString(s: text.lowercased()).first {  // only grab the first range
            newString = originalString.replacingCharacters(in: firstRange, with: "")
        }
        return newString.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    func updateWith(text: String) {
        
        guard currentToolbarText != text else {
            return
        }
        
        currentToolbarText = text
        
        if text.characters.count >= 3 {
            let autoCompleteData = relevantAutocompleteData(for: text)
            if autoCompleteData.valid, autoCompleteData.dataToShow != nil {
                
                /// Show view
                delegate?.stateChanged(shouldShow: true)
                
                /// Udpate models
                currentPath = autoCompleteData.path
                currentAutoCompleteData = autoCompleteData.dataToShow
                currentConfirmedString = autoCompleteData.confirmedString
            }
            else {
                /// Hide view
                resetAutoComplete()
                delegate?.stateChanged(shouldShow: false)
            }
            
            /// Fully completed
            if autoCompleteData.complete, let validEnd = autoCompleteData.path.last?.validEnd, let updateText = autoCompleteData.confirmedString, validEnd {
                delegate?.autocomplete(valid: true, newString: updateText, intent: autoCompleteData.path.last?.intent)
            }
        }
        else {
            resetAutoComplete()
            /// Hide view
            delegate?.stateChanged(shouldShow: false)
        }

        /// Reload
        collectionView.reloadData()
    }
    
    private func resetAutoComplete() {
        // Reset the toolbar to how it would be without autocomplete.
        currentAutoCompleteData = nil
        currentConfirmedString = nil
        currentPath = nil
    }
}

// MARK: - CollectionView Delegate
extension AutocompleteView: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        var finalString:String
        guard let autoCompleteData = currentAutoCompleteData else {return}
        var confirm:String = ""
        if let currentConfirmed = currentConfirmedString, currentConfirmed.characters.count > 0 {
            confirm = currentConfirmed + " "
        }
        switch autoCompleteData {
        case .text(let strings):
            let string = strings[indexPath.row]
            finalString = confirm + string.body
        case .entity(let objects):
            if objects.count == 0 {
                // This is the rare empty state, dont send back any info
                return
            } else {
                let object = objects[indexPath.row]
                finalString = confirm + object.body
            }
        }
        
        /// Update data
        delegate?.autocomplete(valid: false, newString: finalString, intent: currentPath?.last?.intent)
    }
}

// MARK: - CollectionView Datasource
extension AutocompleteView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath)-> CGSize {
        return CGSize(width: collectionView.frame.width, height: 40)
    }
}

// MARK: - CollectionView Datasource
extension AutocompleteView: UICollectionViewDataSource {
    
    /// Number of sections
    func numberOfSections(in collectionView: UICollectionView)-> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int)-> Int {
        
        guard let autoCompleteData = currentAutoCompleteData else {return 0}
        switch autoCompleteData {
        case .text(let strings):
            return strings.count
        case .entity(let objects):
            return max(1, objects.count)  // include "Please add <object>" cell if none exist
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath)-> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "\(AutocompleteCollectionViewCell.self)", for: indexPath) as! AutocompleteCollectionViewCell
        
        guard let autocompleteDate = currentAutoCompleteData else {
            return cell
        }
        
        var extra:String?  // Find all text that's extra beyond the current confirmed valid string
        if let confirm = currentConfirmedString?.trimmingCharacters(in: .whitespacesAndNewlines).lowercased() {
            extra = remainingStringAfterRemovingText(confirm, originalString: currentToolbarText)
        } else {
            extra = currentToolbarText.lowercased()
        }
        
        switch autocompleteDate {
        case .text(let strings):
            let string = strings[indexPath.row]
            cell.configure(for: string, confirmedString: currentConfirmedString, extraString: extra)
        case .entity(let objects):
            if objects.count == 0 {
                if let currentAutoCompleteModel = currentPath?.last?.childSwitches?.first {
                    let pleaseAddString = "Add more " + currentAutoCompleteModel.body.lowercased() + "s to continue"
                    cell.configure(for: AutoCompleteString(body: pleaseAddString), confirmedString: nil, extraString: nil)
                } else {
                    cell.configure(for: AutoCompleteString(body: "No matching values"), confirmedString: nil, extraString: nil)
                }
            }
            else {
                let object = objects[indexPath.row]
                cell.configure(for: object, extraString: extra)
            }
        }
     
        return cell
    }
}
