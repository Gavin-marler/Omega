//
//  NewSamplesView.swift
//  Omega
//
//  Created by Gavin Marler on 12/7/21.
//

import SwiftUI

struct NewSampleView: View {
    let chemicals : [Chemical]
    init(){
        let url = Bundle.main.url(forResource: "chemicals", withExtension: "json")!
        let data = try! Data(contentsOf: url)
        chemicals = try! JSONDecoder().decode([Chemical].self, from: data)
    }
    
    @FocusState var isActive : Bool
    @EnvironmentObject var samples: Samples
    @State private var sample = Sample()
    @State private var ind = 0
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView{
            Form{
                Section {
                    HStack{
                        Text("Sample Name")
                        TextField("Sample Name", text: $sample.name)
                    }
                    HStack{
                        Text("Location")
                        TextField("Location", text: $sample.location)
                    }
                }
                Section {
                    Picker(selection: $ind, label: Text("Chemical")){
                        ForEach(0..<chemicals.count){index in
                            VStack(alignment: .leading){
                                Text(chemicals[index].chemical)
                                    .fontWeight(.bold)
                                    .font(.headline)
                                Text(chemicals[index].method)
                                    .fontWeight(.light)
                                    .font(.system(size: 10))
                            }
                        }
                    }
                    .onChange(of: ind){ newvalue in
                        sample.chemical = chemicals[ind]
                    }
                    Text("Selected Chemical: \(chemicals[ind].chemical)")
                    HStack{
                        Text("Flow Rate: \(sample.chemical.flowRate)")
                        Text("Min-Max: \(sample.chemical.volMinMax)")
                    }
                    Link("NIOSH Method \(sample.chemical.methodNum)", destination: URL(string: sample.chemical.NIOSH)!)
                }
                Section{
                    HStack {
                        Text("Pre Calibration")
                        TextField("Pre Calibration", value: $sample.preCal, format: .number)
                        .keyboardType(.decimalPad)
                        .focused($isActive)
                        .toolbar{
                            ToolbarItemGroup(placement: .keyboard){
                                Spacer()
                                Button("Done"){
                                    isActive = false
                                }
                            }
                        }
                    }
                    HStack{
                        DatePicker("Start Time", selection: $sample.start, displayedComponents: .hourAndMinute)
                    }
                }
            }
            .navigationTitle(Text("New Sample"))
            .navigationBarItems(trailing: Button(action: {
                self.samples.add(sample: sample)
                presentationMode.wrappedValue.dismiss()
            }) {
                Image(systemName: "plus")
                Text("Finish Sample")
            })
            .navigationBarItems(leading: Button(action: {
                presentationMode.wrappedValue.dismiss()
            }) {
                Text("Cancel")
            })
        }
    }
}

struct NewSampleView_Previews: PreviewProvider {
    static var previews: some View {
        NewSampleView()
    }
}
