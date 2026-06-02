cask "omlx" do
  version "0.4.0rc2"

  on_sequoia :or_older do
    sha256 "0ec169c5eba32497b639edfeeb3364bba7fa697ca2b80993c590cf0c41ac6bfe"

    url "https://github.com/jundot/omlx/releases/download/v#{version}/oMLX-#{version}-macos15-sequoia.dmg",
        verified: "github.com/jundot/omlx/"
  end
  on_tahoe :or_newer do
    sha256 "775eea795d695a9dd3bcb16b467e4016c0caa25d0c28b07e86aeee94638fa8f7"

    url "https://github.com/jundot/omlx/releases/download/v#{version}/oMLX-#{version}-macos26-tahoe.dmg",
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
