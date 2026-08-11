class CartesiMachineRootfsImage < Formula
  desc "Rootfs image for the Cartesi Machine"
  homepage "https://github.com/cartesi/machine-guest-tools"

  bottle do
    root_url "https://ghcr.io/v2/cartesi/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7b178250dc004a23003ace7861260e3fd687749c996a543529b834e108fe1817"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c0f1dc6b55fed36c7dd6358fced9fec8f2c7d82bb89f2ab46b0325bd08ff1201"
  end

  VERSION = "v0.18.0".freeze
  ROOTFS_IMAGE = "rootfs-tools.ext2".freeze
  url "https://github.com/cartesi/machine-guest-tools/releases/download/#{VERSION}/#{ROOTFS_IMAGE}"
  version "0.21.0"
  sha256 "6c159937485c99f695021c4f2ea2a57bdadcf4e4bce8e71af5bee3bb9552802e"
  license "GPL-2.0-only"
  revision 1

  def install
    share.install self.class::ROOTFS_IMAGE
    (etc/"cartesi/images").install_symlink share/self.class::ROOTFS_IMAGE => "rootfs.ext2"
  end

  test do
    assert_path_exists etc/"cartesi/images/rootfs.ext2"
  end
end
