require "language/node"

class Cartesi < Formula
  desc "CLI for developing Cartesi applications"
  homepage "https://github.com/cartesi/cli"
  url "https://registry.npmjs.org/@cartesi/cli/-/cli-2.0.0-alpha.42.tgz"
  sha256 "c930e0254a40b325d156ba401f754acb1d99f34f54c1522c67c24924433992f6"
  license "Apache-2.0"
  revision 1

  livecheck do
    url "https://registry.npmjs.org/@cartesi/cli"
    strategy :json do |json|
      json.dig("dist-tags", "alpha")
    end
  end

  bottle do
    root_url "https://ghcr.io/v2/cartesi/tap"
    manifest_sha256 "d97430d506e4827473ec207f7874f252c37a822ab54558be5171c74dcebb001d"
    sha256 cellar: :any_skip_relocation, all: "a88626c40a4d5bb935d11eddc84b8c8ce78f10bb666e7fe3c8b8e576c39f677f"
  end

  # 2.0.0-alpha.42 requires cartesi-machine ^0.22.0 and runs whichever
  # `cartesi-machine` is first on PATH, so pin the keg-only 0.22 emulator and
  # put it first on PATH below instead of depending on cartesi-machine.
  depends_on "cartesi-machine-emulator@0.22"
  depends_on "cartesi-machine-linux-image"
  depends_on "cartesi-machine-rootfs-image"
  depends_on "cartesi-rollups-node"
  depends_on "node"
  depends_on "xgenext2fs"

  def install
    system "npm", "install", *std_npm_args
    libexec.glob("bin/*").each do |f|
      (bin/f.basename).write_env_script f, PATH: "#{formula_opt_bin("cartesi-machine-emulator@0.22")}:$PATH"
    end

    # use node installed by the "node" formula instead of the PATH one
    inreplace libexec/"lib/node_modules/@cartesi/cli/dist/index.js", "#!/usr/bin/env node",
      "#!#{formula_opt_bin("node")}/node"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/cartesi --version")
    # The wrapper must put the 0.22 emulator ahead of any newer cartesi-machine.
    assert_match formula_opt_bin("cartesi-machine-emulator@0.22").to_s, (bin/"cartesi").read
  end
end
