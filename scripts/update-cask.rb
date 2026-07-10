#!/usr/bin/env ruby
# frozen_string_literal: true

require "digest"
require "json"
require "net/http"
require "uri"

REPO = "jundot/omlx"
CASK_PATH = File.expand_path("../Casks/omlx.rb", __dir__).freeze
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

def sha256_for(url, redirects = 0)
  if redirects > 5
    warn "Too many redirects while downloading #{url}"
    exit 1
  end

  uri = URI(url)
  request = Net::HTTP::Get.new(uri)
  request["User-Agent"] = USER_AGENT
  digest = Digest::SHA256.new

  Net::HTTP.start(uri.hostname, uri.port, use_ssl: uri.scheme == "https") do |http|
    http.request(request) do |response|
      case response
      when Net::HTTPRedirection
        return sha256_for(URI.join(url, response["location"]).to_s, redirects + 1)
      when Net::HTTPSuccess
        response.read_body { |chunk| digest.update(chunk) }
      else
        warn "Download failed: #{response.code} #{url}"
        exit 1
      end
    end
  end

  digest.hexdigest
end

def replace!(content, pattern, replacement)
  unless content.match?(pattern)
    warn "Could not update cask; pattern did not match: #{pattern.inspect}"
    exit 1
  end

  content.sub(pattern, replacement)
end

releases = github_json("repos/#{REPO}/releases?per_page=1")
release = releases.first
version = release.fetch("tag_name").delete_prefix("v")

assets = {
  "macos15-sequoia" => asset_url(release, version, "macos15-sequoia"),
  "macos26-27"      => asset_url(release, version, "macos26-27"),
}

shas = assets.transform_values { |url| sha256_for(url) }
cask = File.read(CASK_PATH)

cask = replace!(cask, /^  version "[^"]+"/, %Q(  version "#{version}"))
cask = replace!(
  cask,
  /on_sequoia :or_older do\n    sha256 "[0-9a-f]{64}"/,
  %Q(on_sequoia :or_older do\n    sha256 "#{shas.fetch("macos15-sequoia")}"),
)
cask = replace!(
  cask,
  /on_tahoe :or_newer do\n    sha256 "[0-9a-f]{64}"/,
  %Q(on_tahoe :or_newer do\n    sha256 "#{shas.fetch("macos26-27")}"),
)

File.write(CASK_PATH, cask)
puts "Updated oMLX cask to #{version}"
