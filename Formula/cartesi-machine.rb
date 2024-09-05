class CartesiMachine < Formula
  desc "Off-chain implementation of the Cartesi Machine"
  homepage "https://cartesi.io/"
  url "https://github.com/cartesi/machine-emulator/archive/refs/tags/v0.18.1.tar.gz"
  sha256 "2d6ca78881b0a218aa9460d5cc7af7be51f9971b163305d6191039719568b5c3"
  license "LGPL-3.0-only"

  depends_on "boost" => :build
  depends_on "pkg-config" => :build
  depends_on "libslirp"
  depends_on "lua"

  resource "linux" do
    url "https://github.com/cartesi/image-kernel/releases/download/v0.20.0/linux-6.5.13-ctsi-1-v0.20.0.bin"
    sha256 "65dd100ff6204346ac2f50f772721358b5c1451450ceb39a154542ee27b4c947"
  end

  resource "rootfs" do
    url "https://github.com/cartesi/machine-emulator-tools/releases/download/v0.16.1/rootfs-tools-v0.16.1.ext2"
    sha256 "4db885fdb4f013922d8ea8474768148ac4d45460a4ef30aea823836ea72ffed9"
  end

  patch :p0 do
    url "https://github.com/cartesi/machine-emulator/releases/download/v0.18.1/add-generated-files.diff"
    sha256 "5e239448f47fe33b9c13e6c4c9c605ac16b8663f396909cd57abd6e4b447f1c4"
  end

  def install
    system "make", "BREW_PREFIX=#{prefix}"
    system "make", "install", "PREFIX=#{prefix}"

    (pkgshare/"images").install resource("linux")
    (pkgshare/"images").install resource("rootfs")

    (pkgshare/"images").install_symlink "linux-6.5.13-ctsi-1-v0.20.0.bin" => "linux.bin"
    (pkgshare/"images").install_symlink "rootfs-tools-v0.16.1.ext2" => "rootfs.ext2"
  end

  test do
    assert_match(/cartesi-machine #{version}/, shell_output("#{bin}/cartesi-machine --version | head -1"))
  end
end
