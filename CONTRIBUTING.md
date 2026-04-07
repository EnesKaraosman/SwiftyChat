# Contributing to SwiftyChat

Thanks for your interest in contributing! Here's how you can help.

## Getting Started

1. Fork the repository
2. Clone your fork and create a new branch from `master`
3. Make your changes
4. Push your branch and open a pull request

## Development Setup

```bash
git clone https://github.com/<your-username>/SwiftyChat.git
cd SwiftyChat
open SwiftyChatDemo/SwiftyChatDemo.xcodeproj
```

The demo app pulls the library as a local package, so changes to `Sources/SwiftyChat/` are reflected immediately.

## Code Style

- Use Swift 6 strict concurrency
- Follow existing naming conventions and file organization
- Use [Conventional Commits](https://www.conventionalcommits.org/) for commit messages (e.g., `feat:`, `fix:`, `docs:`)
- Keep dependencies minimal — avoid adding new ones unless necessary

## What to Contribute

- Bug fixes
- New message types or themes
- Documentation improvements
- Performance optimizations
- Accessibility improvements

## Pull Request Guidelines

- Keep PRs focused — one feature or fix per PR
- Include screenshots for UI changes
- Make sure `swift build` passes on both iOS and macOS
- Fill out the PR template

## Reporting Bugs

Open an issue using the **Bug Report** template. Include:
- Steps to reproduce
- Expected vs. actual behavior
- SwiftyChat version, iOS/macOS version, Xcode version

## Questions?

Open a GitHub issue — we're happy to help.
