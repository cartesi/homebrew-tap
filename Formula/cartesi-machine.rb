class CartesiMachine < Formula
  desc "Meta package for the Cartesi Machine"
  homepage "https://cartesi.io"
  url "https://github.com/cartesi/machine-emulator/archive/refs/tags/v0.22.0-test2.tar.gz"
  version "0.22.0"
  sha256 "0ab1d6c07f0a1d1cb075f1c0bc3d4969456d1df377f0b9a6cb718fe7143ff05c"
  license "LGPL-3.0-only"

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
