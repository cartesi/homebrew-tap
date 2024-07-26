require "language/node"

class Cartesi < Formula
  desc "Cartesi CLI"
  homepage "https://github.com/cartesi/cli"
  url "https://registry.npmjs.org/@cartesi/cli/-/cli-0.15.0.tgz"
  sha256 "3bd18d70ebf35b6a7660bb9dbe2e9f69ced327eaf3f2a1d777829ec0bef0ed09"
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
