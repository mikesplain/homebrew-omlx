# homebrew-omlx

[![CI](https://github.com/mikesplain/homebrew-omlx/actions/workflows/ci.yml/badge.svg)](https://github.com/mikesplain/homebrew-omlx/actions/workflows/ci.yml) [![Update oMLX Cask](https://github.com/mikesplain/homebrew-omlx/actions/workflows/update-omlx.yml/badge.svg)](https://github.com/mikesplain/homebrew-omlx/actions/workflows/update-omlx.yml)

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

## Upgrading on a running system

`brew upgrade --cask omlx` stops any running oMLX app (and the `omlx-server`
process it spawns) before replacing the bundle.

oMLX is a persistent menu bar app that intentionally ignores the standard
`quit` Apple event, so the cask keeps the graceful `uninstall quit:` stanza
(used automatically if upstream ever honors it) and adds Homebrew's documented
`signal:` fallback. Because `signal` is skipped during `brew upgrade` and
`brew reinstall` by default, the cask opts in explicitly with
`on_upgrade: :signal`.

Consequences of the signal fallback:

- oMLX is **not** relaunched automatically after the upgrade — Homebrew only
  reopens apps it quit gracefully. Relaunch it from the menu bar after upgrading.
- The cask requires a modern Homebrew that understands the `on_upgrade` key
  (added in Homebrew/brew#21130); older Homebrew versions fail to load it.

## Local Validation

```sh
brew tap mikesplain/omlx .
brew audit --cask --strict --online --tap=mikesplain/omlx omlx
brew style --cask mikesplain/omlx
```
