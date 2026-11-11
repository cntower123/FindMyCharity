# FindMyCharity

An iOS app for discovering charity projects around the world on a map.

*[Watch the demo](https://www.youtube.com/watch?v=_TCtGyyfGRo&list=PLMaUP03VcEoo)**

# What it does

- Shows real charity projects as pins on a world map.
- Filters by 11 cause categories (education, healthcare, clean water, climate and more) and by country.
- Each charity page shows its mission, location and focus areas, with a link to donate on GlobalGiving.
- Sign in with email or Google, then save favourites, see recently viewed charities and your "Impact" summary.
- Onboarding screens, a settings page and app-wide dark mode.

# Built with

- Swift and SwiftUI
- MapKit
- Firebase Authentication
- [GlobalGiving API](https://www.globalgiving.org/api/) for live project data, with local caching

The code follows MVVM. Charity data comes through a data-provider protocol, so the app can switch between mock data and the live API without changing the views.

# The story

I wanted an easier way for people to find causes they care about. I reached out to GlobalGiving to get API access, designed the screens and features, and tested the app in the iOS Simulator. I used coding assistants Cursor to help write and debug some of the complex code.

# Running it

Open FindMyCharity.xcodeproj in Xcode, add your own GoogleService-Info.plist and a Secrets.swift with your GlobalGiving API key (neither is included in this repo), then run on an iPhone simulator.

(`GoogleService-Info.plist` and `Secrets.swift` are not included in this repo).
