#!/usr/bin/env ruby
# frozen_string_literal: true

require "digest"
require "json"
require "net/http"
require "open-uri"
require "uri"

REPO = "jundot/omlx"
CASK_PATH = File.expand_path("../Casks/omlx.rb", __dir__)
USER_AGENT = "homebrew-omlx-cask-updater"

def github_json(path)
  uri = URI("https://api.github.com/#{path}")
  request = Net::HTTP::Get.new(uri)
  request["Accept"] = "application/vnd.github+json"
  request["User-Agent"] = USER_AGENT
  request["Authorization"] = "Bearer #{ENV.fetch("GITHUB_TOKEN")}" if ENV["GITHUB_TOKEN"]

  response = Net::HTTP.start(uri.hostname, uri.port, use_ssl: true) do |http|
    http.request(request)
  end

  unless response.is_a?(Net::HTTPSuccess)
    warn "GitHub API request failed: #{response.code} #{response.body}"
    exit 1
  end

  JSON.parse(response.body)
end

def asset_url(release, version, suffix)
  asset_name = "oMLX-#{version}-#{suffix}.dmg"
  asset = release.fetch("assets").find { |candidate| candidate.fetch("name") == asset_name }

  unless asset
    warn "Could not find release asset #{asset_name.inspect}"
    exit 1
  end

  asset.fetch("browser_download_url")
end

def sha256_for(url)
  digest = Digest::SHA256.new

  URI.open(url, "User-Agent" => USER_AGENT) do |io|
    while (chunk = io.read(1024 * 1024))
      digest.update(chunk)
    end
  end

  digest.hexdigest
end

release = github_json("repos/#{REPO}/releases/latest")
version = release.fetch("tag_name").delete_prefix("v")

assets = {
  "macos15-sequoia" => asset_url(release, version, "macos15-sequoia"),
  "macos26-tahoe" => asset_url(release, version, "macos26-tahoe"),
}

shas = assets.transform_values { |url| sha256_for(url) }
cask = File.read(CASK_PATH)

cask = cask.sub(/version "\d+(?:\.\d+)+"/, %(version "#{version}"))
cask = cask.sub(
  /on_sequoia :or_older do\n    sha256 "[0-9a-f]{64}"/,
  %(on_sequoia :or_older do\n    sha256 "#{shas.fetch("macos15-sequoia")}")
)
cask = cask.sub(
  /on_tahoe :or_newer do\n    sha256 "[0-9a-f]{64}"/,
  %(on_tahoe :or_newer do\n    sha256 "#{shas.fetch("macos26-tahoe")}")
)

File.write(CASK_PATH, cask)
puts "Updated oMLX cask to #{version}"
