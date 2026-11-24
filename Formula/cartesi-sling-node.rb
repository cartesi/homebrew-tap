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

  # 3.0.0-alpha.6 pins the emulator 0.22.0 (machine/script/cartesi-machine-source.sh)
  # and links libcartesi statically, so the keg-only 0.22 formula is only
  # needed to build.
  depends_on "cartesi-machine-emulator@0.22" => :build
  depends_on "cmake" => :build # aws-lc-sys
  # Generates the contract bindings, which upstream does not commit.
  depends_on "foundry" => :build
  depends_on "rust" => :build
  # The static libcartesi.a from the formula above references these.
  depends_on "libomp"
  depends_on "libslirp"

  uses_from_macos "llvm" => :build # libclang for bindgen

  # Compiled contracts published with the release. Binding them with
  # `forge bind --skip-build` avoids compiling the contracts, which would need
  # the machine/step submodule (absent from the source tarball), the soldeer
  # dependencies and solc 0.8.30. It also keeps enums as uint8, as upstream's
  # pinned forge 1.5.1 generates them and the node's code expects.
  resource "contract-artifacts" do
    url "https://github.com/cartesi/dave/releases/download/v3.0.0-alpha.6/cartesi-rollups-prt-3.0.0-alpha.6-contract-artifacts.tar.gz"
    sha256 "6938b679cddeef51becc5ca512fa9e2d0dfb0a55686985b2803e1ce7ba004ad4"
  end

  def install
    resource("contract-artifacts").stage do
      (buildpath/"prt/contracts").install "prt/contracts/out"
      (buildpath/"cartesi-rollups/contracts").install "cartesi-rollups/contracts/out"
    end

    # Same selections and flags as script/contract-bindings.sh.
    {
      "prt/contracts"             => "^(CartesiStateTransition|MultiLevelTournamentFactory|Tournament)$",
      "cartesi-rollups/contracts" => "^(I?DaveConsensus|I?DaveAppFactory)$",
    }.each do |dir, select|
      cd dir do
        system "forge", "bind", "--skip-build", "--alloy", "--alloy-version", "2",
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
