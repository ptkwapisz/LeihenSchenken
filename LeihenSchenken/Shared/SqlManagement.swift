//
//  SqlManagement.swift
//  LeihenSchenken
//
//  Created by PIOTR KWAPISZ on 12.04.23.
//

import SwiftUI
import Foundation
import SQLite3

func ifDatabaseExist() -> Bool {
    let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
        let url = NSURL(fileURLWithPath: path)
        print(url)
        if let pathComponent = url.appendingPathComponent("LeiheUndSchenkeDb.db") {
            let filePath = pathComponent.path
            let fileManager = FileManager.default
            if fileManager.fileExists(atPath: filePath) && sqlite3_open(filePath, &db) == SQLITE_OK{
                print("File available")
                return true
            } else {
                print("File not available")
                let erstellenDB = erstellenDatenbankUndTabellen()
                let _ = standartWerteSchreiben()
                
                return erstellenDB
            }
        } else {
            print("File path not available")
            return false
        } // Ende if/Else
} // Return func i

// Bei erstellung der Tabelle Gegenstände werden in die Tabelle Gegensände Standardwerte hinzugefügt
// Bei der Erstellung der Tabelle Personen wird ein Musterdatensatz hinzugefügt
func standartWerteSchreiben() {
    
    let perKeyFormatter: DateFormatter
    perKeyFormatter = DateFormatter()
    perKeyFormatter.dateFormat = "y MM dd, HH:mm"
    
    
    let standartWerte: [String] = ["Neuer Gegenstand", "Geld", "Buch", "CD/DVD", "Werkzeug"]
    
    for n in 0...4 {
        let perKey = erstellePerKey(par1: perKeyFormatter.string(from: Date()))
        let myInt1 = Int(perKey) ?? 0
        let myInt2 = myInt1 + n
        let myString = String(myInt2)
       
        let insertDataToGegenstaende = "INSERT INTO Gegenstaende(perKey, gegenstandName) VALUES('\(myString)', '\(standartWerte[n])')"
        
        let insertDataToPersonen = "INSERT INTO Personen(perKey, personPicker, personVorname, personNachname, personSex) VALUES('\(myString)', 'Neue Person', 'Neue Person', 'Neue Person', 'Neue Person')"
        
        if sqlite3_exec(db, insertDataToGegenstaende, nil, nil, nil) !=
           SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("error -->: \(errmsg)")
            print("Daten wurden nicht hinzugefügt")
        } // End if
        
        if n == 0 {
            if sqlite3_exec(db, insertDataToPersonen, nil, nil, nil) !=
                SQLITE_OK {
                let errmsg = String(cString: sqlite3_errmsg(db)!)
                print("error -->: \(errmsg)")
                print("Daten wurden nicht hinzugefügt")
            } // End if
        } // Ende if/else
        
        
    } // Ende for n
    
} // Ende func

func erstellenDatenbankUndTabellen() -> Bool {
    
    
    let createTableObjekte = "CREATE TABLE IF NOT EXISTS Objekte (perKey TEXT PRIMARY KEY, gegenstand TEXT, gegenstandText TEXT, gegenstandBild TEXT, preisWert TEXT, datum TEXT, vorgang TEXT, personVorname TEXT, personNachname TEXT, personSex TEXT, allgemeinerText TEXT)"
    
    let createTablePersonen = "CREATE TABLE IF NOT EXISTS Personen (perKey TEXT PRIMARY KEY, personPicker Text, personVorname TEXT, personNachname TEXT, personSex TEXT)"
    
    let createTableGegenstaende = "CREATE TABLE IF NOT EXISTS Gegenstaende (perKey TEXT PRIMARY KEY, gegenstandName TEXT)"
    
    let fileUrl = try!
    
    FileManager.default.url(for: .documentDirectory,
                            in: .userDomainMask, appropriateFor: nil, create:
                                false).appendingPathComponent("LeiheUndSchenkeDb.db")
    
    if sqlite3_open(fileUrl.path, &db) != SQLITE_OK {
        print("Error opening database")
        sqlite3_close(db)
        db = nil
        return false
    }else{
        print("Datenbank wurde erstellet in")
        print(fileUrl.path)
    } // Ende if
    
    // Bei der Erstellung der Datenbank werden hier die Tabellen kreiert
    if sqlite3_exec(db, createTableObjekte, nil, nil, nil) !=
        SQLITE_OK {
        print("Error creating table Objekte")
        sqlite3_close(db)
        db = nil
        return false
    } else if sqlite3_exec(db, createTablePersonen, nil, nil, nil) !=
                SQLITE_OK {
        print("Error creating table Personen")
        sqlite3_close(db)
        db = nil
        return false
    
    } else if sqlite3_exec(db, createTableGegenstaende, nil, nil, nil) !=
                SQLITE_OK {
        print("Error creating table Gegenstaende")
        sqlite3_close(db)
        db = nil
        return false
        
    }else{
        print("Tabellen wurden erstellt")
        
    } // Ende if
    
    print("Alles ist OK")
    
    return true
    
} // Ende func erstellenDatenbankUndTabellen

func querySQLAbfrageArray(queryTmp: String) -> Array<String>  {
    
    var resultatArray = [String]()
    var statement: OpaquePointer?
    
    if sqlite3_prepare_v2(db, "\(queryTmp)", -1, &statement, nil) != SQLITE_OK {
        let errmsg = String(cString: sqlite3_errmsg(db)!)
        print("Error preparing query select: \(errmsg)")
    } // End if

    while sqlite3_step(statement) == SQLITE_ROW {

        if let cString0 = sqlite3_column_text(statement, 0) {
            let name0 = String(cString: cString0)
            // print("Das erste Feld die Summe = \(name0) ", terminator: "")
            if name0 != "" {
               resultatArray.append(name0)
            }
        } else {
            print("Die Werte in der Tabelle wurden nicht gefunden")
        } // End if else

    } // Ende while
    
    if sqlite3_finalize(statement) != SQLITE_OK {
        let errmsg = String(cString: sqlite3_errmsg(db)!)
        print("Error finalizing prepared statement: \(errmsg)")
    } // End if

    statement = nil
    
    return resultatArray
    
} // Ende func querySQLAbfrageArray


// Diese function liefert den ersaten element eines Strig-Arrays zurück
func extrahierenString(arrayTemp: [String]) -> String  {
    
    var resultat: String
    
    if arrayTemp.count > 0 {
       resultat = arrayTemp[0]
    }else{
       resultat = ""
        
    } // Ende if/else
    
    return resultat
    
} // Ende func extrahiereString

func anzahlDerDatensaetze(tableName: String) -> Int {
    var resultat: Int = 0
    //let query = "select count(*) from '\(tableName)';"
    let temp = querySQLAbfrageArray(queryTmp: "select count(*) from '\(tableName)';")
    resultat = Int(temp[0])!
    
  return resultat
} // Ende func


func datenbankReset(){
    
    print("Datenbank wird zurückgesetzt!")
    
    sqlite3_close(db)
    db = nil
    deleteFile(fileNameToDelete: "LeiheUndSchenkeDb.db")
    //var db: OpaquePointer?
    
    let _: Bool = erstellenDatenbankUndTabellen()
    
    // Hier werden Standardwerte geschrieben
    standartWerteSchreiben()
    
    // Hier werden die globale Arrays neu erstellt
    refreschParameter()
    
} // Ende func

func deleteFile(fileNameToDelete: String) {
    
    // 1. Find a Documents directory on the device,
    // 2. Check if a file at the specified path exists,
    // 3. Delete file,
    // 4. Catch an error if an error takes place.
    
    var filePath = ""
    // Fine documents directory on device
     let dirs : [String] = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.allDomainsMask, true)
    if dirs.count > 0 {
        let dir = dirs[0] //documents directory
        filePath = dir.appendingFormat("/" + fileNameToDelete)
        //print("Local path = \(filePath)")
     
    } else {
        print("Could not find local directory to file")
        return
    }
    do {
         let fileManager = FileManager.default
        
        // Check if file exists
        if fileManager.fileExists(atPath: filePath) {
            // Delete file
            try fileManager.removeItem(atPath: filePath)
        } else {
            print("File does not exist")
        } // End if else
     
    } // End do
    catch let error as NSError {
        print("An error took place: \(error)")
    } // End catch
    
} // End func deleteFile()

// Die Arrays von der Eingabemaske werden neu erstellt
// Diese Function wird nach import oder neuerstellung des Datenbankes aufgerufen
func refreschParameter(){
    @ObservedObject var globaleVariable = GlobaleVariable.shared
    
    // Das Array mit den Standartwerten wird erstellt
    globaleVariable.parameterGegenstand = querySQLAbfrageArray(queryTmp: "Select gegenstandName FROM Gegenstaende")
    
    globaleVariable.personenParameter = querySQLAbfrageClassPersonen(queryTmp: "Select * From Personen")
    
    //globaleVariable.parameterPerson = personenArray()
    
} // Ende refreschParameter

// Dierse Funktion fügt in eine Variable (Type Class) die Tabelle aus einer Datenbank
func querySQLAbfrageClassObjecte(queryTmp: String) -> [ObjectVariable]  {
    @ObservedObject var globaleVariable = GlobaleVariable.shared
    
    var name: [String] = ["","","","","","","","","","",""]
    
    var resultatClass: [ObjectVariable] = [ObjectVariable(perKey: "", gegenstand: "", gegenstandTex: "", gegenstandBild: "", preisWert: "", datum: "", vorgang: "", personVorname: "", personNachname: "", personSex: "", allgemeinerText: "")]
    
    let queryString = queryTmp + globaleVariable.abfrageQueryString
    
    //print(queryString)
    
    var statement: OpaquePointer?
    
    if sqlite3_prepare_v2(db, "\(queryString)", -1, &statement, nil) != SQLITE_OK {
        let errmsg = String(cString: sqlite3_errmsg(db)!)
        print("Error preparing query select: \(errmsg)")
    }else{
        resultatClass.removeAll()
    } // End if

    while sqlite3_step(statement) == SQLITE_ROW {

        for n in 0...10 {
            if let cString0 = sqlite3_column_text(statement, Int32(n)) {
                name[n] = String(cString: cString0)
            } else {
                print("Werticht gefunden")
            } // End if else
        } // Ende for n
        
        
        resultatClass.append(ObjectVariable(perKey: name[0], gegenstand: name[1], gegenstandTex: name[2], gegenstandBild: name[3], preisWert: name[4], datum: name[5], vorgang: name[6], personVorname: name[7], personNachname: name[8], personSex: name[9], allgemeinerText: name[10]))
        
    } // Ende while
    
    if sqlite3_finalize(statement) != SQLITE_OK {
        let errmsg = String(cString: sqlite3_errmsg(db)!)
        print("Error finalizing prepared statement: \(errmsg)")
    } // End if

    statement = nil
    
    return resultatClass
    
} // Ende func querySQLAbfrageClassObjekte

func querySQLAbfrageClassGegenstaende(queryTmp: String) -> [GegenstandVariable]  {
    @ObservedObject var globaleVariable = GlobaleVariable.shared
    
    var name: [String] = ["",""]
    
    var resultatClass: [GegenstandVariable] = [GegenstandVariable(perKey: "", gegenstandName: "")]
    
    let queryString = queryTmp
    
    //print(queryString)
    
    var statement: OpaquePointer?
    
    if sqlite3_prepare_v2(db, "\(queryString)", -1, &statement, nil) != SQLITE_OK {
        let errmsg = String(cString: sqlite3_errmsg(db)!)
        print("Error preparing query select: \(errmsg)")
    }else{
        resultatClass.removeAll()
    } // End if

    while sqlite3_step(statement) == SQLITE_ROW {

        //var n: Int = 0
        for n in 0...1 {
            if let cString0 = sqlite3_column_text(statement, Int32(n)) {
                name[n] = String(cString: cString0)
            } else {
                print("Werticht gefunden")
            } // End if else
        } // Ende for n
        
        if name[1] != "Neuer Gegenstand" {
            resultatClass.append(GegenstandVariable(perKey: name[0], gegenstandName: name[1]))
        } // Ende if
        
    } // Ende while
    
    if sqlite3_finalize(statement) != SQLITE_OK {
        let errmsg = String(cString: sqlite3_errmsg(db)!)
        print("Error finalizing prepared statement: \(errmsg)")
    } // End if

    statement = nil
    
    resultatClass.sort{($0.gegenstandName) < ($1.gegenstandName)}
    
    return resultatClass
    
} // Ende func querySQLAbfrageClassGegenstaende


func deleteItemsFromDatabase(tabelle: String, perKey: String) {

    let deleteStatementString: String = "DELETE FROM \(tabelle) WHERE perKey = \(perKey)"
    print(deleteStatementString)
    
    var deleteStatement: OpaquePointer?

    if sqlite3_prepare_v2(db, deleteStatementString, -1, &deleteStatement, nil) == SQLITE_OK {
       if sqlite3_step(deleteStatement) == SQLITE_DONE {
          print("\nSuccessfully deleted row.")
       } else {
          print("\nCould not delete row.")
       } // Ende if/else
    } else {
       print("\nDELETE statement could not be prepared")
    } // Ende if/else
  
   sqlite3_finalize(deleteStatement)
    
} // Ende func



// Diese Funktion ersetzt ein Tabellenfeld durch ein neues in der Datenbanktabelle Objekte
// Vorher geschieht die Prüfung, ob die Felder sich unterscheiden
func updateSqliteTabellenField(sqliteFeld: String, neueInhalt: String, perKey: String) {
    
    let alterWertQuery = "SELECT \(sqliteFeld) FROM Objekte WHERE perKey = \(perKey)"
    
    let alterWert = querySQLAbfrageArray(queryTmp: alterWertQuery)
    // Kann später gelöscht werden
    if alterWert[0] == neueInhalt {
        if neueInhalt.count < 50 {
            print("\(alterWert[0])" + " = " + "\(neueInhalt)")
            print("Gleich")
        }else{
            print("Bilder sind gleich")
        } // Ende if
    }else{
        let updateStatementString = "UPDATE Objekte SET \(sqliteFeld) = '\(neueInhalt)' WHERE perKey = \(perKey)"
        
        var updateStatement: OpaquePointer?
        
        if sqlite3_prepare_v2(db, updateStatementString, -1, &updateStatement, nil) ==
            SQLITE_OK {
            if sqlite3_step(updateStatement) == SQLITE_DONE {
                print("\nSuccessfully updated row.")
            } else {
                print("\nCould not update row.")
            } // Ende if/else
        } else {
            print("\nUPDATE statement is not prepared")
        } // Ende if/else
        
        sqlite3_finalize(updateStatement)
        
        // Kann später gelöscht werden
        if neueInhalt.count < 50 {
            print("\(alterWert[0])" + " != " + "\(neueInhalt)")
            print("Ungleich")
        }else{
            print("Bilder sind ungleich")
        } // Ende if
        
    } // Ende if/else
    
} // Ende func

// Dierse Funktion fügt in eine Variable (Type Class) die Personentabelle aus der Datenbank
// Der erste parameter ist die Query-String
// Der zweite Parameter besagt aus welcher Struct diese Funktion aufgerufen wurde
// Nur bei der ObjectTabelle (Tab1) soll der Zusatz 'globaleVariable.abfrageQueryString' hinzugefügt werden
// damit die Abfrage und Filter funktionieren.
func querySQLAbfrageClassPerson(queryTmp: String, isObjectTabelle: Bool) -> [PersonClassVariable]  {
    @ObservedObject var globaleVariable = GlobaleVariable.shared
    
    var name: [String] = ["","","","",""]
    var queryString: String = ""
    
    var resultatClass: [PersonClassVariable] = [PersonClassVariable(perKey: "", personPicker: "", personVorname: "", personNachname: "", personSex: "")]
    
    if isObjectTabelle == true {
        queryString = queryTmp + globaleVariable.abfrageQueryString
    }else{
        queryString = queryTmp
    } // Ende if/else
    
    //print(queryString)
    
    var statement: OpaquePointer?
    
    if sqlite3_prepare_v2(db, "\(queryString)", -1, &statement, nil) != SQLITE_OK {
        let errmsg = String(cString: sqlite3_errmsg(db)!)
        print("Error preparing query select: \(errmsg)")
    }else{
        resultatClass.removeAll()
    } // End if

    while sqlite3_step(statement) == SQLITE_ROW {

        //var n = 0
        for n in 0...name.count - 1 {
            if let cString0 = sqlite3_column_text(statement, Int32(n)) {
                name[n] = String(cString: cString0)
            } else {
                print("Wert nicht gefunden")
            } // End if else
        } // Ende for n
        
        if name[1] != "Neue Person" {
            resultatClass.append(PersonClassVariable(perKey: name[0], personPicker: name[1], personVorname: name[2], personNachname: name[3], personSex: name[4]))
        }
    } // Ende while
    
    if sqlite3_finalize(statement) != SQLITE_OK {
        let errmsg = String(cString: sqlite3_errmsg(db)!)
        print("Error finalizing prepared statement: \(errmsg)")
    } // End if

    statement = nil
    
    resultatClass.sort{($0.personNachname, $0.personVorname) < ($1.personNachname, $1.personVorname)}
    
    return resultatClass
    
} // Ende func querySQLAbfrageClassObjekte


// Diese Funktion wird Eingesetzt, um zu prüfen, ob es Verdopellung bei erstellen der Gegenstände
// oder Personen gibt.
// Der Parameter parPerson ist ein Array
// parPerson[0] = Vorname
// parPerson[1] = Nachname
// parPerson[2] = Sex
// Die Funktion liefert 'true' wenn einer von der Parameter sich in der Datenbank befindet.
func pruefenDieElementeDerDatenbank(parPerson: [String], parGegenstand: String) -> Bool {
    var resultat: Bool? = nil
    let parPersonTmp1: Int = parPerson[0].count + parPerson[1].count + parPerson[2].count
    let parGegenstandTmp: Int = parGegenstand.count
    var parPersonTmp2: String = ""
    
    if parGegenstandTmp > 0 {
        let ergebnis = querySQLAbfrageArray(queryTmp: "SELECT count() gegenstand from Gegenstaende WHERE gegenstandName = '\(parGegenstand)'")
        if Int(ergebnis[0])! > 0 {
            resultat = true
        }else{
            resultat = false
            
        }// Ende if/else
        
        print("Anzahl der Gegenstände ist " + ergebnis[0])
        
    } // Ende if
    
    if parPersonTmp1 > 0 {
        parPersonTmp2 = parPerson[1] + ", " + parPerson[0]
        let ergebnis = querySQLAbfrageArray(queryTmp: "SELECT count() personPicker from Personen WHERE personPicker = '\(parPersonTmp2)' AND personSex = '\(parPerson[2])'")
        if Int(ergebnis[0])! > 0 {
            resultat = true
        }else{
            resultat = false
            
        }// Ende if/else
        print("Anzahl der Personen ist " + ergebnis[0])
    } // Ende if
    
    return resultat!
} // Ende func

// Diese Funktion speichert ein Gegenstaend in die Datenbank in die Tabelle Gegenstaende
func gegenstandInDatenbankSchreiben(par1: String) {
    @ObservedObject var globaleVariable = GlobaleVariable.shared
    
    let perKeyFormatter: DateFormatter
    perKeyFormatter = DateFormatter()
    perKeyFormatter.dateFormat = "y MM dd, HH:mm"
    
    let perKey = erstellePerKey(par1: perKeyFormatter.string(from: globaleVariable.datum))
    
    let insertDataToDatenbank = "INSERT INTO gegenstaende(perKey, gegenstandName) VALUES('\(perKey)','\(par1)')"

    if sqlite3_exec(db, insertDataToDatenbank, nil, nil, nil) !=
       SQLITE_OK {
        let errmsg = String(cString: sqlite3_errmsg(db)!)
        print("error -->: \(errmsg)")
        print("Personendaten wurden nicht hinzugefügt")
    } // End if

    
    print("Personendaten wurden gespeichert...")
    
    
} // Ende func

// Dierse Funktion fügt in eine Variable (Type Class) die Personentabelle aus der Datenbank
// Der erste parameter ist die Query-String
func querySQLAbfrageClassPersonen(queryTmp: String) -> [PersonClassVariable]  {
    //@ObservedObject var globaleVariable = GlobaleVariable.shared
    
    var name: [String] = ["","","","",""]
    let queryString: String = queryTmp
    
    var resultatClass: [PersonClassVariable] = [PersonClassVariable(perKey: "", personPicker: "", personVorname: "", personNachname: "", personSex: "")]
   
    var statement: OpaquePointer?
    
    if sqlite3_prepare_v2(db, "\(queryString)", -1, &statement, nil) != SQLITE_OK {
        let errmsg = String(cString: sqlite3_errmsg(db)!)
        print("Error preparing query select: \(errmsg)")
    }else{
        resultatClass.removeAll()
    } // End if

    while sqlite3_step(statement) == SQLITE_ROW {

        //var n = 0
        for n in 0...name.count - 1 {
            if let cString0 = sqlite3_column_text(statement, Int32(n)) {
                name[n] = String(cString: cString0)
            } else {
                print("Wert nicht gefunden")
            } // End if else
        } // Ende for n
        
        
        resultatClass.append(PersonClassVariable(perKey: name[0], personPicker: name[1], personVorname: name[2], personNachname: name[3], personSex: name[4]))
        
    } // Ende while
    
    if sqlite3_finalize(statement) != SQLITE_OK {
        let errmsg = String(cString: sqlite3_errmsg(db)!)
        print("Error finalizing prepared statement: \(errmsg)")
    } // End if

    statement = nil
    
    //resultatClass.sort{($0.personNachname, $0.personVorname) < ($1.personNachname, $1.personVorname)}
    
    return resultatClass
    
} // Ende func querySQLAbfrageClassObjekte
