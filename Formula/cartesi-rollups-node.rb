class CartesiRollupsNode < Formula
  desc "Reference implementation of the Cartesi Rollups Node"
  homepage "https://github.com/cartesi/rollups-node"
  url "https://github.com/cartesi/rollups-node/archive/refs/tags/v2.0.0-alpha.13.tar.gz"
  sha256 "05a4ba96c3c69cd802a93c909479dce69d70e4adebe39cdd59cabce26f21ef01"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+(?:-alpha\.\d+)?)$/i)
  end

  depends_on "go" => :build
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
