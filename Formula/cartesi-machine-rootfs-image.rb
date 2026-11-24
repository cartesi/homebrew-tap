class CartesiMachineRootfsImage < Formula
  desc "Rootfs image for the Cartesi Machine"
  homepage "https://github.com/cartesi/machine-guest-tools"
  url "https://github.com/cartesi/machine-guest-tools/releases/download/v0.18.1/rootfs-tools.ext2"
  # This version tracks neither the emulator nor machine-guest-tools; it only
  # has to go up whenever the image changes so existing installs upgrade.
  version "0.21.1"
  sha256 "2ebb06d50f23f969b55aaf99274e0ddb842e710414de7b26cb8cbae834f56b90"
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
