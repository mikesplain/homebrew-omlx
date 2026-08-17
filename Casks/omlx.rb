cask "omlx" do
  version "0.6.1"

  on_sequoia :or_older do
    sha256 "e959145da29543c7fa88e2c2694eee1a15be938609d5d3641ed4d5072e05a97f"

    url "https://github.com/jundot/omlx/releases/download/v#{version}/oMLX-#{version}-macos15-sequoia.dmg",
        verified: "github.com/jundot/omlx/"
  end
  on_tahoe :or_newer do
    sha256 "2cea007ddcca405ae33a9904ccad502a8fb6c9b4ffa8bcfebc24331a91e4c324"

    url "https://github.com/jundot/omlx/releases/download/v#{version}/oMLX-#{version}-macos26-27.dmg",
        verified: "github.com/jundot/omlx/"
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

  uninstall quit: "app.omlx"

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
