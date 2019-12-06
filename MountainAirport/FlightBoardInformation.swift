/// Copyright (c) 2019 Razeware LLC
/// 
/// Permission is hereby granted, free of charge, to any person obtaining a copy
/// of this software and associated documentation files (the "Software"), to deal
/// in the Software without restriction, including without limitation the rights
/// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
/// copies of the Software, and to permit persons to whom the Software is
/// furnished to do so, subject to the following conditions:
/// 
/// The above copyright notice and this permission notice shall be included in
/// all copies or substantial portions of the Software.
/// 
/// Notwithstanding the foregoing, you may not use, copy, modify, merge, publish,
/// distribute, sublicense, create a derivative work, and/or sell copies of the
/// Software in any work that is designed, intended, or marketed for pedagogical or
/// instructional purposes related to programming, coding, application development,
/// or information technology.  Permission for such use, copying, modification,
/// merger, publication, distribution, sublicensing, creation of derivative works,
/// or sale is expressly withheld.
/// 
/// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
/// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
/// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
/// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
/// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
/// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
/// THE SOFTWARE.

import SwiftUI

struct  ChekInInfo : Identifiable {
    let id = UUID()
    let airline : String
    let flight : String
    
}

struct FlightBoardInformation: View {
    
    var flight : FlightInformation
    @Binding var showModel : Bool
    @State var rebookAlert : Bool = false
    @State private var checkInFlight : ChekInInfo?
    
    var body: some View {
        VStack(alignment : .leading) {
            HStack {
                Text("\(flight.airline) Flight \(flight.number)")
                    .font(.largeTitle).lineLimit(2)
                Spacer()
                Button("Done" , action : {self.showModel.toggle()})

            }
                Text("\(flight.direction == .arrival ? "Form" : "To: ") \(flight.otherAirport)")
                Text(flight.flightStatus)
                    .foregroundColor(Color(flight.timelineColor))
                Spacer()
            
            if(flight.status == .cancelled) {
                
                Button("Rebook Flight" , action: {
                    self.rebookAlert = true
                })
                    
                    .alert(isPresented: $rebookAlert) {
                        Alert(title: Text("Contact your airlines") ,
                              message: Text("We cannot rebook this flight. Please contact the airline to reschedule this flight." ))
                }
                
            }
            
            if flight.direction == .departure && (flight.status == .ontime || flight.status == .delayed) {
               Button("Check in for flight" , action: {
                        self.checkInFlight = ChekInInfo(airline: self.flight.airline, flight: self.flight.number)
                })
                .actionSheet(item: $checkInFlight) {
                    flight in
                    ActionSheet(title: Text("Check In"), message: Text("Check in for \(flight.airline) Flight \(flight.flight)"),
                        buttons:  [
                        
                            .cancel(Text("Not Now")),
                            .destructive(Text("Reschedule"), action:  {
                                print("Reschudeling flght")
                            }),
                            .destructive(Text("Check In"), action: {
                                print("Check-in for \(flight.airline) \(flight.flight).")
                            })
                            
                        
                        
                        ])
                }
                              
                
            }
            
            }
            .font(.headline).padding(10)
        
    }
}

struct FlightBoardInformation_Previews: PreviewProvider {
    static var previews: some View {
        FlightBoardInformation(flight: FlightInformation.generateFlight(0), showModel: .constant(true))
    }
}
