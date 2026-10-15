class CartesiMachineEmulatorAT021 < Formula
  desc "Off-chain implementation of the Cartesi Machine"
  homepage "https://github.com/cartesi/machine-emulator"
  url "https://github.com/cartesi/machine-emulator/archive/refs/tags/v0.21.0.tar.gz"
  sha256 "44fc83cb08a1907e66ab225ccf421b0fdad3f145be35b9a9ffe561d3563e3eda"
  license "LGPL-3.0-only"

  livecheck do
    url :stable
    regex(/^v?(0\.21(?:\.\d+)+)$/i)
  end

  bottle do
    root_url "https://ghcr.io/v2/cartesi/tap"
    sha256 cellar: :any, arm64_tahoe:   "a4f75beee1b7cb6402523c982e33bbe0caf9e6dc8fd678a74bab818fe4d7e339"
    sha256 cellar: :any, arm64_sequoia: "1b783953d2433c653a94587ddc9d7dba08dcc24177e5d13a8bcc9fc190ad1c3c"
  end

  # Versioned emulator kept for consumers that still target the 0.21 C API,
  # namely cartesi-rollups-node. Keg-only so it never shadows the current
  # cartesi-machine-emulator formula.
  keg_only :versioned_formula

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
    assert_path_exists include/"cartesi-machine/cm.h"
    assert_path_exists include/"cartesi-machine/cm-jsonrpc.h"
  end
end
