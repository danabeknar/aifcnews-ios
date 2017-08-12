//
//  ShareManager.swift
//  aifcnews
//
//  Created by Beknar Danabek on 7/25/17.
//  Copyright © 2017 nFactorial Incubator. All rights reserved.
//

import Foundation
import MessageUI
import Social


struct Constant {
    
    static let appName = "AIFC News"
    static let appID = "id1258057171"
    static let reviewUrl = "https://itunes.apple.com/us/app/\(Constant.appID)?ls=1&mt=8&action=write-review"
    static let appUrl = "http://itunes.apple.com/app/\(Constant.appID)"
    static let companyMail = "beknar.danabek@gmail.com"
    
}

class ShareManager: NSObject, UIDocumentInteractionControllerDelegate {
    
    // MARK: Properties
    
    static let shared = ShareManager()
    var documentInteractionController = UIDocumentInteractionController()
    
    // MARK: App Store Rate
    
    func appStoreRate() {
        guard let url = URL(string : "https://itunes.apple.com/us/app/\(Constant.appID)?ls=1&mt=8&action=write-review") else { return }
        guard #available(iOS 10, *) else {
            UIApplication.shared.openURL(url)
            return
        }
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
    
    // MARK: Email Sending
    
    func mailFeedback(at vc: UIViewController) {
        let mailComposeViewController = configuredMailComposeViewController()
        if MFMailComposeViewController.canSendMail() {
            vc.present(mailComposeViewController, animated: true, completion: nil)
        } else {
            showSendMailErrorAlert(at: vc)
        }
    }
    
    func configuredMailComposeViewController() -> MFMailComposeViewController {
        let mailComposerVC = MFMailComposeViewController()
        mailComposerVC.mailComposeDelegate = self
        mailComposerVC.setToRecipients([Constant.companyMail])
        mailComposerVC.setSubject(Constant.appName)
        return mailComposerVC
    }
    
    func showSendMailErrorAlert(at vc: UIViewController) {
        let actionSheetController: UIAlertController = UIAlertController(title: "Could Not Send Email", message: "Your device could not send e-mail.  Please check e-mail configuration and try again.", preferredStyle: .alert)
        let cancelAction: UIAlertAction = UIAlertAction(title: "Cancel", style: .cancel) { action -> Void in
            actionSheetController.dismiss(animated: true, completion: nil)
        }
        actionSheetController.addAction(cancelAction)
        vc.present(actionSheetController, animated: true, completion: nil)
    }
    
    // MARK: Social Network Sharing
    
    func facebookShare(at vc: UIViewController) {
        let facebookVC = SLComposeViewController(forServiceType:SLServiceTypeFacebook)
        facebookVC?.add(URL(string: Constant.appUrl))
        facebookVC?.add(UIImage(named: "commercial.png")!)
        vc.present(facebookVC!, animated: true, completion: nil)
    }
    
    func instagramShare(at vc: UIViewController) {
        postImageToInstagramWithCaption(imageInstagram: UIImage(named: "commercial.png")!, instagramCaption: "some caption", view: vc.view, delegate: vc)
    }
    
    
    func share(at vc: UIViewController) {
        let    message = "Download this application to be aware of economic news! \(Constant.appUrl)"
        let activityVC = UIActivityViewController(activityItems: [message], applicationActivities: nil)
        activityVC.excludedActivityTypes = [.airDrop,
                                            .addToReadingList,
                                            .message,
                                            .mail,
                                            UIActivityType(rawValue: "com.apple.mobilenotes.SharingExtension"),
                                            UIActivityType(rawValue: "com.google.GooglePlus.ShareExtension"),
                                            UIActivityType(rawValue: "com.apple.reminders.RemindersEditorExtension")]
        activityVC.popoverPresentationController?.sourceView = UIView()
        vc.present(activityVC, animated: true, completion: nil)
    }
    
    func postImageToInstagramWithCaption(imageInstagram: UIImage, instagramCaption: String, view: UIView, delegate: UIViewController) {
        let instagramURL = NSURL(string: "instagram://app")
        if UIApplication.shared.canOpenURL(instagramURL! as URL) {
            let jpgPath = (NSTemporaryDirectory() as NSString).appendingPathComponent("instagram.igo")
            
            do {
                try UIImageJPEGRepresentation(imageInstagram, 1.0)?.write(to: URL(fileURLWithPath: jpgPath), options: .atomic)
            } catch {
                print(error)
            }
            
            let rect = CGRect(x: 0, y: 0, width: 612, height: 612)
            let fileURL = NSURL.fileURL(withPath: jpgPath)
            documentInteractionController.url = fileURL
            documentInteractionController.delegate = delegate as? UIDocumentInteractionControllerDelegate
            documentInteractionController.uti = "com.instagram.exclusivegram"
            
            // adding caption for the image
            documentInteractionController.annotation = ["InstagramCaption": instagramCaption]
            documentInteractionController.presentOpenInMenu(from: rect, in: view, animated: true)
        } else {
            /// Like: UIAlertController(title: kAlertViewTitle, message: kAlertViewMessage, preferredStyle: .alert)
        }
    }
}

// MARK: MFMailComposeViewControllerDelegate

extension ShareManager: MFMailComposeViewControllerDelegate {
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
}


