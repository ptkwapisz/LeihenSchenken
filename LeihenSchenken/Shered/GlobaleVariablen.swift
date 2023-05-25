
//  GlobaleVariablen.swift
//  LeihenSchenken
//
//  Created by PIOTR KWAPISZ on 27.03.23.
//

import Foundation
import SwiftUI

class GlobaleVariable: ObservableObject {
    static let shared = GlobaleVariable()
    
    @Published var parameterPersonSex: [String] =  ["Frau", "Mann", "Divers"]
    @Published var parameterVorgang: [String] =  ["Verleihen", "Verschenken"]
    @Published var parameterGegenstand: [String] = querySQLAbfrageArray(queryTmp: "select gegenstandName FROM Gegenstaende")
    
    
    @Published var abfrageFilter: Bool = false
    @Published var abfrageQueryString: String = ""
    
    @Published var parameterDatum: Date = Date()
    @Published var parameterImageString: String = "Kein Bild"
    
    @Published var parameterPerson: [String] = personenArray()
    
    @Published var navigationTabView = 1
    @Published var farbenEbene0: Color = loadColor0A()
    @Published var farbenEbene1: Color = loadColor1B()
    
    @Published var heightFaktorEbene0: Double = 0.99
    
    @Published var heightFaktorEbene1: Double = 0.97
    @Published var widthFaktorEbene1: Double = 0.97
    
    @Published var refreshViews: Bool = false
    
    @Published var selectedGegenstand: String = "Neuer Gegenstand"
    @Published var selectedGegenstandInt: Int = 0
    @Published var textGegenstandbeschreibung: String = ""
    @Published var selectedVorgangInt: Int = 0
    @Published var selectedPersonInt: Int = 0
    @Published var selectedPersonVariable: [PersonVariable] = [PersonVariable(personVorname: "", personNachname: "", personSex: "")]
    
    
    @Published var preisWert: String = ""
    @Published var textAllgemeineNotizen: String = ""
    @Published var datum: Date = Date()
    
    
} // ende class

class UserSettingsDefaults: ObservableObject {
    static let shared = UserSettingsDefaults()
    
    @Published var selectedSprache: Int {
        didSet {
            UserDefaults.standard.set(selectedSprache, forKey: "selectedSprache")
        } // Ende didSet
    } // Ende @Published
    
    @Published var showHandbuch: Bool {
        didSet {
            UserDefaults.standard.set(showHandbuch, forKey: "showHandbuch")
        } // Ende didSet
    } // Ende @Published
    
    
    @Published var selectedFilterField1: String {
        didSet {
            UserDefaults.standard.set(selectedFilterField1, forKey: "selectedFilterField1")
        } // Ende didSet
    } // Ende @Published
    
    
    @Published var selectedFilterField2: String {
        didSet {
            UserDefaults.standard.set(selectedFilterField2, forKey: "selectedFilterField2")
        } // Ende didSet
    } // Ende @Published
    
    @Published var selectedFilterField3: String {
        didSet {
            UserDefaults.standard.set(selectedFilterField3, forKey: "selectedFilterField3")
        } // Ende didSet
    } // Ende @Published
    
    
    init() {
        
        self.selectedSprache = UserDefaults.standard.object(forKey: "selectedSprache") as? Int ?? 0
        self.showHandbuch = UserDefaults.standard.object(forKey: "showHandbuch") as? Bool ?? true
        self.selectedFilterField1 = UserDefaults.standard.object(forKey: "selectedFilterField1") as? String ?? "Gegenstand"
        self.selectedFilterField2 = UserDefaults.standard.object(forKey: "selectedFilterField2") as? String ?? "gleich"
        self.selectedFilterField3 = UserDefaults.standard.object(forKey: "selectedFilterField3") as? String ?? "Buch"
        
    } // Ende init
} // Ende class

class ObjectVariable: Identifiable {
    //static let shared = UserSettingsDefaults()
    
    @Published var perKey: String
    @Published var gegenstand: String
    @Published var gegenstandText: String
    @Published var gegenstandBild: String
    @Published var preisWert: String
    @Published var datum: String
    @Published var vorgang: String
    @Published var personVorname: String
    @Published var personNachname: String
    @Published var personSex: String
    @Published var allgemeinerText: String

    init(perKey: String, gegenstand: String, gegenstandTex: String, gegenstandBild: String, preisWert: String, datum: String, vorgang: String, personVorname: String, personNachname: String, personSex: String, allgemeinerText: String) {
        
        self.perKey = perKey
        self.gegenstand = gegenstand
        self.gegenstandText = gegenstandTex
        self.gegenstandBild = gegenstandBild
        self.preisWert = preisWert
        self.datum = datum
        self.vorgang = vorgang
        self.personVorname = personVorname
        self.personNachname = personNachname
        self.personSex = personSex
        self.allgemeinerText = allgemeinerText
        
    } // Ende init

} // Ende class

class GegenstandVariable: Identifiable {
    
      @Published var perKey: String
      @Published var gegenstandName: String
    
    init(perKey: String, gegenstandName: String) {
        
        self.perKey = perKey
        self.gegenstandName = gegenstandName
        
    } // Ende init
    
} // Ende class



class PersonVariable: Identifiable {
    
    @Published var personVorname: String
    @Published var personNachname: String
    @Published var personSex: String
    
    init(personVorname: String, personNachname: String, personSex: String) {
        
        self.personVorname = personVorname
        self.personNachname = personNachname
        self.personSex = personSex
        
    } // Ende init
    
} // Ende class

class PersonClassVariable: Identifiable {
    
    @Published var perKey: String
    @Published var personPicker: String
    @Published var personVorname: String
    @Published var personNachname: String
    @Published var personSex: String
    
    init(perKey: String, personPicker: String, personVorname: String, personNachname: String, personSex: String) {
        
        self.perKey = perKey
        self.personPicker = personPicker
        self.personVorname = personVorname
        self.personNachname = personNachname
        self.personSex = personSex
        
    } // Ende init
    
} // Ende class
