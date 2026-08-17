# Cartesi Homebrew Tap

Homebrew formulae for [Cartesi](https://cartesi.io) tooling: the Cartesi Machine emulator, its
kernel and rootfs images, the Cartesi CLI, and supporting build tools.

## Installation

Add the tap once:

```shell
brew tap cartesi/tap
```

Then install any of the formulae below:

```shell
brew install cartesi-machine
```

You can also install without tapping first, by using the fully qualified name:

```shell
brew install cartesi/tap/cartesi-machine
```

## Formulae

| Formula | Description |
| --- | --- |
| [`cartesi`](Formula/cartesi.rb) | CLI for developing Cartesi applications ([cartesi/cli](https://github.com/cartesi/cli)) |
| [`cartesi-machine`](Formula/cartesi-machine.rb) | Metapackage that pulls in the emulator plus the Linux and rootfs images |
| [`cartesi-machine-emulator`](Formula/cartesi-machine-emulator.rb) | Off-chain implementation of the Cartesi Machine ([cartesi/machine-emulator](https://github.com/cartesi/machine-emulator)) |
| [`cartesi-machine-linux-image`](Formula/cartesi-machine-linux-image.rb) | Kernel image for the Cartesi Machine ([cartesi/machine-linux-image](https://github.com/cartesi/machine-linux-image)) |
| [`cartesi-machine-rootfs-image`](Formula/cartesi-machine-rootfs-image.rb) | Rootfs image for the Cartesi Machine ([cartesi/machine-guest-tools](https://github.com/cartesi/machine-guest-tools)) |
| [`xgenext2fs`](Formula/xgenext2fs.rb) | Ext2 filesystem generator for embedded systems ([cartesi/genext2fs](https://github.com/cartesi/genext2fs)) |

`cartesi-machine` is the recommended entry point: it is a metapackage with no files of its own that
depends on the emulator and both images, so a single install gives you a machine that boots out of
the box.

### Usage

Install the machine and run it:

```shell
brew install cartesi-machine
cartesi-machine --version
cartesi-machine -- "echo hello from inside the machine"
```

Install the CLI to scaffold and run applications:

```shell
brew install cartesi
cartesi --version
```

The image formulae install their payloads into `$(brew --prefix)/etc/cartesi/images`, symlinked as
`linux.bin` and `rootfs.ext2`. The emulator is configured at build time to look there, so it picks
up the images automatically once both formulae are installed.

## Supported platforms

Prebuilt bottles are published to `ghcr.io/v2/cartesi/tap` for Apple Silicon macOS (Sequoia and
Tahoe). The images and the metapackage ship platform-independent bottles.

On any other platform — Intel macOS or Linux — Homebrew falls back to building from source, which
requires the usual toolchain and the build dependencies declared in each formula. Building the
emulator from source can take several minutes.

## Updating and uninstalling

```shell
brew update
brew upgrade cartesi-machine

brew uninstall cartesi-machine
brew untap cartesi/tap
```

## Contributing

Formula changes are made via pull request against `main`.

1. Edit the formula under `Formula/` — bump `url`/`sha256` for a new upstream release, or bump
   `revision` when only the packaging changes.
2. Open a pull request. The `brew test-bot` workflow runs `brew audit`, `brew install`, and the
   formula's `test do` block on every supported macOS runner, and uploads the resulting bottles as
   build artifacts.
3. Once CI is green, a maintainer applies the `pr-pull` label. That triggers `brew pr-pull`, which
   downloads the bottles from the run, uploads them to the GitHub Packages registry, commits the
   updated `bottle do` blocks, and pushes to `main`.

Do not commit `bottle do` checksums by hand — `brew pr-pull` generates them from the bottles CI
actually built.

To test a local change before opening a pull request:

```shell
brew install --build-from-source ./Formula/<formula>.rb
brew test ./Formula/<formula>.rb
brew audit --strict --online ./Formula/<formula>.rb
```

## Troubleshooting

- **`Error: No available formula with the name ...`** — run `brew update` to refresh the tap.
- **A bottle is missing for your platform** — pass `--build-from-source` to build locally.
- **Stale images after an upgrade** — `brew reinstall cartesi-machine-linux-image
  cartesi-machine-rootfs-image` recreates the symlinks under `etc/cartesi/images`.

## More information

- Documentation: https://docs.cartesi.io
- Cartesi on GitHub: https://github.com/cartesi
