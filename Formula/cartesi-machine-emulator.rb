class CartesiMachineEmulator < Formula
  desc "Off-chain implementation of the Cartesi Machine"
  homepage "https://github.com/cartesi/machine-emulator"
  url "https://github.com/cartesi/machine-emulator/archive/refs/tags/v0.19.0.tar.gz"
  sha256 "1a33fb7e0dd7030656ddbb214dcd2f5a569f64e906edb20f149b66b34e1e0dd3"
  license "LGPL-3.0-only"

  bottle do
    root_url "https://ghcr.io/v2/cartesi/tap"
    sha256                               arm64_sonoma: "28c8e21cdfd975b693161bc7db6d20a4e3f1258806fb22be6913d2ecf4ab9e28"
    sha256 cellar: :any,                 ventura:      "0c03b6c31cbf09766fd61792e42a07c2d141cb622b0be2ffae477028aeef4c3d"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "f5fa9046162e7d49c91483b8aeec84ced3e8f79ab17d41bb0bc865527fdc371d"
  end

  depends_on "boost@1.85" => :build
  depends_on "pkg-config" => :build
  depends_on "libslirp"
  depends_on "lua"

  patch :p1 do
    url "https://github.com/cartesi/machine-emulator/releases/download/v0.19.0/add-generated-files.diff"
    sha256 "a892e2d9f5c331f5e80bcb5db4133e7db625aa4d14ffdf9467b75c4c34d1744f"
  end

  def install
    cartesi_prefix = (etc/"cartesi/images")
    cartesi_prefix.mkpath
    (share/"cartesi-machine").mkpath
    system "make", "BREW_PREFIX=#{prefix}"
    system "make", "install", "PREFIX=#{prefix}", "IMAGES_RUNTIME_PATH=#{cartesi_prefix.realpath}"
  end

  test do
    assert_match(/cartesi-machine #{version}/, shell_output("#{bin}/cartesi-machine --version | head -1"))
  end
end
