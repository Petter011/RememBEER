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
    @State private var beerPointsOptions: [Int16] = Array(0...10)
    @State private var showingImagePicker = false
    @State private var beerImageData: Data?
    @State private var selectedImages: [UIImage] = []
    @State private var editedBeerName: String = ""
    @State private var editedWho: String = ""
    @State private var editedPoints: Int16 = 0
    @State private var editedBeerNote: String = ""
    @State private var editedBeerType: String = ""
    
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                Group {
                    
                    
                    /*TextField("Vilken sort", text: $editedBeerType)
                        .textFieldStyle(.roundedBorder)
                        .keyboardType(.default)*/
                    
                    TextField("Name of the beer", text: $editedBeerName)
                        .textFieldStyle(.roundedBorder)
                        .keyboardType(.default)
                    
                    TextField("Add a Note", text: $editedBeerNote, axis: .vertical)
                        .textFieldStyle(.roundedBorder)
                        .keyboardType(.default)
                        .lineLimit(3, reservesSpace: true)
                    
                    VStack{
                        VStack(alignment: .center) {
                            Text("Points (0-10)")
                                .bold()
                                .foregroundColor(Color.black)
                                .underline()
                            Picker("Points (0-10)", selection: $editedPoints) {
                                ForEach(beerPointsOptions, id: \.self) {
                                    Text("\($0)")
                                    
                                }
                            }
                            
                            .pickerStyle(.wheel)
                            .onAppear {
                                editedPoints = 5
                            }
                        }
                        
                    }
                }
                .padding(.horizontal)
                
                if !selectedImages.isEmpty {
                    VStack(spacing: 100) {
                        ForEach(selectedImages, id: \.self) { image in
                            Image(uiImage: image)
                                .resizable()
                                .scaledToFit()
                                .frame(maxWidth: .infinity, alignment: .center)
                            
                        }
                    }
                }
                
                /*Button("Take a picture") {
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
                    beer.score = editedPoints
                    beer.note = editedBeerNote

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
            .onTapGesture {
                self.endEditing()
            }
        }
    }
}

/*#Preview {
    EditBeerView()
}
*/
