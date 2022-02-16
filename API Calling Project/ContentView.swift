//
//  ContentView.swift
//  API Calling Project
//
//  Created by Student on 2/9/22.
//

import SwiftUI

struct ContentView: View {
    @State private var listedElements = [Element]()
    @State private var showingAlert = false
    init () {
        UITableView.appearance().backgroundColor = .cyan
    }
    var body: some View {
        NavigationView {
            List(listedElements) { element in
                NavigationLink(
                    destination: VStack{
                        Text(element.name)
                            .padding()
                        Text(element.symbol)
                            .padding()
                        Text(element.history)
                            .padding()
                        Text(element.facts)
                            .padding()
                    }, label: {
                        HStack {
                            Text(element.symbol)
                            Text(element.name)
                        }
                    })
                    .foregroundColor(.blue)
            }
            .navigationTitle("Periodic Elements")
        }
        .onAppear(perform: {
            PeriodicAPI()
        })
        .alert(isPresented: $showingAlert, content: {
            Alert(title: Text("Loading Error"),
                  message: Text("There was a problem loading the data"),
                  dismissButton: .default(Text("OK")))
        })
    }
    
    func PeriodicAPI() {
        let apiKey = "?rapidapi-key=2e67ced228mshff9651564e0faf7p1197aajsn7ed0ac1ca802"
        let query = "https://periodictable.p.rapidapi.com/\(apiKey)"
        if let url = URL(string: query) {
            if let data = try? Data(contentsOf: url) {
                let json = try! JSON(data: data)
                
                let contents = json.arrayValue
                for item in contents {
                    let name = item["name"].stringValue
                    let symbol = item["symbol"].stringValue
                    let history = item["history"].stringValue
                    let facts = item["facts"].stringValue
                    let element = Element(name: name, symbol: symbol, history: history, facts: facts)
                    listedElements.append(element)
                }
                
            }
        }
    }
    
    
    struct ContentView_Previews: PreviewProvider {
        static var previews: some View {
            ContentView()
        }
    }
}
struct Element: Identifiable {
    let id = UUID()
    var name: String
    var symbol: String
    var history: String
    var facts: String
}
