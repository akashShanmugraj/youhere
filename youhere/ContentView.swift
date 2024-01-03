//
//  ContentView.swift
//  youhere
//
//  Created by Akash Shanmugaraj on 03/01/24.
//

import SwiftUI
import CoreBluetooth

var displayText = "Status: Idle"
struct ContentView: View {
    @State private var isButtonActive = true
    
    private let bleManager = BLEManager()

    init() {
        bleManager.onPeripheralDiscovered = { peripheral in
            if peripheral.identifier.uuidString == "B4C2F7C8-CD1D-90A0-F035-BBB4753D4948" {
                displayText = "Found"
            }
        }
    }


    var body: some View {
        VStack {
            Text("You are logged in as Akash - 22z255")
                .font(.title)
                .fontWeight(.bold)
                .multilineTextAlignment(.center)
                .padding()

            if !displayText.isEmpty {
            Text(displayText)
                .italic()
                .fontWeight(.regular)
                .multilineTextAlignment(.center)
                .padding()
            }


            // Button
            Button(action: {
                buttonPressed()
            }, label: {
                Text("Ping Host")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .padding()
                    .background(isButtonActive ? Color.green : Color.gray)
                    .cornerRadius(10)
            })
            .disabled(!isButtonActive)

            Button(action: {
                buttonPressedAgain()
            }, label: {
                Text("Stop Pinging Host")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .padding()
                    .background(!isButtonActive ? Color.red : Color.gray)
                    .cornerRadius(10)
            })
            .disabled(isButtonActive)
        }
        .padding()
    }

    func buttonPressed() {
        // print something
        print("ButtonPressed")
        displayText = "Status: Pinging Host"
        isButtonActive = !isButtonActive
        bleManager.centralManager.scanForPeripherals(withServices: nil, options: nil)
    }
    
    func buttonPressedAgain() {
        // print something
        print("ButtonPressedAgain")
        displayText = "Status: IDLE"
        isButtonActive = !isButtonActive
    }
}


class BLEManager: NSObject, CBCentralManagerDelegate {
    var centralManager: CBCentralManager!
    var onPeripheralDiscovered: ((CBPeripheral) -> Void)?


    override init() {
        super.init()
        centralManager = CBCentralManager(delegate: self, queue: nil)
    }

    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        if central.state == .poweredOn {
            centralManager.scanForPeripherals(withServices: nil, options: nil)
        } else {
            print("Bluetooth is not available")
        }
    }

    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        print("Discovered \(peripheral.name ?? "a peripheral")")
        // print("UUID: \(peripheral.identifier.uuidString)")
        print("Advertisement Data: \(advertisementData)")
        print("\n")
}
    }


#Preview {
    ContentView()
}
