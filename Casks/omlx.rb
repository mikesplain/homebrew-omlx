cask "omlx" do
  version "0.5.1"

  on_sequoia :or_older do
    sha256 "daf272e6447bbad026c6a809defaf888e327e9074a732e476e26bcf8397e4fcd"

    url "https://github.com/jundot/omlx/releases/download/v#{version}/oMLX-#{version}-macos15-sequoia.dmg",
        verified: "github.com/jundot/omlx/"
  end
  on_tahoe :or_newer do
    sha256 "0a44afc9a25070f7eb5b28c97aa3f4d204eb4066997c97b4ebe75e54a11ea561"

    url "https://github.com/jundot/omlx/releases/download/v#{version}/oMLX-#{version}-macos26-27.dmg",
        verified: "github.com/jundot/omlx/"
  end

  name "oMLX"
  desc "MLX inference server and menu bar app"
  homepage "https://omlx.ai/"

  livecheck do
    url "https://github.com/jundot/omlx/releases/latest"
    regex(/^v?(\d+(?:\.\d+)+(?:[._-]?(?:dev|rc|post)\d*)?)$/i)
    strategy :github_latest
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
