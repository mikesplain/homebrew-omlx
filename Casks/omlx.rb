cask "omlx" do
  version "0.7.1.dev2"

  on_sequoia :or_older do
    sha256 "29c8a36a202f508ac18f7a761b1a6902c084c0bbf8563ab239548cd3c43f37a3"

    url "https://github.com/jundot/omlx/releases/download/v#{version}/oMLX-#{version}-macos15-sequoia.dmg"
  end
  on_tahoe :or_newer do
    sha256 "1427acced6b6876427ac8ff7862ea1d961bacc692218f6ddcbd465ea8af9b78a"

    url "https://github.com/jundot/omlx/releases/download/v#{version}/oMLX-#{version}-macos26-27.dmg"
  end

  name "oMLX"
  desc "MLX inference server and menu bar app"
  homepage "https://omlx.ai/"

  livecheck do
    url "https://github.com/jundot/omlx/releases"
    regex(/^v?(\d+(?:\.\d+)+(?:[._-]?(?:dev|rc|post)\d*)?)$/i)
    strategy :github_releases
  end

  auto_updates true
  depends_on arch: :arm64
  depends_on macos: :sequoia

  app "oMLX.app"

  # oMLX is a persistent menu bar app that intentionally ignores the standard quit
  # Apple event, so the documented signal fallback is required. `on_upgrade: :signal`
  # opts the fallback into `brew upgrade`/`brew reinstall`, where `signal` is
  # skipped by default.
  uninstall quit:       "app.omlx",
            signal:     ["TERM", "app.omlx"],
            on_upgrade: :signal

  zap trash: [
    "~/.omlx",
    "~/Library/Application Support/oMLX",
    "~/Library/Caches/app.omlx",
    "~/Library/HTTPStorages/app.omlx",
    "~/Library/Logs/oMLX",
    "~/Library/Preferences/app.omlx.plist",
    "~/Library/Saved Application State/app.omlx.savedState",
  ]
end
