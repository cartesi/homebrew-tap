class CartesiMachineEmulator < Formula
  desc "Off-chain implementation of the Cartesi Machine"
  homepage "https://github.com/cartesi/machine-emulator"
  url "https://github.com/cartesi/machine-emulator/archive/refs/tags/v0.23.0.tar.gz"
  sha256 "a8136b43648ce32db5e6172a3d59eadafc6e5d7905f8d3589eb3fe71de89995a"
  license "LGPL-3.0-only"

  bottle do
    root_url "https://ghcr.io/v2/cartesi/tap"
    manifest_sha256 "917af642888e71c100a6f288e7266ca86526af6dd01800c274a732e487349a25"
    sha256 cellar: :any, arm64_tahoe:   "e7b3337342ea0f95a8e20901abef52199d66e90a3a97494c37465921151983fe"
    sha256 cellar: :any, arm64_sequoia: "ceb114e7e6fdfe89d67d7608b6674914692c5b06f131612f0ab40c317eca35c5"
  end

  depends_on "boost" => :build
  depends_on "llvm" => :build
  depends_on "pkg-config" => :build
  depends_on "libomp"
  depends_on "libslirp"
  depends_on "lua@5.4"

  patch :p1 do
    url "https://github.com/cartesi/machine-emulator/releases/download/v0.23.0/add-generated-files.diff"
    sha256 "545051fabebea59c5d4943ca5c7b341b13d2862c27b22b77240c0387a10d86ab"
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
