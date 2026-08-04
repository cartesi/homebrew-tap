class CartesiMachineLinuxImage < Formula
  desc "Kernel image for the Cartesi Machine"
  homepage "https://github.com/cartesi/machine-linux-image"

  bottle do
    root_url "https://ghcr.io/v2/cartesi/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe: "d5f151c66fe5841e77c41e8e213728f294cc91911867c238ecf31ed1101aef7b"
  end
  VERSION = "0.21.0".freeze
  LINUX_IMAGE = "linux-6.5.13-ctsi-2-v#{VERSION}.bin".freeze
  url "https://github.com/cartesi/machine-linux-image/releases/download/v#{VERSION}/#{LINUX_IMAGE}"
  sha256 "5c900060da2db2bfa84cd39cd9cd722988c83c42225f3cac55f2d3157e48f32f"
  license "GPL-2.0-only"

  def install
    share.install self.class::LINUX_IMAGE
    (etc/"cartesi/images").install_symlink share/self.class::LINUX_IMAGE => "linux.bin"
  end

  test do
    assert_path_exists etc/"cartesi/images/linux.bin"
  end
end
