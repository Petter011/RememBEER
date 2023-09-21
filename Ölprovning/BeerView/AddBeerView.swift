




import SwiftUI
import PhotosUI

struct AddBeerView: View {
    @State private var beerType: String = ""
    @State private var beerWho: String = ""
    @State private var beerName: String = ""
    @State private var beerPoints: Int16 = 0
    @State private var beerImageData: Data?
    @State private var selectedImages: [UIImage] = []
    @State private var showingImagePicker = false
    @State private var globalParticipantNames: [String] = UserDefaults.standard.stringArray(forKey: "participantNames") ?? []
    
    let onSave: (BeerWithImage, String) -> Void
    
    @Binding var selectedBeerType: String?
    @Binding var isPresented: Bool

    var body: some View {
        NavigationStack {
                VStack(spacing: 20) {
                    Group {
                        
                        
                        TextField("Vilken sort", text: $beerType)
                            .textFieldStyle(.roundedBorder)
                            .keyboardType(.default)
                            
                        TextField("Namn på ölen", text: $beerName)
                            .textFieldStyle(.roundedBorder)
                            .keyboardType(.default)
                        
                        VStack{
                            VStack(alignment: .center) {
                                Text("Vems öl")
                                    .bold()
                                    .foregroundColor(Color.black)
                                    .underline()
                                
                                
                                Picker("Vems öl", selection: $beerWho) {
                                    ForEach(globalParticipantNames, id: \.self) {
                                        Text($0)
                                    }
                                }
                                .pickerStyle(.wheel)
                                
                            }
                        }
                        
                        
                        VStack{
                            VStack(alignment: .center) {
                                Text("Poäng (0-100)")
                                    .bold()
                                    .foregroundColor(Color.black)
                                    .underline()
                                Picker("Poäng (0-100)", selection: $beerPoints) {
                                    ForEach(0..<101, id: \.self) { value in
                                        if value != 50 {
                                            Text("\(value)")
                                        }
                                    }
                                }
                                
                                .pickerStyle(.wheel) 
                                .onAppear {
                                    // Set the initial value to 51
                                    beerPoints = 51
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
                    
                    Button("Ta till bild på ölen") {
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
                    }

                    Button("Spara") {
                        if let firstImage = selectedImages.first,
                           let imageData = firstImage.jpegData(compressionQuality: 1.0) {
                            let newBeer = BeerWithImage(beerType: beerType, beerWho: beerWho, beerPoints: beerPoints, beerName: beerName, beerImageData: imageData)
                            
                            onSave(newBeer, beerType) // Call the onSave closure to save the new beer
                            isPresented = false // Close the sheet
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
                
                .navigationBarTitle("Lägg till ny öl", displayMode: .inline)
                
            
            }
            
        }
}



                               
                    
                    
  
