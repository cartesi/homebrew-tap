class CartesiSlingNode < Formula
  desc "Dave PRT validator node for Cartesi Rollups applications"
  homepage "https://github.com/cartesi/dave"
  url "https://github.com/cartesi/dave/archive/refs/tags/v3.0.0-alpha.6.tar.gz"
  sha256 "20eeecc8c64593f425a01cb895d038f79fa765ab082fa37d2f11fa38e7253b39"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+(?:-alpha\.\d+)?)$/i)
  end

  bottle do
    root_url "https://ghcr.io/v2/cartesi/tap"
    manifest_sha256 "763e7ff3ed70916d58488da4f372706393290e8afa2134ab8520c986ffe512c6"
    sha256 cellar: :any, arm64_tahoe:   "babf9d223e4a7665ea408abbe29a60f4d00dca243c677d33ef756e02b0883511"
    sha256 cellar: :any, arm64_sequoia: "3019a460619ff3638667ee474e222c4c8450829be01541c7b15a7c11b3d1022c"
  end

  # 3.0.0-alpha.6 pins the emulator 0.22.0 (machine/script/cartesi-machine-source.sh)
  # and links libcartesi statically, so the keg-only 0.22 formula is only
  # needed to build.
  depends_on "cartesi-machine-emulator@0.22" => :build
  depends_on "cmake" => :build # aws-lc-sys
  depends_on "rust" => :build
  # The static libcartesi.a from the formula above references these.
  depends_on "libomp"
  depends_on "libslirp"

  uses_from_macos "llvm" => :build # libclang for bindgen

  # Compiled contracts published with the release, from which the contract
  # bindings (generated code upstream does not commit) are made. Binding them
  # with `forge bind --skip-build` avoids compiling the contracts, which would
  # need the machine/step submodule (absent from the source tarball), the
  # soldeer dependencies and solc.
  resource "contract-artifacts" do
    url "https://github.com/cartesi/dave/releases/download/v3.0.0-alpha.6/cartesi-rollups-prt-3.0.0-alpha.6-contract-artifacts.tar.gz"
    sha256 "6938b679cddeef51becc5ca512fa9e2d0dfb0a55686985b2803e1ce7ba004ad4"
  end

  # The forge release upstream pins (FOUNDRY_VERSION in the justfile). Binding
  # the artifacts with it reproduces upstream's bindings byte for byte; the
  # newer Homebrew foundry generates code that needs a newer alloy-sol-types
  # than Cargo.lock pins (`SolEventInterface::decode_raw_log_with_config`), so
  # it does not compile.
  resource "forge" do
    on_macos do
      on_arm do
        url "https://github.com/foundry-rs/foundry/releases/download/v1.5.1/foundry_v1.5.1_darwin_arm64.tar.gz"
        sha256 "b3bf1752be066e0877911721e0624058171c88fc5616e228937fe4620b41c40d"
      end
      on_intel do
        url "https://github.com/foundry-rs/foundry/releases/download/v1.5.1/foundry_v1.5.1_darwin_amd64.tar.gz"
        sha256 "a416e79c26d32cd37316232f790b3a1bdeae4dfae09d82627d7a1ace4c281848"
      end
    end
    on_linux do
      on_arm do
        url "https://github.com/foundry-rs/foundry/releases/download/v1.5.1/foundry_v1.5.1_linux_arm64.tar.gz"
        sha256 "cccf28bdf202289e837a9e21ed213b2b80dc1e806e12f1717bc98a44315c331e"
      end
      on_intel do
        url "https://github.com/foundry-rs/foundry/releases/download/v1.5.1/foundry_v1.5.1_linux_amd64.tar.gz"
        sha256 "73640b01bd9ed29fdb4965085099371f8cf0dbbec3e2086cf54564efc4dcfe88"
      end
    end
  end

  def install
    resource("contract-artifacts").stage do
      (buildpath/"prt/contracts").install "prt/contracts/out"
      (buildpath/"cartesi-rollups/contracts").install "cartesi-rollups/contracts/out"
    end
    resource("forge").stage { (buildpath/"forge").install "forge" }

    # Same selections and flags as script/contract-bindings.sh.
    {
      "prt/contracts"             => "^(CartesiStateTransition|MultiLevelTournamentFactory|Tournament)$",
      "cartesi-rollups/contracts" => "^(I?DaveConsensus|I?DaveAppFactory)$",
    }.each do |dir, select|
      cd dir do
        system buildpath/"forge/forge", "bind", "--skip-build", "--alloy", "--alloy-version", "2",
               "--select", select, "--module", "--bindings-path", "./bindings-rs/src/contract",
               "--skip-extra-derives", "--root", "."
      end
    end

    # Link the emulator's static library instead of building the machine/emulator
    # submodule, which is also absent from the source tarball.
    emulator = Formula["cartesi-machine-emulator@0.22"]
    ENV["LIBCARTESI_PATH"] = emulator.opt_lib.to_s
    ENV["INCLUDECARTESI_PATH"] = (emulator.opt_include/"cartesi-machine").to_s
    # The node's startup line names this release.
    ENV["CARTESI_SLING_RELEASE"] = "v#{version}"

    system "cargo", "install", *std_cargo_args(path: "cartesi-rollups/node")
  end

  test do
    # The node logs its release and the linked emulator before parsing its
    # arguments, then exits 2 on the missing required ones.
    output = shell_output("#{bin}/cartesi-sling-node 2>&1", 2)
    assert_match "Hello from the sling node (v#{version}, Cartesi Machine 0.22.0", output
    assert_match "PRT validator", shell_output("#{bin}/cartesi-sling-node --help")
  end
end
