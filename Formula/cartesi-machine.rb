class CartesiMachine < Formula
  desc "Meta package for the Cartesi Machine"
  homepage "https://cartesi.io"
  url "https://github.com/cartesi/machine-emulator/archive/refs/tags/v0.21.0.tar.gz"
  sha256 "44fc83cb08a1907e66ab225ccf421b0fdad3f145be35b9a9ffe561d3563e3eda"
  license "LGPL-3.0-only"
  revision 2

  bottle do
    root_url "https://ghcr.io/v2/cartesi/tap"
    sha256 cellar: :any_skip_relocation, all: "a97d1bd76f1b5a1507bc689ed63cfd33c7ade6fe983277287dee551fef1829b9"
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
