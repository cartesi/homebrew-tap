class CartesiMachineEmulatorAT020 < Formula
  desc "Off-chain implementation of the Cartesi Machine"
  homepage "https://github.com/cartesi/machine-emulator"
  url "https://github.com/cartesi/machine-emulator/archive/refs/tags/v0.20.0.tar.gz"
  sha256 "3746abb72d45dd2388f79fc24b048fe306db8e1f9f7e072176e51b95c4453949"
  license "LGPL-3.0-only"

  livecheck do
    url :stable
    regex(/^v?(0\.20(?:\.\d+)+)$/i)
  end

  # Versioned emulator kept for consumers that still target the 0.20 C API,
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
    url "https://github.com/cartesi/machine-emulator/releases/download/v0.20.0/add-generated-files.diff"
    sha256 "d9c2afcefc2759e7cd37bbedc83d54c81515f0fddb671103b489b8789aee33bb"
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
    assert_path_exists include/"cartesi-machine/machine-c-api.h"
    assert_path_exists include/"cartesi-machine/jsonrpc-machine-c-api.h"
  end
end
