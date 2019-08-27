import Foundation
import AVFoundation

let iiFaderForAvAudioPlayer_defaultFadeDurationSeconds = 3.0
let iiFaderForAvAudioPlayer_defaultVelocity = 2.0

open class iiFaderForAvAudioPlayer: NSObject {
  let player: AVAudioPlayer
  fileprivate var timer: Timer?

  // The higher the number - the higher the quality of fade
  // and it will consume more CPU.
  var volumeAlterationsPerSecond = 30.0

  fileprivate var fadeDurationSeconds = iiFaderForAvAudioPlayer_defaultFadeDurationSeconds
  fileprivate var fadeVelocity = iiFaderForAvAudioPlayer_defaultVelocity

  fileprivate var fromVolume = 0.0
  fileprivate var toVolume = 0.0

  fileprivate var currentStep = 0

  fileprivate var onFinished: ((Bool)->())? = nil

  init(player: AVAudioPlayer) {
    self.player = player
  }

  deinit {
    callOnFinished(false)
    stop()
  }

  fileprivate var fadeIn: Bool {
    return fromVolume < toVolume
  }

  func fadeIn(_ duration: Double = iiFaderForAvAudioPlayer_defaultFadeDurationSeconds,
    velocity: Double = iiFaderForAvAudioPlayer_defaultVelocity, onFinished: ((Bool)->())? = nil) {

    fade(
      fromVolume: Double(player.volume), toVolume: 1,
      duration: duration, velocity: velocity, onFinished: onFinished)
  }

  func fadeOut(_ duration: Double = iiFaderForAvAudioPlayer_defaultFadeDurationSeconds,
    velocity: Double = iiFaderForAvAudioPlayer_defaultVelocity, onFinished: ((Bool)->())? = nil) {

    fade(
      fromVolume: Double(player.volume), toVolume: 0,
      duration: duration, velocity: velocity, onFinished: onFinished)
  }

  func fade(fromVolume: Double, toVolume: Double,
    duration: Double = iiFaderForAvAudioPlayer_defaultFadeDurationSeconds,
    velocity: Double = iiFaderForAvAudioPlayer_defaultVelocity, onFinished: ((Bool)->())? = nil) {

    self.fromVolume = iiFaderForAvAudioPlayer.makeSureValueIsBetween0and1(fromVolume)
    self.toVolume = iiFaderForAvAudioPlayer.makeSureValueIsBetween0and1(toVolume)
    self.fadeDurationSeconds = duration
    self.fadeVelocity = velocity

    callOnFinished(false)
    self.onFinished = onFinished

    player.volume = Float(self.fromVolume)

    if self.fromVolume == self.toVolume {
      callOnFinished(true)
      return
    }

    startTimer()
  }

  // Stop fading. Does not stop the sound.
  func stop() {
    stopTimer()
  }

  fileprivate func callOnFinished(_ finished: Bool) {
    onFinished?(finished)
    onFinished = nil
  }

  fileprivate func startTimer() {
    stopTimer()
    currentStep = 0

    timer = Timer.scheduledTimer(timeInterval: 1 / volumeAlterationsPerSecond, target: self,
      selector: #selector(iiFaderForAvAudioPlayer.timerFired(_:)), userInfo: nil, repeats: true)
  }

  fileprivate func stopTimer() {
    if let currentTimer = timer {
      currentTimer.invalidate()
      timer = nil
    }
  }

  func timerFired(_ timer: Timer) {
    if shouldStopTimer {
      player.volume = Float(toVolume)
      stopTimer()
      callOnFinished(true)
      return
    }

    let currentTimeFrom0To1 = iiFaderForAvAudioPlayer.timeFrom0To1(
      currentStep, fadeDurationSeconds: fadeDurationSeconds, volumeAlterationsPerSecond: volumeAlterationsPerSecond)

    var volumeMultiplier: Double

    var newVolume: Double = 0

    if fadeIn {
      volumeMultiplier = iiFaderForAvAudioPlayer.fadeInVolumeMultiplier(currentTimeFrom0To1,
        velocity: fadeVelocity)

      newVolume = fromVolume + (toVolume - fromVolume) * volumeMultiplier

    } else {
      volumeMultiplier = iiFaderForAvAudioPlayer.fadeOutVolumeMultiplier(currentTimeFrom0To1,
        velocity: fadeVelocity)

      newVolume = toVolume - (toVolume - fromVolume) * volumeMultiplier
    }

    player.volume = Float(newVolume)

    currentStep += 1
  }

  var shouldStopTimer: Bool {
    let totalSteps = fadeDurationSeconds * volumeAlterationsPerSecond
    return Double(currentStep) > totalSteps
  }

  open class func timeFrom0To1(_ currentStep: Int, fadeDurationSeconds: Double,
    volumeAlterationsPerSecond: Double) -> Double {

    let totalSteps = fadeDurationSeconds * volumeAlterationsPerSecond
    var result = Double(currentStep) / totalSteps

    result = makeSureValueIsBetween0and1(result)

    return result
  }

  // Graph: https://www.desmos.com/calculator/wnstesdf0h
  open class func fadeOutVolumeMultiplier(_ timeFrom0To1: Double, velocity: Double) -> Double {
    let time = makeSureValueIsBetween0and1(timeFrom0To1)
    return pow(M_E, -velocity * time) * (1 - time)
  }

  open class func fadeInVolumeMultiplier(_ timeFrom0To1: Double, velocity: Double) -> Double {
    let time = makeSureValueIsBetween0and1(timeFrom0To1)
    return pow(M_E, velocity * (time - 1)) * time
  }

  fileprivate class func makeSureValueIsBetween0and1(_ value: Double) -> Double {
    if value < 0 { return 0 }
    if value > 1 { return 1 }
    return value
  }
}
