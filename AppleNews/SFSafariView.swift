import SwiftUI
import SafariServices

struct SafariView: UIViewControllerRepresentable {

    let url: URL
    
    init(url:URL){
        self.url = url
    }

    func makeUIViewController(context: UIViewControllerRepresentableContext<SafariView>) -> SFSafariViewController {
        return SFSafariViewController(url: url,entersReaderIfAvailable: true)
    }

    func updateUIViewController(_ uiViewController: SFSafariViewController, context: UIViewControllerRepresentableContext<SafariView>) {
        
    }

}
