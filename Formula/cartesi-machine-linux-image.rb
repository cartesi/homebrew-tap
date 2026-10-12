class CartesiMachineLinuxImage < Formula
  desc "Kernel image for the Cartesi Machine"
  homepage "https://github.com/cartesi/linux"
  url "https://github.com/cartesi/linux/releases/download/v6.18.38-ctsi-1-test3/linux-6.18.38-ctsi-1.bin"
  version "6.18.38-ctsi-1"
  sha256 "8e516c496e55089df2d8db9f5d047a84967e0e29cf71b2c4a7f9e5305e58dcc2"
  license "GPL-2.0-only"

  def install
    linux_image = File.basename(stable.url)
    share.install linux_image
    (etc/"cartesi/images").install_symlink share/linux_image => "linux.bin"
  end

  test do
    assert_path_exists etc/"cartesi/images/linux.bin"
  end
end
