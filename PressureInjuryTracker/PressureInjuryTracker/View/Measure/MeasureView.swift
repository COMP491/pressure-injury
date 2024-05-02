//
//  MeasureView.swift
//  PressureInjuryTracker
//
//  Created by Ahmet BAKÇACI on 1.05.2024.
//

import SwiftUI
import ARKit

struct ARMeterView: UIViewRepresentable {
    static var sharedARView = ARSCNView()
    private var coordinator: Coordinator
    
    @Binding var measurement: String
    
    init(measurement: Binding<String>) {
        self._measurement = measurement
        coordinator = Coordinator(measurement: measurement)
    }

    func makeUIView(context: Context) -> ARSCNView {
        let arView = ARMeterView.sharedARView
        let scene = SCNScene()
        arView.scene = scene
        arView.autoenablesDefaultLighting = true
        return arView
    }

    func updateUIView(_ uiView: ARSCNView, context: Context) {
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = [.horizontal]
        uiView.session.run(configuration)

        // Add tap gesture recognizer
        let tapGesture = UITapGestureRecognizer(target: context.coordinator, action: #selector(context.coordinator.handleTap(_:)))
        uiView.addGestureRecognizer(tapGesture)
    }

    func makeCoordinator() -> Coordinator {
        return self.coordinator
    }
    
    func clearScene() {
        coordinator.clearScene()
    }

    class Coordinator: NSObject, ARSCNViewDelegate {
        var startNode: SCNNode?
        var markerNode: SCNNode?
        
        @Binding var measurement: String
        
        init(measurement: Binding<String>) {
            self._measurement = measurement
        }

        @objc func handleTap(_ gesture: UITapGestureRecognizer) {
            guard let arView = gesture.view as? ARSCNView else { return }
            let touchLocation = gesture.location(in: arView)
            let hitTestResults = arView.hitTest(touchLocation, types: .featurePoint)

            guard let hitTestResult = hitTestResults.first else { return }
            let hitTransform = hitTestResult.worldTransform
            let hitVector = SCNVector3(hitTransform.columns.3.x, hitTransform.columns.3.y, hitTransform.columns.3.z)

            if startNode == nil {
                startNode = createNode(at: hitVector)
                addMarker(at: hitVector)
            } else {
                let endNode = createNode(at: hitVector)
                if let startNode = startNode, let endNode = endNode {
                    let distance = startNode.position.distance(to: endNode.position)
                    displayDistance(distance, between: startNode.position, and: endNode.position)
                }
                startNode = nil
                addMarker(at: hitVector)
            }
        }

        func createNode(at position: SCNVector3) -> SCNNode? {
            let sphere = SCNSphere(radius: 0.005)
            sphere.firstMaterial?.diffuse.contents = UIColor.red
            let node = SCNNode(geometry: sphere)
            node.position = position
            return node
        }

        func displayDistance(_ distance: Float, between startPosition: SCNVector3, and endPosition: SCNVector3) {
            let line = SCNGeometry.line(start: startPosition, end: endPosition)
            let lineNode = SCNNode(geometry: line)
            lineNode.position = SCNVector3Zero
            lineNode.geometry?.firstMaterial?.diffuse.contents = UIColor.green
            lineNode.geometry?.firstMaterial?.isDoubleSided = true
            lineNode.geometry?.firstMaterial?.transparency = 1
            lineNode.geometry?.firstMaterial?.lightingModel = .constant
            ARMeterView.sharedARView.scene.rootNode.addChildNode(lineNode)

            let measurement = distance * 100
            NotificationCenter.default.post(name: Notification.Name("MeasurementUpdated"), object: measurement)
            self.measurement = String(format: "%.2f", measurement)
        }
        
        func addMarker(at position: SCNVector3) {
            let marker = SCNSphere(radius: 0.005)
            marker.firstMaterial?.diffuse.contents = UIColor.blue
            markerNode = SCNNode(geometry: marker)
            markerNode?.position = position
            ARMeterView.sharedARView.scene.rootNode.addChildNode(markerNode!)
        }
        
        func clearScene() {
            startNode = nil
            ARMeterView.sharedARView.scene.rootNode.childNodes.forEach { $0.removeFromParentNode() }
        }
    }
}

extension SCNGeometry {
    static func line(start: SCNVector3, end: SCNVector3) -> SCNGeometry {
        let sources = SCNGeometrySource(vertices: [start, end])
        let indices: [Int32] = [0, 1]
        let elements = SCNGeometryElement(indices: indices, primitiveType: .line)
        return SCNGeometry(sources: [sources], elements: [elements])
    }
}

extension SCNVector3 {
    func distance(to vector: SCNVector3) -> Float {
        let dx = vector.x - x
        let dy = vector.y - y
        let dz = vector.z - z
        return sqrt(dx*dx + dy*dy + dz*dz)
    }
}

struct MeasureView: View {
    @Binding var measurement: String
    @Binding var measuring: Bool
    
    var arMeterView: ARMeterView
    
    @State var old_measurement: String
    
    init(measurement: Binding<String>, measuring: Binding<Bool>) {
        self._measurement = measurement
        self.arMeterView = ARMeterView(measurement: measurement)
        self._measuring = measuring
        self._old_measurement = State(initialValue: measurement.wrappedValue)
    }

    var body: some View {
        VStack {
            ARMeterView(measurement: $measurement)
                .edgesIgnoringSafeArea(.all)
            
            if measurement != "" {
                Text("Ölçüm: " + measurement + " cm")
                    .padding()
                    .onReceive(NotificationCenter.default.publisher(for: Notification.Name("MeasurementUpdated"))) { notification in
                        if let measurement = notification.object as? Float {
                            self.measurement = String(format: "%.2f", measurement)
                            print(measurement)
                        }
                    }
            } else {
                Text("2 nokta seçin")
            }
            
            HStack {
                Button("Onayla") {
                    measuring = false
                }
                .padding(8)
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(10)
                
                Button("Temizle") {
                    arMeterView.clearScene()
                    measurement = "0"
                }
                .padding(8)
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(10)
                
                Button("İptal") {
                    measurement = old_measurement
                    measuring = false
                }
                .padding(8)
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(10)
            }
        }
    }
}
