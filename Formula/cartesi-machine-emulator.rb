class CartesiMachineEmulator < Formula
  desc "Off-chain implementation of the Cartesi Machine"
  homepage "https://github.com/cartesi/machine-emulator"
  url "https://github.com/cartesi/machine-emulator/archive/refs/tags/v0.21.0.tar.gz"
  sha256 "44fc83cb08a1907e66ab225ccf421b0fdad3f145be35b9a9ffe561d3563e3eda"
  license "LGPL-3.0-only"
  revision 1

  bottle do
    root_url "https://ghcr.io/v2/cartesi/tap"
    sha256 arm64_tahoe:   "17884f95a498193147c668592000b7342d81fec93851b3713bd3bda69208835f"
    sha256 arm64_sequoia: "61fa160b84c3d116d5003edbca53005f661cfee6053f155b4a33b23effabcffb"
  end

  depends_on "boost" => :build
  depends_on "llvm" => :build
  depends_on "pkg-config" => :build
  depends_on "libomp"
  depends_on "libslirp"
  depends_on "lua@5.4"

  patch :p1 do
    url "https://github.com/cartesi/machine-emulator/releases/download/v0.21.0/add-generated-files.diff"
    sha256 "596c5e171cac2e784aef01a26d47d19964b8593f74e37e863e0fcc1c9446be23"
  end

  def install
    ENV.llvm_clang # use brew llvm clang
    cartesi_prefix = (etc/"cartesi/images")
    cartesi_prefix.mkpath
    (share/"cartesi-machine").mkpath
    system "make", "BREW_PREFIX=#{prefix}"
    system "make", "install", "PREFIX=#{prefix}", "IMAGES_RUNTIME_PATH=#{cartesi_prefix.realpath}"

    # lua@5.4 is keg-only, so `lua5.4` is not on PATH at runtime. Rewrite the
    # generated wrapper scripts to invoke it by absolute path.
    inreplace [bin/"cartesi-machine", bin/"cartesi-machine-stored-hash"],
              /^lua5\.4 /, "#{formula_opt_bin("lua@5.4")}/lua5.4 "
  end

  test do
    assert_match(/cartesi-machine #{version}/, shell_output("#{bin}/cartesi-machine --version | head -1"))
  end
end
