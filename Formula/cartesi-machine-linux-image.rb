class CartesiMachineLinuxImage < Formula
  desc "Kernel image for the Cartesi Machine"
  homepage "https://github.com/cartesi/machine-linux-image"

  bottle do
    root_url "https://ghcr.io/v2/cartesi/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "13b9017add8be28ba291992b0f51b1a583e22a4ff695127c8eb3ad8518b5549f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "198e2417a3afae903fe3235fdf81953ff1c71cb65cc6eade477947f5e10094fb"
  end

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
