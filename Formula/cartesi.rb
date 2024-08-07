require "language/node"

class Cartesi < Formula
  desc "Cartesi CLI"
  homepage "https://github.com/cartesi/cli"
  url "https://registry.npmjs.org/@cartesi/cli/-/cli-0.16.0.tgz"
  sha256 "c990fab3807aba185105c7e664018b7f2f5a4ccdfc6c3928d723bcfdfc28df9d"
  license "Apache-2.0"

  livecheck do
    url :stable
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]

    # use node installed by the "node" formula instead of the PATH one
    inreplace libexec/"lib/node_modules/@cartesi/cli/bin/run.js", "#!/usr/bin/env node", "#!#{Formula["node"].opt_bin}/node"
  end

  test do
    raise "Test not implemented."
  end
end
