class CartesiMachineLinuxImage < Formula
  desc "Kernel image for the Cartesi Machine"
  homepage "https://github.com/cartesi/machine-linux-image"

  VERSION = "0.21.0".freeze
  LINUX_IMAGE = "linux-6.5.13-ctsi-2-v#{VERSION}.bin".freeze
  url "https://github.com/cartesi/machine-linux-image/releases/download/v#{VERSION}/#{LINUX_IMAGE}"
  sha256 "5c900060da2db2bfa84cd39cd9cd722988c83c42225f3cac55f2d3157e48f32f"
  license "GPL-2.0-only"
  revision 1

  def install
    share.install self.class::LINUX_IMAGE
    (etc/"cartesi/images").install_symlink share/self.class::LINUX_IMAGE => "linux.bin"
  end

  test do
    assert_path_exists etc/"cartesi/images/linux.bin"
  end
end
