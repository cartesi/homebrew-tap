require "language/node"

class Cartesi < Formula
  desc "CLI for developing Cartesi applications"
  homepage "https://github.com/cartesi/cli"
  url "https://registry.npmjs.org/@cartesi/cli/-/cli-1.5.0.tgz"
  sha256 "2784f62fbb458c0b1d6cf99396fbbaa7be561e27849822944ba58974e7f44e9b"
  license "Apache-2.0"

  livecheck do
    url :stable
  end

  bottle do
    root_url "https://ghcr.io/v2/cartesi/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe: "127bc2adc8991539889558baa71b30bfb36ba0924e9d0ca2087e11e6fb7ec912"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]

    # use node installed by the "node" formula instead of the PATH one
    inreplace libexec/"lib/node_modules/@cartesi/cli/bin/run.js", "#!/usr/bin/env node",
      "#!#{formula_opt_bin("node")}/node"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/cartesi --version")
  end
end
