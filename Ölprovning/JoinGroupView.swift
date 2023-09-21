//
//  JoinGroupView.swift
//  Ölprovning
//
//  Created by Petter Gustafsson on 2023-08-28.
//

import SwiftUI
import CodeScanner

struct JoinGroupView: View {
    @State private var isShowingScanner = false
    
    func handleScan(result: Result<ScanResult, ScanError>) {
       isShowingScanner = false
        switch result {
        case .success(let result):
            let details = result.string
            

        case .failure(let error):
            print("Scanning failed: \(error.localizedDescription)")
        }
    }
    
    
    
    var body: some View {
        NavigationStack{
            
                
                VStack {
                    Text("Gå med i grupp")
                        .font(.largeTitle)
                        .foregroundColor(.orange)
                        .padding()
                    
                    Button("Scanna QRkod")
                    {
                        isShowingScanner = true
                    }
                    .font(.title)
                    .sheet(isPresented: $isShowingScanner){
                        CodeScannerView(codeTypes: [.qr], simulatedData: "Petter", completion: handleScan)
                    }
                    
                    
            }
        }
    }
}
            
