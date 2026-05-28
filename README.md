# homebrew-omlx

Dedicated Homebrew tap for the oMLX macOS app cask.

This tap installs the signed oMLX app from upstream GitHub release DMGs with pinned SHA-256 checksums. Homebrew bottles are for formulae, not casks; for this app, the deterministic artifact is the upstream DMG plus checksum.

## Install

```sh
brew tap mikesplain/omlx
brew install --cask omlx
```

The cask requires Apple Silicon and macOS 15 Sequoia or newer. It selects the Sequoia DMG on macOS 15 and the Tahoe DMG on macOS 26 or newer.

The upstream CLI/server formula is separate:

```sh
brew tap jundot/omlx https://github.com/jundot/omlx
brew install omlx
```

## Updating

`.github/workflows/update-omlx.yml` runs every 6 hours and can also be triggered manually. It:

1. Reads the latest stable upstream release from `jundot/omlx`.
2. Finds the Sequoia and Tahoe DMG assets for that version.
3. Recomputes SHA-256 checksums.
4. Runs `brew audit`.
5. Opens or updates a pull request when the cask changes.

## Local Validation

```sh
brew tap mikesplain/omlx .
brew audit --cask --strict --online --tap=mikesplain/omlx omlx
brew style --cask mikesplain/omlx
```
