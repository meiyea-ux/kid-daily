# KidDaily iOS Cloud Mac Test Steps

These steps are for testing the SwiftUI version of KidDaily on your cloud Mac.

## Files Prepared

- `ContentView.swift`
- `KidDailyApp.swift`
- `KidDaily_iOS_Source.zip`

## Option A: Create A New Xcode Project

1. Copy `KidDaily_iOS_Source.zip` to the cloud Mac.
2. Unzip it on the cloud Mac.
3. Open Xcode.
4. Choose `File > New > Project`.
5. Select `iOS > App`.
6. Set:
   - Product Name: `KidDaily`
   - Interface: `SwiftUI`
   - Language: `Swift`
7. Create the project.
8. In Xcode, replace the generated `ContentView.swift` with the prepared `ContentView.swift`.
9. If the new project already has a file named `KidDailyApp.swift`, do not add the prepared `KidDailyApp.swift`.
10. Select an iPhone Simulator.
11. Press `Cmd + R` to build and run.

## Option B: Use An Existing Xcode Project

1. Copy `ContentView.swift` into the existing KidDaily Xcode project.
2. Replace the existing `ContentView.swift`.
3. Do not add `KidDailyApp.swift` if the project already has an `@main` app file.
4. Build and run in Xcode.

## HealthKit Setup For Real Device Testing

Health data from iPhone / Apple Watch requires a real iPhone and the HealthKit capability.

1. Open `KidDaily project > Target KidDaily > Signing & Capabilities`.
2. Click `+ Capability`.
3. Add `HealthKit`.
4. Run on a real iPhone.
5. Open the `Move` tab.
6. Tap `Request Health Permission`.
7. Allow steps, exercise minutes, active energy, and workouts in the iOS permission sheet.

The iOS Simulator cannot read real Apple Watch Health data.

## Speech Recitation Setup For Real Device Testing

Sentence recitation uses the microphone and Apple's Speech framework.

1. Open `KidDaily project > Target KidDaily > Info`.
2. Add these custom iOS target properties if they are missing:
   - `Privacy - Microphone Usage Description`: `KidDaily uses the microphone for sentence recitation practice.`
   - `Privacy - Speech Recognition Usage Description`: `KidDaily uses speech recognition to compare recited sentences with the learning library.`
3. Run on a real iPhone.
4. Open the `Words` tab.
5. Tap `Start Reciting`.
6. Allow microphone and speech recognition permissions.

## Command Line Build Test

From the project folder on the cloud Mac:

```bash
xcodebuild -scheme KidDaily -destination 'platform=iOS Simulator,name=iPhone 15' build
```

If the simulator name is different, list available simulators:

```bash
xcrun simctl list devices available
```

Then replace `iPhone 15` with one of the listed simulator names.

## Expected App Behavior

- Shows three tasks:
  - Math - 20 minutes
  - English - 20 minutes
  - Reading - 15 minutes
- Each task can be toggled on or off.
- Completed count updates automatically.
- Game time equals completed task count times 10 minutes.
- Before all tasks are complete, it shows `Game Time Locked`.
- After all three are complete, it shows `Game Time Unlocked: 30 min`.
- `Reset Today` clears all task toggles.
- Completed tasks automatically earn game time.
- Daily records are saved locally and shown in `Recent Records`.
- The app resets task toggles when a new calendar day starts.
- `ScreenTimeManager` is a placeholder for future Apple Screen Time API integration.
- The app now has three tabs:
  - `Today`: child learning tasks and earned game time.
  - `Records`: daily records and continuous learning streak.
  - `Parent`: parent dashboard and future Screen Time API entry point.
- Continuous learning streak counts consecutive days where all three tasks were completed.
- Parent tab is now protected by a simple PIN lock.
- Default parent PIN is `1234`.
- Parent dashboard can change the PIN and lock itself again.
- Parent dashboard can adjust Math, English, and Reading task durations.
- Parent dashboard can adjust the reward rule: game minutes earned per completed task.
- The unlocked game time message updates automatically from the reward rule.
- Today tab now shows encouragement feedback as tasks are completed.
- Completed task rows get a clearer green success state.
- Parent dashboard can set the child's name.
- Parent dashboard can edit notes shown under each learning task.
- Records rows now open a detail page for that day's task completion.
- Parent dashboard includes a Screen Time setup checklist.
- Parent dashboard now calls Apple's Screen Time APIs when available:
  - `AuthorizationCenter` requests Screen Time permission.
  - `FamilyActivityPicker` opens system app/category selection.
  - `ManagedSettingsStore` applies or clears shields for selected apps/categories/domains.
- Detailed usage reports still require adding a separate Device Activity Report extension target.
- Web parent dashboard can generate a pairing code for the selected child.
- iOS Parent tab can enter that pairing code and upload today's record to Supabase.
- Web parent dashboard can refresh iOS records from Supabase for remote monitoring.
- Web parent dashboard can adjust task minutes and entertainment reward minutes remotely.
- iOS Parent tab can sync those remote settings by pairing code.
- The app now has a `Move` tab for HealthKit sync.
- `Move` can read today's steps, Apple exercise minutes, active energy, and latest workout when HealthKit is available.
- Apple Watch workout data appears after it syncs into the iPhone Health app.
- The `Words` tab now focuses on Gaokao vocabulary.
- Each Gaokao word includes a sentence library item for recitation.
- Sentence recitation uses speech input and compares the recognized text against the target sentence.
