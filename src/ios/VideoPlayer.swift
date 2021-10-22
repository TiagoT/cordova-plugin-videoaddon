//
//  VideoPlayer.swift
//  VideoPlayer
//
//  Created by Andre Grillo on 28/09/2021.
//

import Foundation

@objc(VideoPlayer) class VideoPlayer: CDVPlugin {
    
    @objc(loadMindfullness:)
    func loadMindfullness(command: CDVInvokedUrlCommand) {
        var pluginResult = CDVPluginResult()
        
        if let videoArray = command.arguments[0] as? [String], let audioArray = command.arguments[1] as? [String], let audioVoiceURL = command.arguments[2] as? String, let subtitleURL = command.arguments[3] as? String, let secondsToSkip = command.arguments[4] as? Int, let isLiked = command.arguments[5] as? Bool {
            
            //MARK: LOAD BREATHWORK VIDEOS FORM URL
            let playerViewController = MindfulnessViewController()
            playerViewController.loadMindfullnessVideosFromURL(videoArray:  videoArray,
                                                             audioArray: audioArray,
                                                             audioVoiceURL: audioVoiceURL,
                                                             subtitleURL: subtitleURL,
                                                             secondsToSkip: secondsToSkip,
                                                             isLiked: isLiked)
            { watchedTime, isLiked in
//                playerViewController.dismiss(animated: false, completion: nil)
                let returnDictionary = ["watchedTime": watchedTime, "isLiked": isLiked]
                if let jsonData = try? JSONSerialization.data( withJSONObject: returnDictionary, options: .prettyPrinted),
                   let json = String(data: jsonData, encoding: String.Encoding.ascii) {
                    pluginResult = CDVPluginResult(status: CDVCommandStatus_OK, messageAs: json)
                    self.commandDelegate!.send(pluginResult, callbackId: command.callbackId)
                }
                else {
                    pluginResult = CDVPluginResult(status: CDVCommandStatus_ERROR, messageAs: "Error trying to serialize watchedTime and isLiked")
                    self.commandDelegate!.send(pluginResult, callbackId: command.callbackId)
                }
            }
            
            playerViewController.modalPresentationStyle = UIModalPresentationStyle.fullScreen
            self.viewController.present(playerViewController, animated: false, completion: nil)
            
            pluginResult!.setKeepCallbackAs(true)
            
        } else {
            pluginResult = CDVPluginResult(status: CDVCommandStatus_ERROR, messageAs: "Missing input parameters")
            self.commandDelegate!.send(pluginResult, callbackId: command.callbackId)
        }
        
    }

    @objc(loadBreathwork:)
    func loadBreathwork(command: CDVInvokedUrlCommand) {
        var pluginResult = CDVPluginResult()
        
        if let backgroundVideoURL = command.arguments[0] as? String, let audioArray = command.arguments[1] as? [String], let audioVoiceURL = command.arguments[2] as? String, let subtitleURL = command.arguments[3] as? String, let secondsToSkip = command.arguments[4] as? Int, let isLiked = command.arguments[5] as? Bool {
            
            //MARK: LOAD BREATHWORK VIDEOS FROM URL
            let playerViewController = MindfulnessViewController()
            playerViewController.loadBreathworkVideosFromURL(backgroundVideoURL:  backgroundVideoURL,
                                                             audioArray: audioArray,
                                                             audioVoiceURL: audioVoiceURL,
                                                             subtitleURL: subtitleURL,
                                                             secondsToSkip: secondsToSkip,
                                                             isLiked: isLiked)
            { watchedTime, isLiked in
//                playerViewController.dismiss(animated: false, completion: nil)
                let returnDictionary = ["watchedTime": watchedTime, "isLiked": isLiked]
                if let jsonData = try? JSONSerialization.data( withJSONObject: returnDictionary, options: .prettyPrinted),
                   let json = String(data: jsonData, encoding: String.Encoding.ascii) {
                    pluginResult = CDVPluginResult(status: CDVCommandStatus_OK, messageAs: json)
                    self.commandDelegate!.send(pluginResult, callbackId: command.callbackId)
                }
                else {
                    pluginResult = CDVPluginResult(status: CDVCommandStatus_ERROR, messageAs: "Error trying to serialize watchedTime and isLiked")
                    self.commandDelegate!.send(pluginResult, callbackId: command.callbackId)
                }
            }
            
            playerViewController.modalPresentationStyle = UIModalPresentationStyle.fullScreen
            self.viewController.present(playerViewController, animated: false, completion: nil)
            
            pluginResult!.setKeepCallbackAs(true)
            
        } else {
            pluginResult = CDVPluginResult(status: CDVCommandStatus_ERROR, messageAs: "Missing input parameters")
            self.commandDelegate!.send(pluginResult, callbackId: command.callbackId)
        }
    }

    @objc(loadDeskercises:)
    func loadDeskercises(command: CDVInvokedUrlCommand) {
        var pluginResult = CDVPluginResult()

        if let videoArrayURL = command.arguments[0] as? [String], let videoArrayTitle = command.arguments[1] as? [String], let liked = command.arguments[2] as? Bool {
            
            //MARK: LOAD DESKERCISES VIDEOS FROM URL
            let playerViewController = DeskercisesViewController()
            playerViewController.loadDeskercisesVideosFromURL(videoArray: videoArrayURL, videoTitleArray: videoArrayTitle, isLiked: liked, callback: { (isLiked) in
//                playerViewController.dismiss(animated: false, completion: nil)
                let returnDictionary = ["isLiked": isLiked]
                if let jsonData = try? JSONSerialization.data( withJSONObject: returnDictionary, options: .prettyPrinted),
                   let json = String(data: jsonData, encoding: String.Encoding.ascii) {
                    pluginResult = CDVPluginResult(status: CDVCommandStatus_OK, messageAs: json)
                    self.commandDelegate!.send(pluginResult, callbackId: command.callbackId)
                }
                else {
                    pluginResult = CDVPluginResult(status: CDVCommandStatus_ERROR, messageAs: "Error trying to serialize watchedTime and isLiked")
                    self.commandDelegate!.send(pluginResult, callbackId: command.callbackId)
                }
            })
            playerViewController.modalPresentationStyle = UIModalPresentationStyle.fullScreen
                        self.viewController.present(playerViewController, animated: false, completion: nil)

            pluginResult!.setKeepCallbackAs(true)
                        
        } else {
            pluginResult = CDVPluginResult(status: CDVCommandStatus_ERROR, messageAs: "Missing input parameters")
            self.commandDelegate!.send(pluginResult, callbackId: command.callbackId)
        }
    }
    
    @objc(loadMindfullnessVideosFromData:)
    func loadMindfullnessVideosFromData(command: CDVInvokedUrlCommand) {
        var pluginResult = CDVPluginResult()
//        let libraryDirectory2 = try! FileManager.default.url(for: .allLibrariesDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
        let libraryDirectory = try! FileManager.default.url(for: .libraryDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
        
        if let videoArray = command.arguments[0] as? [String], let audioArray = command.arguments[1] as? [String], let voice = command.arguments[2] as? String, let subtitle = command.arguments[3] as? String, let secondsToSkip = command.arguments[4] as? Int, let isLiked = command.arguments[5] as? Bool {
            
            var videoDataArray = [Data]()
            //Loads local Video files into array as Data Objects
            for video in videoArray {
                let videoURL: URL = {
                    var url: URL!
                        let videoPath = "file://\(libraryDirectory.path)" + "/NoCloud/Files/\(video)"
                            if let urlPath = URL(string: videoPath) {
                                url = urlPath
                            } else {
                                pluginResult = CDVPluginResult(status: CDVCommandStatus_ERROR, messageAs: "Error getting local directory path using \(video) as input")
                                self.commandDelegate!.send(pluginResult, callbackId: command.callbackId)
                            }
                    return url
                }()
                if FileManager.default.fileExists(atPath: videoURL.path){
                    do {
                        let videoData = try Data(contentsOf: videoURL)
                        videoDataArray.append(videoData)
                    } catch {
                        pluginResult = CDVPluginResult(status: CDVCommandStatus_ERROR, messageAs: "Local video file \(video) not found: \(error)")
                        self.commandDelegate!.send(pluginResult, callbackId: command.callbackId)
                    }
                }
            }
            
            var audioDataArray = [Data]()
            //Loads local audio files into array as Data Objects
            for audio in audioArray {
                let audioURL: URL = {
                    var url: URL!
                        let audioPath = "file://\(libraryDirectory.path)" + "/NoCloud/Files/\(audio)"
                            if let urlPath = URL(string: audioPath) {
                                url = urlPath
                            } else {
                                pluginResult = CDVPluginResult(status: CDVCommandStatus_ERROR, messageAs: "Error getting local directory path using \(audio) as input")
                                self.commandDelegate!.send(pluginResult, callbackId: command.callbackId)
                            }
                    return url
                }()
                if FileManager.default.fileExists(atPath: audioURL.path){
                    do {
                        let audioData = try Data(contentsOf: audioURL)
                        audioDataArray.append(audioData)
                    } catch {
                        print("Error: \(error)")
                        pluginResult = CDVPluginResult(status: CDVCommandStatus_ERROR, messageAs: "Local audio file \(audio) not found: \(error)")
                        self.commandDelegate!.send(pluginResult, callbackId: command.callbackId)
                    }
                }
            }
            
            var voiceData = Data()
            let audioVoiceURL: URL = {
                var url: URL!
                    let audioVoicePath = "file://\(libraryDirectory.path)" + "/NoCloud/Files/\(voice)"
                        if let urlPath = URL(string: audioVoicePath) {
                            url = urlPath
                        } else {
                            pluginResult = CDVPluginResult(status: CDVCommandStatus_ERROR, messageAs: "Error getting local directory path using \(voice) as input")
                            self.commandDelegate!.send(pluginResult, callbackId: command.callbackId)
                        }
                return url
            }()
            if FileManager.default.fileExists(atPath: audioVoiceURL.path){
                do {
                    voiceData = try Data(contentsOf: audioVoiceURL)
                } catch {
                    pluginResult = CDVPluginResult(status: CDVCommandStatus_ERROR, messageAs: "Local voice audio file \(voice) not found")
                    self.commandDelegate!.send(pluginResult, callbackId: command.callbackId)
                }
            }
            
            var subtitleData = Data()
            let subtitleURL: URL = {
                var url: URL!
                    let subtitlePath = "file://\(libraryDirectory.path)" + "/NoCloud/Files/\(subtitle)"
                        if let urlPath = URL(string: subtitlePath) {
                            url = urlPath
                        } else {
                            pluginResult = CDVPluginResult(status: CDVCommandStatus_ERROR, messageAs: "Error getting local directory path using \(subtitle) as input")
                            self.commandDelegate!.send(pluginResult, callbackId: command.callbackId)
                        }
                return url
                
            }()
            if FileManager.default.fileExists(atPath: subtitleURL.path){
                do {
                    subtitleData = try Data.init(contentsOf: subtitleURL)
                } catch {
                    pluginResult = CDVPluginResult(status: CDVCommandStatus_ERROR, messageAs: "Local subtitle file \(subtitle) not found")
                    self.commandDelegate!.send(pluginResult, callbackId: command.callbackId)
                }
            }
            
            let playerViewController = MindfulnessViewController()
            playerViewController.loadMindfullnessVideosFromData(videoArray:  videoDataArray,
                                                                audioArray: audioDataArray,
                                                                audioVoiceData: voiceData,
                                                                subtitleData: subtitleData,
                                                                secondsToSkip: secondsToSkip,
                                                                isLiked: isLiked)
            { watchedTime, isLiked in
//                playerViewController.dismiss(animated: false, completion: nil)
                let returnDictionary = ["watchedTime": watchedTime, "isLiked": isLiked]
                if let jsonData = try? JSONSerialization.data( withJSONObject: returnDictionary, options: .prettyPrinted),
                   let json = String(data: jsonData, encoding: String.Encoding.ascii) {
                    pluginResult = CDVPluginResult(status: CDVCommandStatus_OK, messageAs: json)
                    self.commandDelegate!.send(pluginResult, callbackId: command.callbackId)
                }
                else {
                    pluginResult = CDVPluginResult(status: CDVCommandStatus_ERROR, messageAs: "Error trying to serialize watchedTime and isLiked")
                    self.commandDelegate!.send(pluginResult, callbackId: command.callbackId)
                }
            }
            
            playerViewController.modalPresentationStyle = UIModalPresentationStyle.fullScreen
            self.viewController.present(playerViewController, animated: false, completion: nil)
            
            pluginResult!.setKeepCallbackAs(true)
        } else {
            pluginResult = CDVPluginResult(status: CDVCommandStatus_ERROR, messageAs: "Missing input parameters")
            self.commandDelegate!.send(pluginResult, callbackId: command.callbackId)
        }
    }
    
}
