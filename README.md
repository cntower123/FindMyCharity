# FindMyCharity

An iOS app for discovering charity projects around the world on a map.

**[Watch the demo](ADD-YOUTUBE-LINK)**

## What it does

- Shows real charity projects as pins on a world map.
- Filters by 11 cause categories (education, healthcare, clean water, climate and more) and by country.
- Each charity page shows its mission, location and focus areas, with a link to donate on GlobalGiving.
- Sign in with email or Google, then save favourites, see recently viewed charities and your "Impact" summary.
- Onboarding screens, a settings page and app-wide dark mode.

## Built with

- Swift and SwiftUI
- MapKit
- Firebase Authentication
- [GlobalGiving API](https://www.globalgiving.org/api/) for live project data, with local caching

The code follows MVVM. Charity data comes through a data-provider protocol, so the app can switch between mock data and the live API without changing the views.

## The story

I wanted an easier way for people to find causes they care about. I reached out to GlobalGiving to get API access, designed the screens and features, and tested the app in the iOS Simulator. I used AI coding assistants (Claude, Cursor) to help write and debug the code.

## Running it

1. Clone the repo and open `FindMyCharity.xcodeproj` in Xcode.
2. Add your own `GoogleService-Info.plist` from a Firebase project with Email and Google sign-in turned on.
3. Create `Secrets.swift` with your own [GlobalGiving API key](https://www.globalgiving.org/api/):
   ```swift
   enum Secrets {
       static let globalGivingAPIKey = "YOUR_API_KEY"
   }
   ```
4. Build and run on an iPhone simulator.

`GoogleService-Info.plist` and `Secrets.swift` are not included in this repo.
