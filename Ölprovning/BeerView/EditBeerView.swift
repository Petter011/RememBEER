//
//  EditBeerView.swift
//  Ölprovning
//
//  Created by Petter Gustafsson on 2023-10-26.
//

import SwiftUI
import CoreData

struct EditBeerView: View {
    
    @Binding var isShowingEditView: Bool
    @Environment(\.managedObjectContext) private var moc
    @EnvironmentObject var beerManager: BeerManager
    @ObservedObject var viewModel: BeerViewModel
    var beer: Beer // Pass the selected beer to edit
    var beerType: BeerType
    
    
    @FetchRequest(sortDescriptors: [NSSortDescriptor(key: "name", ascending: true)]) var beerTypes: FetchedResults<BeerType>
    @Environment(\.presentationMode) var presentationMode
    
    @State private var beerPointsOptions: [Int16] = Array(0...10)
    @State private var showingImagePicker = false
    @State private var editedBeerImageData: Data?
    @State private var editedselectedImages: [UIImage] = []
    @State private var editedBeerName: String = ""
    @State private var editedBeerPoints: Int16 = 0
    @State private var editedBeerNote: String = ""
    @State private var editedBeerType: String = ""
    @State private var showError = false
    
    init(isShowingEditView: Binding<Bool>, viewModel: BeerViewModel, beer: Beer, beerType: BeerType) {
        _isShowingEditView = isShowingEditView
        self.viewModel = viewModel
        self.beer = beer
        self.beerType = beerType
        _editedBeerName = State(initialValue: beer.name!)
        _editedBeerPoints = State(initialValue: beer.score)
        _editedBeerNote = State(initialValue: beer.note!)
        _editedBeerType = State(initialValue: (beer.beerType?.name!)!)
    }
    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                Group {
                    TextField("Which type of beer? e.g. IPA, APA", text: $editedBeerType)
                        .textFieldStyle(.roundedBorder)
                        .keyboardType(.default)
                        .onReceive(NotificationCenter.default.publisher(for: UIResponder.keyboardDidHideNotification)) { _ in
                            editedBeerType = editedBeerType.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
                        }
                    
                    TextField("Name of the beer?", text: $editedBeerName)
                        .textFieldStyle(.roundedBorder)
                        .keyboardType(.default)
                        .padding(.top, 30)
                    TextField("Add a Note", text: $editedBeerNote, axis: .vertical)
                        .textFieldStyle(.roundedBorder)
                        .keyboardType(.default)
                        .lineLimit(3, reservesSpace: true)
                        .padding(.top, 10)
                    
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
                    .padding(.top, 30)
                }
                .padding(.horizontal)
                
                /*if let selectedImage = editedselectedImages.last {
                 Image(uiImage: selectedImage)
                 .resizable()
                 .scaledToFit()
                 .cornerRadius(10)
                 .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                 
                 }
                 
                 Button("Take a picture") {
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
                 ImagePicker(selectedImages: $editedselectedImages, sourceType: .camera)
                 }*/
                Spacer()
                
                Button {
                    // Fetch existing beer type with the entered name
                    let fetchRequest: NSFetchRequest<BeerType> = BeerType.fetchRequest()
                    fetchRequest.predicate = NSPredicate(format: "name LIKE %@", editedBeerType)
                    fetchRequest.fetchLimit = 1

                    do {
                        let existingTypes = try moc.fetch(fetchRequest)

                        if let existingType = existingTypes.first {
                            // Check the current count of beers in the beer type
                            //let currentBeerCount = existingType.beers?.count ?? 0

                            // Associate the beer with the existing beer type
                            beer.name = editedBeerName
                            beer.score = editedBeerPoints
                            beer.note = editedBeerNote
                            beer.beerType = existingType

                            try moc.save()
                            
                        } else {
                            // Create a new beer type
                            let newType = BeerType(context: moc)
                            newType.id = UUID()
                            newType.name = editedBeerType
                            newType.isScanned = false
                            newType.beers = []
                            beer.name = editedBeerName
                            beer.score = editedBeerPoints
                            beer.note = editedBeerNote
                            beer.beerType = newType

                            try moc.save()
                        }
                        
                        // Check if the beer type is now empty and delete it
                        if let beers = beerType.beers as? Set<Beer>, beers.count == 0 {
                            moc.delete(beerType)
                        }
                        try moc.save()
                        
                    } catch {
                        print("Error saving edited beer: \(error)")
                    }
                    let beers = beerType.beers as? Set<Beer>
                    if beers == nil || beers!.isEmpty {
                        presentationMode.wrappedValue.dismiss()
                    }
                    // Dismiss the view
                    isShowingEditView = false
                } label: {
                    Text("Save")
                        .font(.headline)
                        .fontWeight(.bold)
                        .foregroundColor(.black)
                        .frame(maxWidth: 200, maxHeight: 60)
                    
                }
                .background(Color.orange)
                .cornerRadius(40)
                .shadow(color: .orange, radius: 5, y: 3)
                .overlay(RoundedRectangle(cornerRadius: 40).stroke(Color.black, lineWidth: 1))
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
