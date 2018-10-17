import Cocoa
import WebKit

class ViewController: NSViewController {
  @IBOutlet weak var webView: WKWebView!

  @IBAction func bundleLoadClicked(_ sender: NSButton) {
    guard let indexFile = Bundle.main.url(forResource: "bundle", withExtension: "html", subdirectory: nil) else {
      return
    }
    print("Loading demo.html from bundle, url: \(indexFile)")
    webView.loadFileURL(indexFile, allowingReadAccessTo: indexFile)
  }

  @IBAction func localLoadClicked(_ sender: NSButton) {
    let openPanel = NSOpenPanel()
    openPanel.allowedFileTypes = ["html", "htm"]
    openPanel.canChooseFiles = true
    openPanel.canChooseDirectories = false
    openPanel.allowsOtherFileTypes = false
    openPanel.allowsMultipleSelection = false

    let response = openPanel.runModal()
    guard response == .OK else {
      // user pressed cancel
      return
    }

    guard let fileURL = openPanel.url else {
      print("Failed to get file URL from OpenPanel url property.")
      return
    }

    print("Loading local file, url: \(fileURL)")
    webView.loadFileURL(fileURL, allowingReadAccessTo: fileURL.deletingLastPathComponent())
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    webView.navigationDelegate = self
  }
}

extension ViewController: WKNavigationDelegate {
  func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
    // You'll hit this if you load the bundle file, and then try to load a local file (outside the bundle directory).
    // You'll also hit this if you load a local file, and then try to load a different local file that is not in the same directory.
    print("Navigation failed with error: \(error)")
  }

}
