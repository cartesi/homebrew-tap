require "language/node"

class Cartesi < Formula
  desc "CLI for developing Cartesi applications"
  homepage "https://github.com/cartesi/cli"
  url "https://registry.npmjs.org/@cartesi/cli/-/cli-2.0.0-alpha.38.tgz"
  sha256 "08f650f78d29cb8e1716bc1648e0918b95c4529f5416a1579f2c1fc969fc4c66"
  license "Apache-2.0"

  livecheck do
    url "https://registry.npmjs.org/@cartesi/cli"
    strategy :json do |json|
      json.dig("dist-tags", "alpha")
    end
  end

  bottle do
    root_url "https://ghcr.io/v2/cartesi/tap"
    sha256 cellar: :any_skip_relocation, all: "0e2a1334ddec9ad5661dc1a498427e179dfb697fa5855c92823cd59340493699"
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
