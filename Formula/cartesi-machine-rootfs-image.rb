class CartesiMachineRootfsImage < Formula
  desc "Rootfs image for the Cartesi Machine"
  homepage "https://github.com/cartesi/machine-guest-tools"
  VERSION = "v0.20.0-test1".freeze
  ROOTFS_IMAGE = "rootfs-ubuntu.ext2".freeze
  url "https://github.com/cartesi/machine-rootfs-image/releases/download/#{VERSION}/#{ROOTFS_IMAGE}"
  sha256 "a38dbf39bdadc644bb31f1fc427be037b3082c9007afe1d9f2220b20d2789271"
  license "GPL-2.0-only"

  def install
    share.install self.class::ROOTFS_IMAGE
    (etc/"cartesi/images").install_symlink share/self.class::ROOTFS_IMAGE => "rootfs.ext2"
  end

  test do
    assert_path_exists etc/"cartesi/images/rootfs.ext2"
  end
end
