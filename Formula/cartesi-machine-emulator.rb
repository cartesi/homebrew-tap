class CartesiMachineEmulator < Formula
  desc "Off-chain implementation of the Cartesi Machine"
  homepage "https://github.com/cartesi/machine-emulator"
  url "https://github.com/cartesi/machine-emulator/archive/refs/tags/v0.21.0-test7.tar.gz"
  version "0.21.0"
  sha256 "6145183e9ef40fd79b4a7d160161c44c78e81c29c920c27720466b4fed279029"
  license "LGPL-3.0-only"

  depends_on "boost" => :build
  depends_on "pkg-config" => :build
  depends_on "libomp"
  depends_on "libslirp"
  depends_on "lua@5.4"

  patch :p1 do
    url "https://github.com/cartesi/machine-emulator/releases/download/v0.21.0-test7/add-generated-files.diff"
    sha256 "9830b46a54df8170cc74c894b8fce2e7a6152601afd9a1a31c8aeee64294b9f0"
  end

  def install
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
