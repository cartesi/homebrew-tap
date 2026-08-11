class CartesiMachineRootfsImage < Formula
  desc "Rootfs image for the Cartesi Machine"
  homepage "https://github.com/cartesi/machine-guest-tools"

  bottle do
    root_url "https://ghcr.io/v2/cartesi/tap"
    sha256 cellar: :any_skip_relocation, all: "55b52195a7f20b0d7eb5d1d89791dbdd91d7cd05a52b5b5c5682b670a93fe825"
  end

  VERSION = "v0.18.0".freeze
  ROOTFS_IMAGE = "rootfs-tools.ext2".freeze
  url "https://github.com/cartesi/machine-guest-tools/releases/download/#{VERSION}/#{ROOTFS_IMAGE}"
  version "0.21.0"
  sha256 "6c159937485c99f695021c4f2ea2a57bdadcf4e4bce8e71af5bee3bb9552802e"
  license "GPL-2.0-only"
  revision 2

  def install
    share.install self.class::ROOTFS_IMAGE
    (etc/"cartesi/images").install_symlink share/self.class::ROOTFS_IMAGE => "rootfs.ext2"
  end

  test do
    assert_path_exists etc/"cartesi/images/rootfs.ext2"
  end
end
