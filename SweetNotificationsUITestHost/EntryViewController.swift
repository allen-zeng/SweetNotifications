import UIKit

class EntryViewController: UIViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let vc = segue.destination as? ViewController else {
            fatalError("destinationViewController needs to be ViewController")
        }

        switch segue.identifier {
        case "will show"?:
            vc.test = .willShow
        case "did show"?:
            vc.test = .didShow
        case "will hide"?:
            vc.test = .willHide
        case "did hide"?:
            vc.test = .didHide
        default:
            fatalError("Unknown segue identifier \(segue.identifier!)")
        }
    }
}
