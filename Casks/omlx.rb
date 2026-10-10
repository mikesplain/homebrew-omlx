cask "omlx" do
  version "0.7.1.dev1"

  on_sequoia :or_older do
    sha256 "55d193de2cca0cb5a02fbff69e564dec3abe79a02ca5fc3c9309ce55634a5ff2"

    url "https://github.com/jundot/omlx/releases/download/v#{version}/oMLX-#{version}-macos15-sequoia.dmg"
  end
  on_tahoe :or_newer do
    sha256 "04fbff0b54bd8656a6684e3051879d7039cb5f4514777527614c54d6d00e0ca2"

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
