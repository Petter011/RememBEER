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
    @EnvironmentObject var beerManager: BeerManager
    @ObservedObject var viewModel: BeerViewModel
    var beer: Beer // Pass the selected beer to edit

    @State private var beerPointsOptions: [Int16] = Array(0...10)
    @State private var showingImagePicker = false
    @State private var editedBeerImageData: Data?
    @State private var editedselectedImages: [UIImage] = []
    @State private var editedBeerName: String = ""
    @State private var editedBeerPoints: Int16 = 0
    @State private var editedBeerNote: String = ""
    @State private var editedBeerType: String = ""
    @State private var showError = false
    
    init(isShowingEditView: Binding<Bool>, viewModel: BeerViewModel, beer: Beer) {
        _isShowingEditView = isShowingEditView
        self.viewModel = viewModel
        self.beer = beer
        _editedBeerName = State(initialValue: beer.name!)
        _editedBeerPoints = State(initialValue: beer.score)
        _editedBeerNote = State(initialValue: beer.note!)
        //_editedBeerType = State(initialValue: beer.beerType!.name!)
    }

    
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                Group {
                    
                    
                    /*TextField("Which type of beer? e.g. IPA, APA", text: $editedBeerType)
                        .textFieldStyle(.roundedBorder)
                        .keyboardType(.default)*/
                    
                    TextField("Name of the beer?", text: $editedBeerName)
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
                            Picker("Points (0-10)", selection: $editedBeerPoints) {
                                ForEach(beerPointsOptions, id: \.self) {
                                    Text("\($0)")
                                    
                                }
                            }
                            
                            .pickerStyle(.wheel)
                            .onAppear {
                                editedBeerPoints = beer.score
                            }
                        }
                        
                    }
                }
                .padding(.horizontal)
                
                /*if !editedselectedImages.isEmpty {
                    VStack(spacing: 100) {
                        ForEach(editedselectedImages, id: \.self) { image in
                            Image(uiImage: image)
                                .resizable()
                                .scaledToFit()
                                .cornerRadius(10)
                                .frame(maxWidth: .infinity, alignment: .center)
                            
                        }
                    }
                }*/
                
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
                    ImagePicker(selectedImages: $editedselectedImages, sourceType: .camera) // Pass the array binding
                }*/
                Spacer()
                
                Button("Save") {
                    beer.name = editedBeerName
                    beer.score = editedBeerPoints
                    beer.note = editedBeerNote
                    //beer.beerType!.name! = editedBeerType
                    do {
                        try moc.save()
                        isShowingEditView = false
                    } catch {
                        print("Error saving edited beer: \(error)")
                    }
                }
                .font(.headline)
                .foregroundColor(.black)
                .frame(maxWidth: 150, maxHeight: 60)
                .background(Color.orange)
                .cornerRadius(40)
                .shadow(color: .orange , radius: 5, y: 3)
            }
            .ignoresSafeArea(.keyboard)
            .navigationBarTitle("Edit beer", displayMode: .inline)
            .onTapGesture {
                self.endEditing()
            }
            /*.alert(isPresented: $showError) {
                Alert(
                    title: Text("Error"),
                    message: Text("Please take a picture before saving."),
                    dismissButton: .default(Text("OK"))
                )
            }*/
        }
    }
}

/*#Preview {
    EditBeerView()
}
*/
