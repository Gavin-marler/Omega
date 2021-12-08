//
//  SamplesView.swift
//  Omega
//
//  Created by Gavin Marler on 12/7/21.
//

import SwiftUI

struct OpenSamplesView: View{
    @EnvironmentObject var samples: Samples
    @State var sample: Sample
    @FocusState var isActive : Bool
    
    var body: some View{
        NavigationView{
            Form{
                Section{
                    VStack{
                        Text(sample.name)
                        Text(sample.chemical.chemical)
                    }
                }
                Section{
                    HStack {
                        Text("Post Calibration")
                        TextField("Post Calibration", value: $sample.postCal, format: .number)
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
                        DatePicker("End Time", selection: $sample.end, displayedComponents: .hourAndMinute)
                    }
                }
            }
        }
        .navigationTitle("Edit Sample")
        .navigationBarItems(trailing: Button(action: {
            //Fix update here and in the other view so that you dant have two samples
            self.samples.update(sample: sample)
        }) {
            Image(systemName: "plus")
            Text("Update Sample")
        })
    }
}

struct FinishSamplesView: View {
    @EnvironmentObject var samples: Samples
    @State var sample: Sample
    @FocusState var isActive : Bool

    
    var body: some View{
        NavigationView{
            Form{
                Section{
                    VStack{
                        Text(sample.name)
                        Text(sample.chemical.chemical)
                    }
                }
                Section{
                    HStack {
                        Text("Results From Lab (mg/m^3")
                        TextField("Results", value: $sample.lab, format: .number)
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
                }
            }
        }
        .navigationTitle("Finish Sample")
        .navigationBarItems(trailing: Button(action: {
            //Fix update here and in the other view so that you dant have two samples
            self.samples.update(sample: sample)
        }) {
            Image(systemName: "plus")
            Text("Update Sample")
        })
    }
}

struct SamplesHistoryView: View {
    @EnvironmentObject var samples: Samples
    @State var sample: Sample
    
    
    var body: some View {
        NavigationView {
            VStack {
                Form {
                    Section {
                        VStack {
                            let diffComponents = Calendar.current.dateComponents([.minute], from: sample.start, to: sample.end)
                            Text("Sample Duration:")
                                .fontWeight(.bold)
                            Text("\(diffComponents.minute!)")
                        }
                        VStack {
                            Text("Sample Target:")
                                .fontWeight(.bold)
                            Text(sample.chemical.chemical)
                        }
                        VStack {
                            Text("Results (mg/m^3): ")
                                .fontWeight(.bold)
                            Text("\(sample.lab)")
                        }
                        VStack{
                            Text("Permissible Exposure Limit")
                                .fontWeight(.bold)
                            Text(sample.chemical.chemical)
                        }
                    }
                }
            }
        }
        .navigationTitle(sample.name)
    }
}

struct SamplesView: View {
    enum FilterType {
        case new, open, complete
    }
    @State private var isPresented = false
    
    @EnvironmentObject var samples: Samples
    let filter: FilterType
    
    var title: String{
        switch filter{
        case.new:
            return "New Sample"
        case.open:
            return "Open Samples"
        case.complete:
            return "Sample History"
        }
    }
    
    var filteredSamples: [Sample] {
        switch filter {
        case.new:
            return samples.tests.filter {!$0.isStopped && !$0.isCompleted}
        case.open:
            return samples.tests.filter {$0.isStopped && !$0.isCompleted}
        case.complete:
            return samples.tests.filter {$0.isStopped && $0.isCompleted}
        }
    }
    
    var body: some View {
        NavigationView{
            List{
                ForEach(filteredSamples) { sample in
                    switch filter {
                    case.new:
                        NavigationLink(destination: OpenSamplesView(sample: sample)){
                            VStack(alignment: .leading) {
                                Text(sample.name)
                                    .font(.headline)
                                Text(sample.chemical.chemical)
                                    .foregroundColor(.secondary)
                            }
                        }
                    case.open:
                        NavigationLink(destination: FinishSamplesView(sample: sample)){
                            VStack(alignment: .leading) {
                                Text(sample.name)
                                    .font(.headline)
                                Text(sample.chemical.chemical)
                                    .foregroundColor(.secondary)
                            }
                        }
                    case.complete:
                        NavigationLink(destination: SamplesHistoryView(sample: sample)){
                            VStack(alignment: .leading) {
                                Text(sample.name)
                                    .font(.headline)
                                Text(sample.chemical.chemical)
                                    .foregroundColor(.secondary)
                            }
                        }
                    }
                }
                .onDelete(perform: self.samples.removeItems)
            }
            .navigationTitle(title)
            .navigationBarItems(trailing: Button("New Sample"){
                self.isPresented.toggle()
            }
            .fullScreenCover(isPresented: $isPresented){
                NewSampleView()
            })
        }
    }
}

struct SamplesView_Previews: PreviewProvider {
    static var previews: some View {
        SamplesView(filter: .open)
    }
}
