class CartesiMachineLinuxImage < Formula
  desc "Kernel image for the Cartesi Machine"
  homepage "https://github.com/cartesi/machine-linux-image"
  url "https://github.com/cartesi/machine-linux-image/releases/download/v0.21.0/linux-6.5.13-ctsi-2-v0.21.0.bin"
  sha256 "5c900060da2db2bfa84cd39cd9cd722988c83c42225f3cac55f2d3157e48f32f"
  license "GPL-2.0-only"
  revision 2

  bottle do
    root_url "https://ghcr.io/v2/cartesi/tap"
    sha256 cellar: :any_skip_relocation, all: "f8d1d2fd089d2ff4300aecc114337a89679571090a98d02fa93ac6a6fdef0751"
  end

  def install
    linux_image = File.basename(stable.url)
    share.install linux_image
    (etc/"cartesi/images").install_symlink share/linux_image => "linux.bin"
  end

  test do
    assert_path_exists etc/"cartesi/images/linux.bin"
  end
end
