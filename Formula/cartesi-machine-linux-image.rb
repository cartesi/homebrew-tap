class CartesiMachineLinuxImage < Formula
  desc "Kernel image for the Cartesi Machine"
  homepage "https://github.com/cartesi/machine-linux-image"
  VERSION = "0.20.0".freeze
  LINUX_IMAGE = "linux-6.5.13-ctsi-1-v#{VERSION}.bin".freeze
  url "https://github.com/cartesi/image-kernel/releases/download/v#{VERSION}/#{LINUX_IMAGE}"
  sha256 "65dd100ff6204346ac2f50f772721358b5c1451450ceb39a154542ee27b4c947"
  license "GPL-2.0-only"

  bottle do
    root_url "https://ghcr.io/v2/cartesi/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe: "ac3a16d05cdc90a34f7c4dd868cd91163c0ea0be5045d35ccb9cbe4318b8cca3"
  end

  def install
    share.install self.class::LINUX_IMAGE
    (etc/"cartesi/images").install_symlink share/self.class::LINUX_IMAGE => "linux.bin"
  end

  test do
    assert_path_exists etc/"cartesi/images/linux.bin"
  end
end
