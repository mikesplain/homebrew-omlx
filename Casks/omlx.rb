cask "omlx" do
  version "0.6.4"

  on_sequoia :or_older do
    sha256 "5a90c7ae4a3f4ca8bf10dcc83d7f7395281e2ffb2a85d630c95e9720848e47cd"

    url "https://github.com/jundot/omlx/releases/download/v#{version}/oMLX-#{version}-macos15-sequoia.dmg",
        verified: "github.com/jundot/omlx/"
  end
  on_tahoe :or_newer do
    sha256 "53f1506c2385e8920a67198b72d1fe09351c1b3538be9c6bdeb78e5277d06d93"

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
