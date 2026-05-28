cask "omlx" do
  version "0.3.12"

  on_sequoia :or_older do
    sha256 "d1b48db37c745fb672cfe6ebb805a59586f90b037c63ece52973b7f040700a8e"

    url "https://github.com/jundot/omlx/releases/download/v#{version}/oMLX-#{version}-macos15-sequoia.dmg",
        verified: "github.com/jundot/omlx/"
  end

  on_tahoe :or_newer do
    sha256 "1da02c1353725329a0f44d40b440bcc78d3ccfa51e3818cdc7cd2504c4176c94"

    url "https://github.com/jundot/omlx/releases/download/v#{version}/oMLX-#{version}-macos26-tahoe.dmg",
        verified: "github.com/jundot/omlx/"
  end

  name "oMLX"
  desc "macOS-native MLX inference server and menu bar app"
  homepage "https://omlx.ai/"

  livecheck do
    url "https://github.com/jundot/omlx/releases/latest"
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
