class CartesiMachineRootfsImage < Formula
  desc "Rootfs image for the Cartesi Machine"
  homepage "https://github.com/cartesi/machine-guest-tools"
  VERSION = "v0.20.0-test1".freeze
  ROOTFS_IMAGE = "rootfs-ubuntu.ext2".freeze
  url "https://github.com/cartesi/machine-rootfs-image/releases/download/#{VERSION}/#{ROOTFS_IMAGE}"
  sha256 "a38dbf39bdadc644bb31f1fc427be037b3082c9007afe1d9f2220b20d2789271"
  license "GPL-2.0-only"

  bottle do
    root_url "https://ghcr.io/v2/cartesi/tap"
    sha256 cellar: :any_skip_relocation, arm64_sonoma: "8143010ab08b493b315c4cb9d2c048f410dfb58ec77c42e9a3f93b5ed5805585"
    sha256                               ventura:      "9fa0384f4a16e1269f8103b63f74407572352f732b00b2d01398b99ab40dc82b"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "6372d211183ce4852a94c8a537651e2ad8fcb2e51f9aa75f7bf081ee54b2e706"
  end

  def install
    share.install self.class::ROOTFS_IMAGE
    (etc/"cartesi/images").install_symlink share/self.class::ROOTFS_IMAGE => "rootfs.ext2"
  end

  test do
    assert_path_exists etc/"cartesi/images/rootfs.ext2"
  end
end
