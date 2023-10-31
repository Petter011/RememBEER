//
//  EditBeerView.swift
//  Ölprovning
//
//  Created by Petter Gustafsson on 2023-10-26.
//

import SwiftUI

struct EditBeerView: View {
    
    @Binding var isShowingEditView: Bool
    @Environment(\.managedObjectContext) private var moc
    
    @ObservedObject var viewModel: BeerViewModel
    var beer: Beer // Pass the selected beer to edit
    @State private var beerPointsOptions: [Int16] = Array(0...100)
    
    @State private var editedBeerName: String = ""
    @State private var editedWho: String = ""
    @State private var editedPoints: Int16 = 0
    
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                Group {
                    
                    
                    /*TextField("Vilken sort", text: $beerType)
                        .textFieldStyle(.roundedBorder)
                        .keyboardType(.default)*/
                    
                    TextField("Name of the beer", text: $editedBeerName)
                        .textFieldStyle(.roundedBorder)
                        .keyboardType(.default)
                    
                      /*VStack{
                        VStack(alignment: .center) {
                            Text("Vems öl")
                                .bold()
                                .foregroundColor(Color.black)
                                .underline()
                            
                            
                            Picker("Vems öl", selection: $editedWho) {
                                ForEach(globalParticipantNames, id: \.self) {
                                    Text($0)
                                }
                            }
                            .pickerStyle(.wheel)
                            
                        }
                    }*/
                    
                    
                    VStack{
                        VStack(alignment: .center) {
                            Text("Poins (0-100)")
                                .bold()
                                .foregroundColor(Color.black)
                                .underline()
                            Picker("Poions (0-100)", selection: $editedPoints) {
                                ForEach(beerPointsOptions, id: \.self) {
                                    if $0 != 50 {
                                        Text("\($0)")
                                    }
                                }
                            }
                            
                            .pickerStyle(.wheel)
                            .onAppear {
                                // Set the initial value to 51
                                editedPoints = 51
                            }
                        }
                        
                    }
                }
                .padding(.horizontal)
                
               /* if !selectedImages.isEmpty {
                    VStack(spacing: 100) {
                        ForEach(selectedImages, id: \.self) { image in
                            Image(uiImage: image)
                                .resizable()
                                .scaledToFit()
                                .frame(maxWidth: .infinity, alignment: .center)
                            
                        }
                    }
                }*/
                
               /* Button("Ta till bild på ölen") {
                    showingImagePicker.toggle()
                }
                .font(.headline)
                .foregroundColor(.white)
                .frame(maxWidth: 140)
                .padding()
                .background(Color.orange)
                .cornerRadius(20)
                .shadow(radius: 40)
                .sheet(isPresented: $showingImagePicker) {
                    ImagePicker(selectedImages: $selectedImages, sourceType: .camera) // Pass the array binding
                }*/
                
                Button("Save") {
                    // Update the selected beer's attributes with the edited values
                    beer.name = editedBeerName
                    beer.who = editedWho
                    beer.score = editedPoints

                    // Save the changes
                    do {
                        try moc.save()
                        isShowingEditView = false
                    } catch {
                        print("Error saving edited beer: \(error)")
                    }
                }

                .font(.headline)
                .foregroundColor(.black)
                .frame(maxWidth: 140)
                .padding()
                .background(Color.orange)
                .cornerRadius(20)
                .shadow(radius: 40)
            }
            .ignoresSafeArea(.keyboard)
            .navigationBarTitle("Edit beer", displayMode: .inline)
        }
    }
}

/*#Preview {
    EditBeerView()
}
*/
