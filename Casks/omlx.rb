cask "omlx" do
  version "0.7.3"

  on_sequoia :or_older do
    sha256 "cd5e3b454798a002f32ef2f3bf06ae033ea2f4e5b02aa039a2c68445498605f1"

    url "https://github.com/jundot/omlx/releases/download/v#{version}/oMLX-#{version}-macos15-sequoia.dmg"
  end
  on_tahoe :or_newer do
    sha256 "2acfde41aeac0b022dbca803ca109437f3ccaf0c33f3415881526b985bee86f2"

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
