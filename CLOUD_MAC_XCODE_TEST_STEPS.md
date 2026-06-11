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
