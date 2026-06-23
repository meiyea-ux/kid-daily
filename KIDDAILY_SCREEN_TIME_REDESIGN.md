# KidDaily Screen Time Redesign

KidDaily is shifting from word recitation to a Screen Time reward model:

- Entertainment apps are locked at the start of each day.
- Parents choose learning apps and entertainment apps with Apple's FamilyActivityPicker.
- Parents set:
  - how many learning apps must qualify each day,
  - the target minutes for each learning app,
  - the reward minutes earned per qualified learning app.
- When the learning goal is met, KidDaily unlocks the selected entertainment apps for the earned reward window.

KidDaily also keeps a Move Unlock rule:

- Parents set a daily activity window, for example 17:00-19:00.
- Parents choose an activity type such as any exercise, walking, running, cycling, swimming, strength training, yoga, or dance.
- Parents set the required movement minutes and the entertainment reward minutes.
- KidDaily syncs HealthKit data from iPhone / Apple Watch and awards the movement reward when the window target is met.

## Current Main App Work

`ContentView.swift` now contains the main-app experience:

- `Apps` tab replaces the old `Words` tab.
- The word-recitation flow, speech-recognition helper, parent word settings, and built-in word lists have been removed from `ContentView.swift`.
- Parent and Apps views expose:
  - learning app selection,
  - entertainment app selection,
  - daily learning target,
  - reward rule,
  - apply lock,
  - start reward window.
- The current build still uses the existing task completion switches as a temporary progress stand-in until the DeviceActivity extension writes real usage progress.
- The Move tab now includes a configurable movement window and can sync HealthKit exercise/workout data for that window.

## Xcode Targets Still Needed

Automatic app usage monitoring requires adding a Device Activity extension target in Xcode:

1. Main app target:
   - Add `Family Controls` capability.
   - Add an App Group if the extension and app share progress.

2. Device Activity Monitor Extension:
   - Add `Family Controls` capability.
   - Monitor selected learning app tokens.
   - Write qualified-app progress to shared storage.
   - Notify the main app logic when the daily goal is met.

3. Optional Shield Configuration Extension:
   - Customize the blocked entertainment-app screen.

## App Store Review Notes

- Request the Family Controls distribution entitlement before TestFlight/App Store release.
- The app should explain that app selections are represented by Apple privacy-preserving tokens.
- Since word recitation was removed, the app should no longer need microphone or speech-recognition privacy strings.
- HealthKit remains required because KidDaily keeps the Move Unlock feature.
- Keep `NSHealthShareUsageDescription` in the app's Info settings and enable the HealthKit capability.
