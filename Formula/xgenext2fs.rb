class Xgenext2fs < Formula
  desc "Ext2 filesystem generator for embedded systems"
  homepage "https://github.com/cartesi/genext2fs"
  url "https://github.com/cartesi/genext2fs/archive/refs/tags/v1.5.6.tar.gz"
  sha256 "34bfc26a037def23b85b676912462a3d126a87ef15c66c212b3500650da44f9e"
  license "GPL-2.0-only"

  bottle do
    root_url "https://ghcr.io/v2/cartesi/tap"
    sha256 cellar: :any, arm64_tahoe:   "9b5dee4622888f6a9864b4b62a51e74a6f74091fea3414964fa9d2b2d598d2f9"
    sha256 cellar: :any, arm64_sequoia: "813832d54d03fb243d1fdb2063ec5721cb1a36efedb86d83e7b6676f708cec75"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libarchive"

  def install
    system "./autogen.sh"
    system "./configure", *std_configure_args
    system "make", "install"
  end

  test do
    assert_match "xgenext2fs #{version}", shell_output("#{bin}/xgenext2fs --version")

    (testpath/"root").mkpath
    (testpath/"root/hello.txt").write "hello"

    # build an image from a directory
    system bin/"xgenext2fs", "-f", "-b", "1024", "-d", testpath/"root", testpath/"from-dir.ext2"
    assert_path_exists testpath/"from-dir.ext2"

    # build an image from a tarball, which exercises the libarchive support
    system "tar", "-czf", testpath/"root.tar.gz", "-C", testpath/"root", "."
    system bin/"xgenext2fs", "-f", "-b", "1024", "-a", testpath/"root.tar.gz", testpath/"from-tar.ext2"
    assert_path_exists testpath/"from-tar.ext2"
  end
end
