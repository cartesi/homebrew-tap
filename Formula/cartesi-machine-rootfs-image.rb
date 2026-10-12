class CartesiMachineRootfsImage < Formula
  desc "Rootfs image for the Cartesi Machine"
  homepage "https://github.com/cartesi/machine-guest-tools"
  url "https://github.com/cartesi/machine-guest-tools/releases/download/v0.18.0/rootfs-tools.ext2"
  version "0.22.0"
  sha256 "6c159937485c99f695021c4f2ea2a57bdadcf4e4bce8e71af5bee3bb9552802e"
  license "GPL-2.0-only"

  def install
    rootfs_image = File.basename(stable.url)
    share.install rootfs_image
    (etc/"cartesi/images").install_symlink share/rootfs_image => "rootfs.ext2"
  end

  test do
    assert_path_exists etc/"cartesi/images/rootfs.ext2"
  end
end
