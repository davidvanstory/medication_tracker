import SwiftUI
import Combine

@MainActor
class ResultsViewModel: ObservableObject {
    @Published var prescription: Prescription
    @Published var showingChat = false
    @Published var expandedSections: Set<String> = ["explanation"]
    
    init(prescription: Prescription) {
        self.prescription = prescription
    }
    
    func toggleSection(_ section: String) {
        if expandedSections.contains(section) {
            expandedSections.remove(section)
        } else {
            expandedSections.insert(section)
        }
    }
    
    func isSectionExpanded(_ section: String) -> Bool {
        expandedSections.contains(section)
    }
    
    func openChat() {
        showingChat = true
    }
}