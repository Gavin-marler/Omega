//
//  SamplesView.swift
//  Omega
//
//  Created by Gavin Marler on 11/5/21.
//

import SwiftUI

struct SamplesView: View {
    enum FilterType {
        case new, open, complete
    }
    
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
                    VStack(alignment: .leading) {
                        Text(sample.name)
                            .font(.headline)
                        Text(sample.location)
                            .foregroundColor(.secondary)
                    }
                }
            }
            .navigationTitle(title)
            .navigationBarItems(trailing: Button(action: {
                let sample = Sample()
                sample.name = "Chemical"
                sample.location = "Warehouse"
                sample.date = "Today"
                self.samples.add(sample: sample)
            }) {
                Image(systemName: "plus")
                Text("Add Sample")
            })
        }
    }
}

struct SamplesView_Previews: PreviewProvider {
    static var previews: some View {
        SamplesView(filter: .open)
    }
}
