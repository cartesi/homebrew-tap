class CartesiMachine < Formula
  desc "Meta package for the Cartesi Machine"
  homepage "https://cartesi.io"
  url "https://github.com/cartesi/machine-emulator/archive/refs/tags/v0.21.0.tar.gz"
  sha256 "44fc83cb08a1907e66ab225ccf421b0fdad3f145be35b9a9ffe561d3563e3eda"
  license "LGPL-3.0-only"
  revision 1

  bottle do
    root_url "https://ghcr.io/v2/cartesi/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "73ee8d279c620a9d12f4408434d67d36b4321277ca50a55091dfb6dfd9d3998e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "78deda26b74a3a52a13e7dbf210b0e1f2d85b0835227660dd5531368dd1f6bbb"
  end

  depends_on "cartesi-machine-emulator"
  depends_on "cartesi-machine-linux-image"
  depends_on "cartesi-machine-rootfs-image"

  def install
    # This is a metapackage
    touch prefix/"installed"
  end

  test do
    system Formula["cartesi-machine-emulator"].bin/"cartesi-machine", "--version"
  end
end
