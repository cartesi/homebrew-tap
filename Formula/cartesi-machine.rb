class CartesiMachine < Formula
  desc "Meta package for the Cartesi Machine"
  homepage "https://cartesi.io"
  url "https://github.com/cartesi/machine-emulator/archive/refs/tags/v0.23.0.tar.gz"
  sha256 "a8136b43648ce32db5e6172a3d59eadafc6e5d7905f8d3589eb3fe71de89995a"
  license "LGPL-3.0-only"

  bottle do
    root_url "https://ghcr.io/v2/cartesi/tap"
    manifest_sha256 "d602ef150aa190c4d4b6e5d0a49f98b95729f215c9af4b9b3eba4ecab78009f3"
    sha256 cellar: :any_skip_relocation, all: "2719f90165af9836e943fb71fa9214913b98350f6920cef87e2ee08899f11bc2"
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
