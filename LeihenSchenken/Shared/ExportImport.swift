//
//  ExportImport.swift
//  LeihenSchenken
//
//  Created by PIOTR KWAPISZ on 07.07.23.
//

import SwiftUI
import Foundation
import SQLite3

/*
 func exportToCSV() {
 //@ObservedObject var globaleVariable = GlobaleVariable.shared
 
 let alleDaten: [ObjectVariable] = querySQLAbfrageClassObjecte(queryTmp: "SELECT * FROM Objekte")
 
 var csvString = "\("perKey");\("gegenstand");\("gegenstandText");\("gegenstandBild");\("preisWert");\("datum");\("vorgang");\("personVorname");\("personNachname");\("personSex");\("allgemeinerText")\n"
 
 for j in 0 ... alleDaten.count - 1 {
 
 csvString = csvString.appending("\(String(describing: alleDaten[j].perKey));\(String(describing: alleDaten[j].gegenstand));\(String(describing: alleDaten[j].gegenstandText));\(String(describing: alleDaten[j].gegenstandBild));\(String(describing: alleDaten[j].preisWert));\(String(describing: alleDaten[j].datum));\(String(describing: alleDaten[j].vorgang));\(String(describing: alleDaten[j].personVorname));\(String(describing: alleDaten[j].personNachname));\(String(describing: alleDaten[j].personSex));\(String(describing: alleDaten[j].allgemeinerText))\n")
 
 } // Ende for j Schleife
 
 
 let fileManager = FileManager.default
 do {
 let path = try fileManager.url(for: .documentDirectory, in: .allDomainsMask, appropriateFor: nil, create: false)
 let fileURL = path.appendingPathComponent("LeihUndSchenkeDB.csv")
 try csvString.write(to: fileURL, atomically: true, encoding: .utf8)
 } catch {
 print("error creating file")
 } // Ende do catch
 
 } // Ende func exportToCSV
 */

struct BlurView: UIViewRepresentable {
    var style: UIBlurEffect.Style
    
    func makeUIView(context: Context) -> UIVisualEffectView {
        let view = UIVisualEffectView(effect: UIBlurEffect(style: style))
        return view
    } // Ende func
    
    func updateUIView(_ uiView: UIVisualEffectView, context: Context) {}
} // Ende struct


// Export to CSV with ProgressView
struct ExportCSVProgressView: View {
    // @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @Binding var isPresented: Bool
    @State private var minNumber = 0.0
    
    @State var csvString = "\("perKey");\("gegenstand");\("gegenstandText");\("gegenstandBild");\("preisWert");\("datum");\("vorgang");\("personVorname");\("personNachname");\("personSex");\("allgemeinerText")\n"
    
    
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    var body: some View {
        
        let alleDaten: [ObjectVariable] = querySQLAbfrageClassObjecte(queryTmp: "SELECT * FROM Objekte")
        let maxNumber = alleDaten.count - 1
        
        VStack{
            VStack(spacing: 14) {
                HStack(spacing: 20) {
                    ProgressView(value: minNumber, total: Double(maxNumber) )
                        .scaleEffect(1.5)
                        .progressViewStyle(CircularProgressViewStyle(tint: Color(UIColor(red: 0.05, green: 0.64, blue: 0.82, alpha: 1))))
                        .onReceive(timer) { _ in
                            
                            for j in 0 ... alleDaten.count - 1 {
                                
                                csvString = csvString.appending("\(String(describing: alleDaten[j].perKey));\(String(describing: alleDaten[j].gegenstand));\(String(describing: alleDaten[j].gegenstandText));\(String(describing: alleDaten[j].gegenstandBild));\(String(describing: alleDaten[j].preisWert));\(String(describing: alleDaten[j].datum));\(String(describing: alleDaten[j].vorgang));\(String(describing: alleDaten[j].personVorname));\(String(describing: alleDaten[j].personNachname));\(String(describing: alleDaten[j].personSex));\(String(describing: alleDaten[j].allgemeinerText))\n")
                                
                                   minNumber = Double(j)
                                   print("\(j)")
                                   print(minNumber)
                                
                            } // Ende for j Schleife
                            
                            let fileManager = FileManager.default
                            do {
                                let path = try fileManager.url(for: .documentDirectory, in: .allDomainsMask, appropriateFor: nil, create: false)
                                let fileURL = path.appendingPathComponent("LeiheUndSchenkeDb.csv")
                                try csvString.write(to: fileURL, atomically: true, encoding: .utf8)
                            } catch {
                                print("error creating file")
                            } // Ende do catch
                            
                            print("Ende")
                            isPresented = false
                            
                        } // Ende onRecive
                    Text("Processing...")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.black)
                }// Ende HStack
                
                Divider()
                
                Text("\(Int(maxNumber + 1)) Datensätze werden exportiert!")
                    .font(.headline)
                    .foregroundColor(Color(UIColor(red: 0.05, green: 0.64, blue: 0.82, alpha: 1)))
                    .multilineTextAlignment(.center)
                
                
            }// Ende VStack
            .padding(.vertical, 25)
            .frame(maxWidth: 270)
            .background(BlurView(style: .systemMaterial))
            .cornerRadius(20)
            //.ignoresSafeArea()
            //Spacer()
            
        }// Ende VStack
        
        
    }// Ende var body
} // Ende struct

// Copy database file from to documents folder
func backupDatabase() {
    @ObservedObject var globaleVariable = GlobaleVariable.shared
    let fileManager = FileManager.default
    
    guard let documentsUrl = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first else { return }
    
    let backupDatabaseURL = documentsUrl.appendingPathComponent("LeiheUndSchenkeDbCopy.db")
    let userDatabaseURL = documentsUrl.appendingPathComponent("LeiheUndSchenkeDb.db")
    
    do {
        if !fileManager.fileExists(atPath: backupDatabaseURL.path) {
            print("DB does not exist in documents folder")
            try fileManager.copyItem(atPath: userDatabaseURL.path, toPath: backupDatabaseURL.path)
            
        } else {
            print("Database file found at path: \(backupDatabaseURL.path)")
            try fileManager.removeItem(atPath: backupDatabaseURL.path)
            try fileManager.copyItem(atPath: userDatabaseURL.path, toPath: backupDatabaseURL.path)
        } // Ende if/else
    } catch {
        print("Unable to copy LeiheUndSchenkeDb.db: \(error)")
    } // Ende do/catch
    globaleVariable.showDBLadenMenueItem = false
} // Ende func


func loadDatabase() {
    //var showAlert: Bool = false
    let fileManager = FileManager.default
    
    guard let documentsUrl = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first else { return }
    
    let backupDatabaseURL = documentsUrl.appendingPathComponent("LeiheUndSchenkeDbCopy.db")
    let userDatabaseURL = documentsUrl.appendingPathComponent("LeiheUndSchenkeDb.db")
    
    do {
        if !fileManager.fileExists(atPath: backupDatabaseURL.path) {
            print("DB does not exist in documents folder")
            //showAlert = true
            
        } else {
            print("Database file found at path: \(backupDatabaseURL.path)")
            
            sqlite3_close(db)
            db = nil
            
            try fileManager.removeItem(atPath: userDatabaseURL.path)
            try fileManager.copyItem(atPath: backupDatabaseURL.path, toPath: userDatabaseURL.path)
            
            guard sqlite3_open_v2(userDatabaseURL.path, &db, SQLITE_OPEN_READWRITE, nil) == SQLITE_OK else {
                print("Error opening database")
                sqlite3_close(db)
                db = nil
                return
            } // Ende guard
            
            refreschParameter()
            
        } // Ende if/else
    } catch {
        print("Unable to copy LeiheUndSchenkeDb.db: \(error)")
    } // Ende do/catch
} // Ende func


// Diese Funktion wird benutzt um die egsistenz der Datenbank Copy Datei zu prüfen
// Wenn diese Copy nicht existiert wird das Menue Button 'DB Laden' ausgegraut

func ifExistLeiheUndSchenkeDbCopy() -> Bool {
    var parameter: Bool = false
    let fileManager = FileManager.default
    guard let documentsUrl = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first else { return parameter}
    
    let backupDatabaseURL = documentsUrl.appendingPathComponent("LeiheUndSchenkeDbCopy.db")
    
    if !fileManager.fileExists(atPath: backupDatabaseURL.path) {
        print("Database Copy file does not exist in documents folder")
        parameter = true
        
    } else {
        print("Database Copy file found at path: \(backupDatabaseURL.path)")
        parameter = false
    } // Ende if/else
    return parameter
}
