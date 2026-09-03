class CartesiRollupsNode < Formula
  desc "Reference implementation of the Cartesi Rollups Node"
  homepage "https://github.com/cartesi/rollups-node"
  url "https://github.com/cartesi/rollups-node/archive/refs/tags/v2.0.0-alpha.12.tar.gz"
  sha256 "8fcf4d775c7637b7698e642c70c31b7c16af28b77c118207a90d93da6187fc9a"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+(?:-alpha\.\d+)?)$/i)
  end

  depends_on "go" => :build
  # 2.0.0-alpha.x builds against the 0.20 C API (machine-c-api.h), which the
  # current cartesi-machine-emulator (0.21) renamed and changed.
  depends_on "cartesi-machine-emulator@0.20"

  def install
    emulator = Formula["cartesi-machine-emulator@0.20"]

    # The emulator is keg-only, so point cgo at its headers and libraries and
    # bake an rpath so the node binaries find libcartesi at runtime.
    ENV["CGO_CFLAGS"] = "-I#{emulator.opt_include}"
    ENV["CGO_LDFLAGS"] = "-L#{emulator.opt_lib}"
    ldflags = %W[
      -s -w
      -X github.com/cartesi/rollups-node/internal/version.BuildVersion=#{version}
      -r #{emulator.opt_lib}
    ]

    # These link against libcartesi and spawn `cartesi-jsonrpc-machine`, which
    # lives in the keg-only emulator and is therefore not on PATH. Build them
    # into bin, then let env_script_all_files move everything currently in bin
    # to libexec/bin and leave wrappers in bin that prepend the emulator's bin.
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
    # Exercises the wrapper and dynamic linking against the keg-only emulator.
    assert_match "cartesi-rollups-node version #{version}", shell_output("#{bin}/cartesi-rollups-node --version")
    assert_match "cartesi-rollups-advancer version #{version}",
                 shell_output("#{bin}/cartesi-rollups-advancer --version")
  end
end
