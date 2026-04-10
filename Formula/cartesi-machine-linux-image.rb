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
    sha256 cellar: :any_skip_relocation, arm64_sonoma: "5dbfb76e39ea0749cb96be113bfdf546d94d53dc167acc433ae8dc8676aa7bbc"
    sha256 cellar: :any_skip_relocation, ventura:      "096a8524db3dc659c957a0186cf6b34d95eff25e48325652e96cbad843406727"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "9a025f231e8f5a76bcdaca2ed1e284e1ac8f7996f219b7c6fbcc2d92206fcdee"
  end

  def install
    share.install self.class::LINUX_IMAGE
    (etc/"cartesi/images").install_symlink share/self.class::LINUX_IMAGE => "linux.bin"
  end

  test do
    assert_path_exists etc/"cartesi/images/linux.bin"
  end
end
