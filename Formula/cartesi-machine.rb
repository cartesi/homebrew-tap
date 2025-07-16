class CartesiMachine < Formula
  desc "Meta package for the Cartesi Machine"
  homepage "https://cartesi.io"
  url "https://github.com/cartesi/machine-emulator/archive/refs/tags/v0.19.0.tar.gz"
  sha256 "1a33fb7e0dd7030656ddbb214dcd2f5a569f64e906edb20f149b66b34e1e0dd3"
  license "LGPL-3.0-only"

  bottle do
    root_url "https://ghcr.io/v2/cartesi/tap"
    sha256 cellar: :any_skip_relocation, arm64_sonoma: "8edb6724dffd2ad487d61da3eaab1781f2eb96a65a71af696c812e6286b39bfa"
    sha256 cellar: :any_skip_relocation, ventura:      "d2c7400e88c12432cf55971ea9ae6edbaf72fa30c14ceeafd0b3f17148b6ffcb"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "b3da1acd61897dfd758e257c433140d5e8f53260beec15cb1b21933f90d41e48"
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
