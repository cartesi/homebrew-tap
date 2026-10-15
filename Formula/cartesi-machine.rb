class CartesiMachine < Formula
  desc "Meta package for the Cartesi Machine"
  homepage "https://cartesi.io"
  url "https://github.com/cartesi/machine-emulator/archive/refs/tags/v0.22.0.tar.gz"
  sha256 "7e82de5bfe213b9ca821a65c79a59dc593fff47ed6e8cf5accf36e9bb7b913fe"
  license "LGPL-3.0-only"

  bottle do
    root_url "https://ghcr.io/v2/cartesi/tap"
    sha256 cellar: :any_skip_relocation, all: "eba6ebf55acc1d12d286eda277458804017335dc02273f3527e478b63a1f5ab7"
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
