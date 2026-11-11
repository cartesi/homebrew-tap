class CartesiRollupsNode < Formula
  desc "Reference implementation of the Cartesi Rollups Node"
  homepage "https://github.com/cartesi/rollups-node"
  url "https://github.com/cartesi/rollups-node/archive/refs/tags/v2.0.0-alpha.14.tar.gz"
  sha256 "988db7e508653697c0db72407027b1ec00a92a3bf94cb3f979c12f80ef074c14"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+(?:-alpha\.\d+)?)$/i)
  end

  bottle do
    root_url "https://ghcr.io/v2/cartesi/tap"
    sha256 cellar: :any, arm64_tahoe:   "80727da8ec7e6f511bf2a06216699ed436bb42151366eaf7839018b255aa82df"
    sha256 cellar: :any, arm64_sequoia: "60eb7c25888a8514ea81ac66cbdd0f64700a1897d777ddeceb9c79196ddd67f8"
  end

  depends_on "go" => :build
  # 2.0.0-alpha.14 targets the emulator 0.22 (its Dockerfile pins
  # EMULATOR_VERSION 0.22.0).
  depends_on "cartesi-machine-emulator"

  def install
    emulator = Formula["cartesi-machine-emulator"]

    # Point cgo at the emulator's headers and libraries and bake an rpath to its
    # opt prefix so the node binaries find libcartesi at runtime.
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
