require "language/node"

class Cartesi < Formula
  desc "CLI for developing Cartesi applications"
  homepage "https://github.com/cartesi/cli"
  url "https://registry.npmjs.org/@cartesi/cli/-/cli-2.0.0-alpha.42.tgz"
  sha256 "c930e0254a40b325d156ba401f754acb1d99f34f54c1522c67c24924433992f6"
  license "Apache-2.0"

  livecheck do
    url "https://registry.npmjs.org/@cartesi/cli"
    strategy :json do |json|
      json.dig("dist-tags", "alpha")
    end
  end

  bottle do
    root_url "https://ghcr.io/v2/cartesi/tap"
    sha256 cellar: :any_skip_relocation, all: "092502521961679ff4e729819ba4b8fd84ab0e1c3b2ee0b5c64726cc19f01eb5"
  end

  depends_on "cartesi-machine"
  depends_on "cartesi-rollups-node"
  depends_on "node"
  depends_on "xgenext2fs"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]

    # use node installed by the "node" formula instead of the PATH one
    inreplace libexec/"lib/node_modules/@cartesi/cli/dist/index.js", "#!/usr/bin/env node",
      "#!#{formula_opt_bin("node")}/node"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/cartesi --version")
  end
end
