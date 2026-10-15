class CartesiMachineEmulator < Formula
  desc "Off-chain implementation of the Cartesi Machine"
  homepage "https://github.com/cartesi/machine-emulator"
  url "https://github.com/cartesi/machine-emulator/archive/refs/tags/v0.22.0.tar.gz"
  sha256 "7e82de5bfe213b9ca821a65c79a59dc593fff47ed6e8cf5accf36e9bb7b913fe"
  license "LGPL-3.0-only"

  depends_on "boost" => :build
  depends_on "llvm" => :build
  depends_on "pkg-config" => :build
  depends_on "libomp"
  depends_on "libslirp"
  depends_on "lua@5.4"

  patch :p1 do
    url "https://github.com/cartesi/machine-emulator/releases/download/v0.22.0/add-generated-files.diff"
    sha256 "f9050dd452caf8762aad0b74b59d5601aa64f44433dc691edc254b6e3f90d168"
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
