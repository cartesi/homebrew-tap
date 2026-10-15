class CartesiMachineLinuxImage < Formula
  desc "Kernel image for the Cartesi Machine"
  homepage "https://github.com/cartesi/linux"
  url "https://github.com/cartesi/linux/releases/download/v6.18.56-ctsi-1/linux-6.18.56-ctsi-1.bin"
  version "6.18.56-ctsi-1"
  sha256 "ad12ad141e639fb7b8ce0477dfbb7aa7a4d178222b06e0ce9b335a1c5230f0e1"
  license "GPL-2.0-only"

  bottle do
    root_url "https://ghcr.io/v2/cartesi/tap"
    sha256 cellar: :any_skip_relocation, all: "13ba0ef57e799ba8b1402ea3215041687963d9db4b3348f726c5ff67f0133fff"
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
