class CartesiRollupsNode < Formula
  desc "Reference implementation of the Cartesi Rollups Node"
  homepage "https://github.com/cartesi/rollups-node"
  url "https://github.com/cartesi/rollups-node/archive/refs/tags/v2.0.0-alpha.14.tar.gz"
  sha256 "988db7e508653697c0db72407027b1ec00a92a3bf94cb3f979c12f80ef074c14"
  license "Apache-2.0"
  revision 1

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+(?:-alpha\.\d+)?)$/i)
  end

  bottle do
    root_url "https://ghcr.io/v2/cartesi/tap"
    manifest_sha256 "9ad8b02e4d4ddb545104a90337c5b8c89752edcda37ca2ea5755a16056aa4b72"
    sha256 cellar: :any, arm64_tahoe:   "bb2b915874a109add5f87e7a8412dfb190c9d936dd05b3b8f3535b3a9b2d5c76"
    sha256 cellar: :any, arm64_sequoia: "cad6012525cdd4cb4e8dbd71711ee2aa22b08c2ac1d73b9b11c514f6bd83e914"
  end

  depends_on "go" => :build
  # 2.0.0-alpha.14 targets the emulator 0.22 (its Dockerfile pins
  # EMULATOR_VERSION 0.22.0 and it requires MARCHID 22); 0.23 changed the C
  # API, the machine config archive and MARCHID, so build against the keg-only
  # 0.22 formula.
  depends_on "cartesi-machine-emulator@0.22"

  def install
    emulator = Formula["cartesi-machine-emulator@0.22"]

    # The emulator is keg-only, so point cgo at its headers and libraries and
    # bake an rpath so the node binaries find libcartesi at runtime.
    ENV["CGO_CFLAGS"] = "-I#{emulator.opt_include}"
    ENV["CGO_LDFLAGS"] = "-L#{emulator.opt_lib}"
    ldflags = %W[
      -s -w
      -X github.com/cartesi/rollups-node/internal/version.BuildVersion=#{version}
      -r #{emulator.opt_lib}
    ]

    # These link against libcartesi and spawn `cartesi-jsonrpc-machine`. Build
    # them into bin, then let env_script_all_files move everything currently in
    # bin to libexec/bin and leave wrappers in bin that prepend the emulator's
    # bin, so the server is found even when the Homebrew prefix is not on PATH.
    machine_binaries = %w[node advancer validator]
    machine_binaries.each do |name|
      system "go", "build", *std_go_args(ldflags:, output: bin/"cartesi-rollups-#{name}"),
             "./cmd/cartesi-rollups-#{name}"
    end
    bin.env_script_all_files(libexec/"bin", PATH: "#{emulator.opt_bin}:$PATH")

    # The remaining services and tools are pure Go.
    other_binaries = %w[cli evm-reader claimer jsonrpc-api prt machine-tool]
    other_binaries.each do |name|
      system "go", "build", *std_go_args(ldflags:, output: bin/"cartesi-rollups-#{name}"),
             "./cmd/cartesi-rollups-#{name}"
    end
  end

  test do
    assert_match "cartesi-rollups-cli version #{version}", shell_output("#{bin}/cartesi-rollups-cli --version")
    # Exercises the wrapper and dynamic linking against the emulator.
    assert_match "cartesi-rollups-node version #{version}", shell_output("#{bin}/cartesi-rollups-node --version")
    assert_match "cartesi-rollups-advancer version #{version}",
                 shell_output("#{bin}/cartesi-rollups-advancer --version")
  end
end
