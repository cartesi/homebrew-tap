require "language/node"

class Cartesi < Formula
  desc "CLI for developing Cartesi applications"
  homepage "https://github.com/cartesi/cli"
  url "https://registry.npmjs.org/@cartesi/cli/-/cli-0.16.1.tgz"
  sha256 "5ba91d5b6d74cde90aa78a1b2e102cd5978a264f02cf6746195e557a276c70b4"
  license "Apache-2.0"

  livecheck do
    url :stable
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]

    # use node installed by the "node" formula instead of the PATH one
    inreplace libexec/"lib/node_modules/@cartesi/cli/bin/run.js", "#!/usr/bin/env node",
      "#!#{Formula["node"].opt_bin}/node"
  end

  test do
    raise "Test not implemented."
  end
end
