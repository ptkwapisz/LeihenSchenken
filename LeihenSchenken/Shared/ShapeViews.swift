//
//  ShapeViews.swift
//  LeihenSchenken
//
//  Created by PIOTR KWAPISZ on 27.03.23.
//

import Foundation
import SwiftUI

struct ShapeViewAddUser: View {
    @ObservedObject var globaleVariable = GlobaleVariable.shared
    @Binding var isPresented: Bool
    @Binding var isParameterBereich: Bool
    
    @State var showHilfe: Bool = false
    @State var showWarnung: Bool = false
    
    @State var selectedPerson_sexInt: Int = 0
    
    @State var vorname: String = ""
    @State var name: String = ""
    //@State var spitzname: String = ""
    
    var body: some View {
        NavigationView {
            Form {
                Section() {
                    
                    TextField("Vorname", text: $vorname)
                        .padding(5)
                        .background(Color(.systemGray6))
                        .cornerRadius(5)
                        .disableAutocorrection(true)
                    
                    TextField("Name", text: $name)
                        .padding(5)
                        .background(Color(.systemGray6))
                        .cornerRadius(5)
                        .disableAutocorrection(true)
                    
                    Picker("Geschlecht:", selection: $selectedPerson_sexInt) {
                        
                        ForEach(0..<globaleVariable.parameterPersonSex.count, id: \.self) { index in
                            Text("\(globaleVariable.parameterPersonSex[index])")
                            
                        } // Ende ForEach
                    } // Ende Picker
                } // Ende Section
                
                HStack {
                    Spacer()
                    Button(action: { isPresented = false }) {Text("Abbrechen")}
                        .buttonStyle(.bordered).foregroundColor(.blue).font(.system(size: 16, weight: .regular))
                    
                    Button(action: {
                        if vorname != "" && name != "" {
                            if isParameterBereich {
                                //let tempPerson = name + ", " + vorname
                                //globaleVariable.parameterPerson.append(tempPerson)
                                personenDatenInVariableSchreiben(par1: vorname, par2: name, par3: globaleVariable.parameterPersonSex[selectedPerson_sexInt])
                                // Es wird in der Eingabemaske bei Personen die neue Person ausgewählt
                                //globaleVariable.selectedPersonInt = globaleVariable.parameterPerson.count-1
                                globaleVariable.selectedPersonInt = globaleVariable.personenParameter.count-1
                                print("Person wird in die Auswahl hinzugefügt!")
                                isPresented = false
                            }else{
                                
                                if pruefenDieElementeDerDatenbank(parPerson: ["\(vorname)","\(name)","\(globaleVariable.parameterPersonSex[selectedPerson_sexInt])"], parGegenstand: "") {
                                    
                                    showWarnung = true
                                    
                                }else{
                                    
                                    personenDatenInDatenbankSchreiben(par1: vorname, par2: name, par3: globaleVariable.parameterPersonSex[selectedPerson_sexInt])
                                    //globaleVariable.parameterPerson.removeAll()
                                    //globaleVariable.parameterPerson = personenArray()
                                    globaleVariable.personenParameter.removeAll()
                                    globaleVariable.personenParameter = querySQLAbfrageClassPersonen(queryTmp: "Select * From Personen")
                                    
                                    
                                    print("Person wurde in die Datenbank hinzugefügt!")
                                    isPresented = false
                                    
                                } // Ende if/else
                                
                            }// Ende if/else
                            
                        } // Ende if/else
                        
                    }) {
                        
                        Text("Speichern")
                        
                    } // Ende Button
                    .buttonStyle(.borderedProminent)
                    .foregroundColor(.white)
                    .font(.system(size: 16, weight: .regular))
                    .cornerRadius(10)
                    Spacer()
                } // Ende HStack
                
                .alert("Warnung zu neuer Person", isPresented: $showWarnung, actions: {
                    Button(" - OK - ") {}
                }, message: { Text("Die Person: '\(vorname)' '\(name)' befindet sich schon in der Datenbank. In der Datenbank können keine Duplikate von Personen gespeichert werden!") } // Ende message
                ) // Ende alert
                
                if isParameterBereich {
                    
                    Text("Mit drücken von 'Speichern' werden die Personendaten nur zur Auswahl in der Eingabemaske hinzugefügt. Sie werden nach beenden des Programms gelöscht. Möchten Sie eine Person dauerhaft zur Auswahl in der Eingabemaske speichern, gehen Sie bitte zum Tab 'Personen', dort auf '+' drücken und geben Sie auf der entsprechenden Persondaten ein.")
                        .font(.system(size: 14, weight: .regular))
                        .foregroundColor(.gray)
                }else{
                    Text("Bei drücken auf 'Speichern' werden alle Daten in die Datenbank dauerhaft hinzugefügt.")
                        .font(.system(size: 14, weight: .regular))
                        .foregroundColor(.gray)
                    
                } // Ende if/else
                
            } // Ende Form
            .navigationTitle("Neuer Benutzer").navigationBarTitleDisplayMode(.inline)
            
        } // Ende NavigationView
    } // Ende var body
} // Ende struct

struct ShapeViewAddGegenstand: View {
    @ObservedObject var globaleVariable = GlobaleVariable.shared
    
    @Binding var isPresented: Bool
    @Binding var isParameterBereich: Bool
    
    @State var showHilfe: Bool = false
    @State var showWarnung: Bool = false
    
    @State var gegenstandNeu: String = ""
    
    @FocusState var isInputActive: Bool
    
    var body: some View {
        
        NavigationView {
            
            Form {
                Section(){
                    TextField("Gegenstand", text: $gegenstandNeu.max(20))
                        .focused($isInputActive)
                        .padding(5)
                        .background(Color(.systemGray6))
                        .submitLabel(.done)
                        .cornerRadius(5)
                        .disableAutocorrection(true)
                    
                } // Ende Section
                .toolbar {ToolbarItemGroup(placement: .keyboard) {
                    HStack {
                        Text("\(gegenstandNeu.count)/20")
                            .font(.system(size: 16, weight: .regular))
                            .foregroundColor(.gray)
                            .padding()
                        Spacer()
                        
                        Button("Abbrechen") {
                            isInputActive = false
                            gegenstandNeu = ""
                        } // Ende Button
                    } // Ende HStack
                    
                }// Ende ToolbarItemGroup
                } // Ende Toolbar
                
                HStack {
                    Spacer()
                    Button(action: { isPresented = false }) {Text("Abbrechen")}
                        .buttonStyle(.bordered).foregroundColor(.blue).font(.system(size: 16, weight: .regular))
                    
                    Button(action: {
                        if gegenstandNeu != "" {
                            if isParameterBereich {
                                globaleVariable.parameterGegenstand.append(gegenstandNeu)
                                // Es wird in der Eingabemaske bei Gegenstand der neue Gegenstand ausgewählt
                                globaleVariable.selectedGegenstandInt = globaleVariable.parameterGegenstand.count-1
                                isPresented = false
                                print("Gegenstand wurde in die Auswahl hinzugefügt!")
                            }else{
                                if pruefenDieElementeDerDatenbank(parPerson: ["","",""], parGegenstand: gegenstandNeu) {
                                    
                                    showWarnung = true
                                    
                                }else{
                                    
                                    gegenstandInDatenbankSchreiben(par1: gegenstandNeu)
                                    globaleVariable.parameterGegenstand.removeAll()
                                    globaleVariable.parameterGegenstand = querySQLAbfrageArray(queryTmp: "Select gegenstandName FROM Gegenstaende")
                                    
                                    print("Gegenstand wurde in die Datenbank hinzugefügt!")
                                    
                                    isPresented = false
                                } // Ende guard/else
                                
                            } // Ende if/else
                            
                        } // Ende if
                    }) {
                        
                        Text("Speichern")
                        
                    }// Ende Button
                    .buttonStyle(.borderedProminent)
                    .foregroundColor(.white)
                    .font(.system(size: 16, weight: .regular))
                    .cornerRadius(10)
                    
                    Spacer()
                    
                } // Ende Hstack
                .alert("Warnung zu neuem Gegenstand", isPresented: $showWarnung, actions: {
                    Button(" - OK - ") {}
                }, message: { Text("Der Gegenstand: '\(gegenstandNeu)' befindet sich schon in der Datenbank. In der Datenbank können keine Duplikate von Gegenständen gespeichert werden!") } // Ende message
                ) // Ende alert
                
                if isParameterBereich {
                    Text("Beim Drücken auf 'Speichern' wird der neue Gegenstand nur in die Auswahl hinzugefügt.")
                        .font(.system(size: 14, weight: .regular))
                        .foregroundColor(.gray)
                }else{
                    Text("Beim Drücken auf 'Speichern' wird der neue Gegenstand dauerhaft in die Datenbank hinzugefügt.")
                        .font(.system(size: 14, weight: .regular))
                        .foregroundColor(.gray)
                    
                } // Ende if/else
                
            } // Ende Form
            .navigationTitle("Neuer Gegenstand").navigationBarTitleDisplayMode(.inline)
            .scrollContentBackground(.hidden)
            
        } // Ende NavigationView
        
    } // Ende var body
} // Ende struct


struct ShapeViewSettings: View {
    //@Environment(\.presentationMode) var presentationMode
    @Binding var isPresented: Bool
    
    @ObservedObject var globaleVariable = GlobaleVariable.shared
    @ObservedObject var userSettingsDefaults = UserSettingsDefaults.shared
    
    @State var showSettingsHilfe: Bool = false
    
    @State var colorData = ColorData()
    
    
    var body: some View {
        
        
        NavigationView {
            
            Form {
                
                Section(header: Text("Farbeinstellung")) {
                    ColorPicker("Farben für Ebene 0", selection:  $globaleVariable.farbenEbene0, supportsOpacity: false)
                        .onAppear ( perform: {globaleVariable.farbenEbene0 = colorData.loadColor0()})
                        .frame(width: 300, height: 40)
                    
                    ColorPicker("Farben für Ebene 1", selection: $globaleVariable.farbenEbene1, supportsOpacity: false)
                        .onAppear ( perform: {globaleVariable.farbenEbene1 = colorData.loadColor1()})
                        .frame(width: 300, height: 40)
                    
                }// Ende Section Farben
                Section {
                    Toggle("Tab Handbuch anzeigen", isOn: $userSettingsDefaults.showHandbuch ).toggleStyle(SwitchToggleStyle(tint: .blue))
                }
            
                HStack {
                    Spacer()
                    
                    Button(action: {
                        
                        colorData.saveColor(color0: globaleVariable.farbenEbene0, color1: globaleVariable.farbenEbene1)
                        //presentationMode.wrappedValue.dismiss()
                        isPresented = false
                    })
                    { Text("Parameterfenster verlassen.")
                        
                    } // Ende Button Text
                    .buttonStyle(.borderedProminent)
                    .foregroundColor(.white)
                    .font(.system(size: 16, weight: .regular))
                        
                    Spacer()
                } // Ende HStack
                
                Text("Beim Drücken auf 'Parameterfenster verlassen' wird das Parameterfenster geschloßen und die einzehlen Parameter werden gespeichert.")
                    .font(.system(size: 14, weight: .regular))
                    .foregroundColor(.gray)
                
            } // Ende Form
            .navigationTitle("Applikations-Parameter").navigationBarTitleDisplayMode(.inline)
            /*
            .navigationBarItems(trailing: Button( action: {
                showSettingsHilfe = true
            }) {Image(systemName: "questionmark.circle.fill").imageScale(.large)} )
            .alert("Hilfe zu Settings", isPresented: $showSettingsHilfe, actions: {
                Button(" - OK - ") {}
            }, message: { Text("Das ist die Beschreibung für den Bereich Settings.") } // Ende message
            ) // Ende alert
            */
            
        } // Ende NavigationView
    } // Ende var body
} // Ende struct ShapeViewSettings


struct ShapeViewAbfrage: View {
    @ObservedObject var globaleVariable = GlobaleVariable.shared
    @ObservedObject var userSettingsDefaults = UserSettingsDefaults.shared
    
    @Binding var isPresented: Bool
    
    @State var showAbfrageHilfe: Bool = false
    @State var showAlertAbbrechenButton: Bool = false
    @State var showAlertSpeichernButton: Bool = false
    
    @State var abfrageFeld1: [String] = ["Gegenstand", "Vorgang","Name", "Vorname"]
    @State var selectedAbfrageFeld1 = "Gegenstand"
    @State var abfrageFeld2: [String] = ["gleich", "ungleich"]
    @State var selectedAbfrageFeld2 = "gleich"
    @State var abfrageFeld3: [String] = querySQLAbfrageArray(queryTmp: "SELECT DISTINCT Gegenstand FROM Objekte ORDER BY Gegenstand")
    @State var selectedAbfrageFeld3 = querySQLAbfrageArray(queryTmp: "SELECT DISTINCT Gegenstand FROM Objekte ORDER BY Gegenstand")[0]
    
    var body: some View {
        
        VStack {
            //Text("")
            //Text("Abfragefilter").bold()
            NavigationView {
                Form {
                    Section(header: Text("Bedingung").font(.system(size: 16, weight: .regular))) {
                        Picker("Wenn ", selection: $selectedAbfrageFeld1, content: {
                            ForEach(abfrageFeld1, id: \.self, content: { index1 in
                                Text(index1)
                            })
                        })
                        .font(.system(size: 16, weight: .regular))
                        .frame(height: 30)
                        .onAppear(perform: {
                            
                            abfrageFeld3 = abfrageField3(field1: selectedAbfrageFeld1)
                            print("Feld1 onAppear")
                        })
                        .onChange(of: selectedAbfrageFeld1, perform: { _ in
                            
                            abfrageFeld3 = abfrageField3(field1: selectedAbfrageFeld1)
                            selectedAbfrageFeld3 = abfrageFeld3[0]
                            print("Feld1 onChange")
                        }) // Ende onChange...
                        
                        HStack{
                            Text("ist  ")
                                .font(.system(size: 16, weight: .regular))
                            
                            Picker("", selection: $selectedAbfrageFeld2, content: {
                                ForEach(abfrageFeld2, id: \.self, content: { index2 in
                                    Text(index2)
                                })
                            })
                            //.pickerStyle(.inline)
                            .frame(height: 30)
                            .font(.system(size: 16, weight: .regular))
                        } // Ende HStack
                        
                        Picker("", selection: $selectedAbfrageFeld3, content: {
                            ForEach(abfrageFeld3, id: \.self, content: { index3 in
                                Text(index3)
                            })
                            .font(.system(size: 16, weight: .regular))
                        })
                        .frame(height: 30)
                        .onAppear(perform: {
                            print("\(selectedAbfrageFeld3)")
                            print("Feld3 onAppear")
                        })
                        .onChange(of: selectedAbfrageFeld3, perform: {  _ in
                            print("\(selectedAbfrageFeld3)")
                            print("Feld3 onChange")
                        })
                    } // Ende Section
                    
                    Section(header: Text("Filteraktivierung").font(.system(size: 16, weight: .regular))) {
                        Toggle("Filterschalter:", isOn: $globaleVariable.abfrageFilter ).toggleStyle(SwitchToggleStyle(tint: .blue))
                            .font(.system(size: 16, weight: .regular))
                    } // Ende Section
                    
                    HStack {
                        Spacer()
                        
                        Button {
                            var tmpFeld1 = ""
                            if globaleVariable.abfrageFilter == true {
                                
                                switch selectedAbfrageFeld1 {
                                        
                                    case "Gegenstand":
                                        tmpFeld1 = selectedAbfrageFeld1
                                    case "Vorgang":
                                        tmpFeld1 = selectedAbfrageFeld1
                                    case "Name":
                                        tmpFeld1 = "personNachname"
                                    case "Vorname":
                                        tmpFeld1 = "personVorname"
                                    default:
                                        tmpFeld1 = ""
                                        
                                } // Ende switch
                                
                                let temp = " WHERE " + "\(tmpFeld1)" + " = " + "'" + "\(selectedAbfrageFeld3)" + "'"
                                globaleVariable.abfrageQueryString = temp
                                
                            }else{
                                globaleVariable.abfrageQueryString = ""
                            } // Ende if
                            globaleVariable.navigationTabView = 1
                            
                            isPresented = false
                            
                        } label: {
                            Text("Abfrage verlassen")
                        } // Ende Button/label
                        .buttonStyle(.borderedProminent)
                        .foregroundColor(.white)
                        .font(.system(size: 16, weight: .regular))
                        
                        Spacer()
                    } // Ende HStack
                    
                    //Section {
                    Text("Hier können Sie eine Abfrage für Darstellung der Objektenabelle definieren und speichern. Die Abfrage behält ihre Gültigkeit bis zum erneutem Start dieser Darstellung.")
                        .font(.system(size: 14, weight: .regular))
                        .foregroundColor(.gray)
                    
                    //} // Ende Section
                } // Ende Form
                .navigationTitle("Abfrage").navigationBarTitleDisplayMode(.inline)
                .background(globaleVariable.farbenEbene1)
                .cornerRadius(10)
                
            }
        } // Ende VStack
        
        
    } // Ende var body
} // Ende struct


struct ShapeViewEditUser: View {
    @ObservedObject var globaleVariable = GlobaleVariable.shared
    @Binding var isPresentedShapeViewEditUser: Bool
    //@Binding var neuePersonTmp: [String]
    @Binding var personPickerTmp: String
    @Binding var neuePersonTmp: [PersonClassVariable]
    
    @State var showHilfe: Bool = false
    
    @State var selectedPerson_sexInt: Int = 0
    
    var body: some View {
        NavigationView {
            Form {
                Section() {
                    
                    TextField("Vorname", text: $neuePersonTmp[0].personVorname)
                        .padding(5)
                        .background(Color(.systemGray6))
                        .cornerRadius(5)
                        .disableAutocorrection(true)
                    
                    TextField("Name", text: $neuePersonTmp[0].personNachname)
                        .padding(5)
                        .background(Color(.systemGray6))
                        .cornerRadius(5)
                        .disableAutocorrection(true)
                    
                    Picker("Geschlecht:", selection: $selectedPerson_sexInt) {
                        
                        ForEach(0..<globaleVariable.parameterPersonSex.count, id: \.self) { index in
                            Text("\(globaleVariable.parameterPersonSex[index])")
                            
                        } // Ende ForEach
                    } // Ende Picker
                   
                } // Ende Section
                
                HStack {
                    Spacer()
                    Button(action: { isPresentedShapeViewEditUser = false }) {Text("Abbrechen")}
                        .buttonStyle(.bordered).foregroundColor(.blue).font(.system(size: 16, weight: .regular))
                    
                    Button(action: {
                        // Hier aktion für speichern
                        
                        if neuePersonTmp[0].personVorname != "" || neuePersonTmp[0].personNachname != "" {
                            personPickerTmp = " " + neuePersonTmp[0].personNachname + ", " + neuePersonTmp[0].personVorname + " "
                            isPresentedShapeViewEditUser = false
                            
                        } else {
                            
                            print("Die Felder sind leer")
                        } // Ende if/else
                        
                    }) {
                        
                        Text("Speichern")
                        
                    } // Ende Button
                    .buttonStyle(.borderedProminent)
                    .foregroundColor(.white)
                    .font(.system(size: 16, weight: .regular))
                    .cornerRadius(10)
                    Spacer()
                } // Ende HStack
                
                
            } // Ende Form
            .navigationTitle("Neuer Benutzer").navigationBarTitleDisplayMode(.inline)
            
        } // Ende NavigationView
    } // Ende var body
} // Ende struct

struct ShapeShowDetailPhoto: View {
    @Binding var isPresentedShowDetailPhoto: Bool
    @Binding var par1: [ObjectVariable]
    @Binding var par2: Int
    
    var body: some View {
        NavigationView {
            GeometryReader { geometry in
                Form {
                    VStack{
                        Image(base64Str: par1[par2].gegenstandBild)!
                            .resizable()
                            .scaledToFill()
                            .clipped()
                            .cornerRadius(10)
                            .padding(5)
                        Button(action: { isPresentedShowDetailPhoto = false }) {Text("Zurück")}
                            .buttonStyle(.bordered).foregroundColor(.blue).font(.system(size: 16, weight: .regular))
                    } // Ende Vstak
                    .frame(width: geometry.size.width, height: geometry.size.height * 0.9)
                } // Ende Form
                .navigationTitle("Detailsicht Photo").navigationBarTitleDisplayMode(.inline)
            } // Ende GeometryReader
        } // NavigationView
    } // Ende var body
    
} // Ende ShapeshowDetailPhoto



