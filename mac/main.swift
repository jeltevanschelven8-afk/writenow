// WriteNow — a small native macOS wrapper that shows index.html in its own window.
import Cocoa
import WebKit

// Serves index.html under writenow://app/ so that saved documents (localStorage)
// belong to a stable web origin; WKWebView does not reliably keep them for file:// pages.
final class PageSchemeHandler: NSObject, WKURLSchemeHandler {
    func webView(_ webView: WKWebView, start urlSchemeTask: WKURLSchemeTask) {
        guard let file = Bundle.main.url(forResource: "index", withExtension: "html"),
              let data = try? Data(contentsOf: file),
              let url = urlSchemeTask.request.url else {
            urlSchemeTask.didFailWithError(NSError(domain: NSURLErrorDomain, code: NSURLErrorFileDoesNotExist))
            return
        }
        let response = URLResponse(url: url, mimeType: "text/html", expectedContentLength: data.count, textEncodingName: "utf-8")
        urlSchemeTask.didReceive(response)
        urlSchemeTask.didReceive(data)
        urlSchemeTask.didFinish()
    }

    func webView(_ webView: WKWebView, stop urlSchemeTask: WKURLSchemeTask) {}
}

final class AppDelegate: NSObject, NSApplicationDelegate, WKUIDelegate, WKNavigationDelegate, WKScriptMessageHandler {
    var window: NSWindow!
    var webView: WKWebView!
    var pageLoaded = false
    var pendingFiles: [URL] = []

    // PDFs opened from the Finder ("Open With" > WriteNow) arrive here,
    // possibly before the page has finished loading.
    func application(_ application: NSApplication, open urls: [URL]) {
        pendingFiles += urls
        deliverFiles()
    }

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        pageLoaded = true
        deliverFiles()
    }

    func deliverFiles() {
        guard pageLoaded, let webView = webView else { return }
        for url in pendingFiles {
            guard let data = try? Data(contentsOf: url) else { continue }
            // JSON-encode the file name so quotes, newlines and backslashes cannot break the script.
            guard let nameJSON = try? JSONEncoder().encode(url.lastPathComponent),
                  let name = String(data: nameJSON, encoding: .utf8) else { continue }
            webView.evaluateJavaScript("window.wnOpenPdf && window.wnOpenPdf(\(name),'\(data.base64EncodedString())')",
                                       completionHandler: nil)
        }
        pendingFiles.removeAll()
        window?.makeKeyAndOrderFront(nil)
    }

    func applicationDidFinishLaunching(_ notification: Notification) {
        let config = WKWebViewConfiguration()
        config.websiteDataStore = .default() // keeps saved documents between launches
        config.setURLSchemeHandler(PageSchemeHandler(), forURLScheme: "writenow")
        config.userContentController.add(self, name: "wnQuit") // File > Quit inside the page

        webView = WKWebView(frame: .zero, configuration: config)
        webView.uiDelegate = self
        webView.navigationDelegate = self

        window = NSWindow(
            contentRect: NSRect(x: 0, y: 0, width: 1100, height: 780),
            styleMask: [.titled, .closable, .miniaturizable, .resizable],
            backing: .buffered,
            defer: false
        )
        window.title = "WriteNow"
        window.contentView = webView
        window.minSize = NSSize(width: 520, height: 400)
        window.center()
        window.setFrameAutosaveName("WriteNowWindow")
        window.makeKeyAndOrderFront(nil)

        if let page = URL(string: "writenow://app/index.html") {
            webView.load(URLRequest(url: page))
        }
        NSApp.activate(ignoringOtherApps: true)
    }

    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        if message.name == "wnQuit" { NSApp.terminate(nil) }
    }

    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
        true
    }

    // Lets "Import Text File…" open the standard macOS file picker.
    func webView(_ webView: WKWebView,
                 runOpenPanelWith parameters: WKOpenPanelParameters,
                 initiatedByFrame frame: WKFrameInfo,
                 completionHandler: @escaping ([URL]?) -> Void) {
        let panel = NSOpenPanel()
        panel.allowsMultipleSelection = parameters.allowsMultipleSelection
        panel.canChooseDirectories = false
        panel.begin { result in
            completionHandler(result == .OK ? panel.urls : nil)
        }
    }
}

// A minimal native menu so Cmd+Q and the clipboard shortcuts work.
// Cmd+Z, Cmd+B, Cmd+S and the rest are left to the program's own menus.
func buildMainMenu() -> NSMenu {
    let main = NSMenu()

    let appItem = NSMenuItem()
    let appMenu = NSMenu()
    appMenu.addItem(withTitle: "About WriteNow",
                    action: #selector(NSApplication.orderFrontStandardAboutPanel(_:)),
                    keyEquivalent: "")
    appMenu.addItem(.separator())
    appMenu.addItem(withTitle: "Hide WriteNow", action: #selector(NSApplication.hide(_:)), keyEquivalent: "h")
    appMenu.addItem(.separator())
    appMenu.addItem(withTitle: "Quit WriteNow", action: #selector(NSApplication.terminate(_:)), keyEquivalent: "q")
    appItem.submenu = appMenu
    main.addItem(appItem)

    let editItem = NSMenuItem()
    let editMenu = NSMenu(title: "Edit")
    editMenu.addItem(withTitle: "Cut", action: #selector(NSText.cut(_:)), keyEquivalent: "x")
    editMenu.addItem(withTitle: "Copy", action: #selector(NSText.copy(_:)), keyEquivalent: "c")
    editMenu.addItem(withTitle: "Paste", action: #selector(NSText.paste(_:)), keyEquivalent: "v")
    editMenu.addItem(withTitle: "Select All", action: #selector(NSText.selectAll(_:)), keyEquivalent: "a")
    editItem.submenu = editMenu
    main.addItem(editItem)

    let windowItem = NSMenuItem()
    let windowMenu = NSMenu(title: "Window")
    windowMenu.addItem(withTitle: "Minimize", action: #selector(NSWindow.performMiniaturize(_:)), keyEquivalent: "m")
    windowMenu.addItem(withTitle: "Enter Full Screen", action: #selector(NSWindow.toggleFullScreen(_:)), keyEquivalent: "f")
    windowMenu.items.last?.keyEquivalentModifierMask = [.command, .control]
    windowItem.submenu = windowMenu
    main.addItem(windowItem)

    return main
}

let app = NSApplication.shared
let delegate = AppDelegate()
app.delegate = delegate
app.setActivationPolicy(.regular)
app.mainMenu = buildMainMenu()
app.run()
