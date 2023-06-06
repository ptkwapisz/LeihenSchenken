//
//  DetailView.swift
//  LeihenSchenken
//
//  Created by PIOTR KWAPISZ on 27.03.23.
//

import Foundation
import SwiftUI

struct DeteilView: View {
    @ObservedObject var globaleVariable = GlobaleVariable.shared
    @ObservedObject var userSettingsDefaults = UserSettingsDefaults.shared
    
    @State var showAbfrageModalView: Bool = false
    @State var isParameterBereich: Bool = false
    
    @State var showMenue1: Bool = false
    @State var showMenue1_1: Bool = false
    @State var showMenue1_2: Bool = false
    @State var showMenue2: Bool = false
    @State var showMenue3: Bool = false
    @State var showMenue3_1: Bool = false
    @State var showMenue3_2: Bool = false
    @State var showMenue4: Bool = false
    @State var showMenue5: Bool = false
    @State var showAppInfo: Bool = false
    @State var showTabHilfe: Bool = false
    
    
    var body: some View {
    
        VStack(spacing: 10) {
            
            TabView(selection: $globaleVariable.navigationTabView) {
                
                Tab1(selectedTabView: $globaleVariable.navigationTabView).tabItem {
                    Image(systemName: "tablecells.fill")
                    Text("Objekte")
                } // Ende Tab
                .tag(1) // Die Tags identifizieren die Tab und füren zum richtigen Titel
                
                
                Tab2(selectedTabView: $globaleVariable.navigationTabView).tabItem {
                    Image(systemName: "archivebox.fill")
                    Text("Gegenstände")
                    
                } // Ende Tab
                .tag(2) // Die Tags identifizieren die Tab und füren zum richtigen Titel
                
                Tab3(selectedTabView: $globaleVariable.navigationTabView).tabItem {
                    Image(systemName: "person.2.fill")
                    Text("Personen")
                    
                } // Ende Tab
                .tag(3) // Die Tags identifizieren die Tab und füren zum richtigen Titel
                
                Tab4(selectedTabView: $globaleVariable.navigationTabView).tabItem {
                    Image(systemName: "chart.xyaxis.line")
                    Text("Statistik")
                    
                } // Ende Tab
                .tag(4) // Die Tags identifizieren die Tab und füren zum richtigen Titel
                
                if userSettingsDefaults.showHandbuch == true {
                    Tab5(selectedTabView: $globaleVariable.navigationTabView).tabItem {
                        Image(systemName: "h.circle.fill")
                        Text("Handbuch")
                    } // Ende Tab
                    .tag(5) // Die Tags identifizieren die Tab und füren zum richtigen Titel
                } // Ende if
            } // Ende TabView
            
        } // Ende VStack
        .navigationTitle(naviTitleText(tabNummer: globaleVariable.navigationTabView))

        .toolbar {
            // Wenn das Tab Handbuch gezeigt wird
            // andere Tabmenuepunkte ausgeblendet
            if globaleVariable.navigationTabView < 5 {
                ToolbarItemGroup(placement: .navigationBarLeading) {
                    Menu(content: {
                        
                        Menu("Menue 1") { // Menue 1
                            Button("Menue1_1", action: {}) // Menue 1.1
                            Button("Menue1_2", action: {}) // Menue 1.2
                        } // Ende Menu
                        
                        
                        Menu("Menue 2") {
                            Button("Menue 2.1", action: {})
                            Button("Menue 2.2", action: {})
                        } // Ende Menu
                        
                        Menu("Eigenschaften") {
                            Button("Bearbeiten", action: {showMenue3_1.toggle()}) // Menue3_1
                            Button("Zurücksetzen", action: {showMenue3_2.toggle()}) // Menue3_2
                        } // Ende Menu
                        
                        //Button("Abfragen", action: {showMenue3 = true})
                        Divider()
                        //Button("Settings zurücksetzen", action: {showMenue4.toggle()})
                        Button("Datenbank zurücksetzen", action: {showMenue5.toggle()})
                        
                    }) {
                        Image(systemName: "filemenu.and.cursorarrow")
                    } // Ende Button
                    .alert("Trefen Sie eine Wahl!", isPresented: $showMenue3_2, actions: {
                        Button("Abbrechen") {}; Button("Ausführen") {deleteUserDefaults()}
                    }, message: { Text("Durch das Zurücksetzen der Settings werden alle Einstellungen auf die Standardwerte zurückgesetzt. Standardwerte sind: Farbe Ebene 0: blau, Farbe Ebene1: grün") } // Ende message
                    ) // Ende alert
                    .alert("Trefen Sie eine Wahl!", isPresented: $showMenue5, actions: {
                        Button("Abbrechen") {}; Button("Ausführen") {datenbankReset()}
                    }, message: { Text("Durch das Zurücksetzen der Datenbank werden die Datenbank und alle Tabellen gelöscht. Dabei gehen alle gespeicherte Daten verloren. Dies kann nicht rückgängig gemacht werden! Dann werden die Datenbank und alle Tabellen neu erstellt.") } // Ende message
                    ) // Ende alert
                    //.sheet(isPresented: $showMenue1_1, content: { ShapeViewAddUser(isPresented: $showMenue1_1, isParameterBereich: $isParameterBereich )})
                    .sheet(isPresented: $showMenue3_1, content: { ShapeViewSettings(isPresented: $showMenue3_1)})
                    //.sheet(isPresented: $showMenue3, content: { ShapeViewAbfrage(isPresented: $showMenue3) })
                } // Ende ToolbarItemGroup
                /*
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    Button(action: {showAppInfo.toggle()
                        
                    }) {
                        Image(systemName: "house")
                        
                    } // Ende Button
                    .alert("Allgemeine Information", isPresented: $showAppInfo, actions: {
                        Button(" - OK - ") {}
                    }, message: { Text("Das ist die allgemeine Information über diese Applikation.") } // Ende message
                    ) // Ende alert
                
                } // Ende ToolbarItemGroup
                */
                //self.shapeSettings.showSettings = true
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    Button(action: {showAbfrageModalView = true
                        
                    }) {
                        Image(systemName: "line.3.horizontal.decrease.circle") //"icons8-filter-25"  line.3.horizontal.decrease.circle
                    } // Ende Button
                    .sheet(isPresented: $showAbfrageModalView, content:  { ShapeViewAbfrage(isPresented: $showAbfrageModalView) }) // Zahnrad
                    Spacer()
                } // Ende ToolbarItemGroup
                
            } // Ende if
            
            // Wenn das Tab Handbuch gezeigt wird
            // wird das Zeichen für Drucken gezeigt
            if globaleVariable.navigationTabView == 5 {
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    Button(action:{
                        
                       
                        printingFile()
                        
                    }) {
                        Image(systemName: "printer") // printer.fill square.and.arrow.up
                    } // Ende Button
                } // Ende ToolbarItem
            } // Ende if
            
            ToolbarItemGroup(placement: .navigationBarTrailing) {
                Button(action:{showTabHilfe.toggle()
                        
                }) {
                    Image(systemName: "questionmark.circle")
                } // Ende Button
                .alert("Hilfe für \(naviTitleText(tabNummer: globaleVariable.navigationTabView))", isPresented: $showTabHilfe, actions: {
                      Button(" - OK - ") {}
                      }, message: { Text("Das ist die Beschreibung für die augewählte Tab.") } // Ende message
                    ) // Ende alert
                } // Ende ToolbarItemGroup
                
        } // Ende toolbar
        //.toolbarRole(.editor) // Bei dieser Rolle ist der back Button < ohne Text
        
        
        
    } // var body
} // Ende struct

func naviTitleText(tabNummer: Int) -> String {
    @ObservedObject var globaleVariable = GlobaleVariable.shared
    let returnWert:  String
    
    switch tabNummer {
        case 1:
            returnWert = "Objektenliste"
        case 2:
            returnWert = "Gegenständeliste"
        case 3:
            returnWert = "Personenliste"
        case 4:
            returnWert = "Statistiken"
        case 5:
            returnWert = "Handbuch"
        default:
            returnWert = ""
    } // Ende switch

    return returnWert
    
} // Ende func naviTitleText

