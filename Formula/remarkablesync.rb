class Remarkablesync < Formula
  desc "Backup and convert reMarkable tablet notebooks to PDF"
  homepage "https://github.com/JeffSteinbok/RemarkableSync"
  url "https://github.com/JeffSteinbok/RemarkableSync/archive/refs/tags/v1.0.4.tar.gz"
  sha256 "3824e4806839cf755bf6fc19bb8ec889c74fb1b68032bad4ac4c2bcaaa1e0d85"
  license "MIT"
  head "https://github.com/JeffSteinbok/RemarkableSync.git", branch: "main"

  depends_on "rust" => :build  # For rmc
  depends_on "python@3.13"
  depends_on "cairo"
  depends_on "pkg-config"

  # Python dependencies
  resource "paramiko" do
    url "https://github.com/JeffSteinbok/RemarkableSync/archive/refs/tags/v1.0.4.tar.gz"
    sha256 "3824e4806839cf755bf6fc19bb8ec889c74fb1b68032bad4ac4c2bcaaa1e0d85"
  end

  resource "scp" do
    url "https://github.com/JeffSteinbok/RemarkableSync/archive/refs/tags/v1.0.4.tar.gz"
    sha256 "3824e4806839cf755bf6fc19bb8ec889c74fb1b68032bad4ac4c2bcaaa1e0d85"
  end

  resource "click" do
    url "https://github.com/JeffSteinbok/RemarkableSync/archive/refs/tags/v1.0.4.tar.gz"
    sha256 "3824e4806839cf755bf6fc19bb8ec889c74fb1b68032bad4ac4c2bcaaa1e0d85"
  end

  resource "tqdm" do
    url "https://github.com/JeffSteinbok/RemarkableSync/archive/refs/tags/v1.0.4.tar.gz"
    sha256 "3824e4806839cf755bf6fc19bb8ec889c74fb1b68032bad4ac4c2bcaaa1e0d85"
  end

  resource "PyPDF2" do
    url "https://github.com/JeffSteinbok/RemarkableSync/archive/refs/tags/v1.0.4.tar.gz"
    sha256 "3824e4806839cf755bf6fc19bb8ec889c74fb1b68032bad4ac4c2bcaaa1e0d85"
  end

  resource "reportlab" do
    url "https://github.com/JeffSteinbok/RemarkableSync/archive/refs/tags/v1.0.4.tar.gz"
    sha256 "3824e4806839cf755bf6fc19bb8ec889c74fb1b68032bad4ac4c2bcaaa1e0d85"
  end

  resource "svglib" do
    url "https://github.com/JeffSteinbok/RemarkableSync/archive/refs/tags/v1.0.4.tar.gz"
    sha256 "3824e4806839cf755bf6fc19bb8ec889c74fb1b68032bad4ac4c2bcaaa1e0d85"
  end

  resource "Pillow" do
    url "https://github.com/JeffSteinbok/RemarkableSync/archive/refs/tags/v1.0.4.tar.gz"
    sha256 "3824e4806839cf755bf6fc19bb8ec889c74fb1b68032bad4ac4c2bcaaa1e0d85"
  end

  resource "rmrl" do
    url "https://github.com/JeffSteinbok/RemarkableSync/archive/refs/tags/v1.0.4.tar.gz"
    sha256 "3824e4806839cf755bf6fc19bb8ec889c74fb1b68032bad4ac4c2bcaaa1e0d85"
  end

  def install
    # Install rmc (Rust-based reMarkable converter)
    system "cargo", "install", "--git", "https://github.com/ricklupton/rmc.git", "--root", prefix

    # Install Python dependencies and the main application
    virtualenv_install_with_resources

    # Create a wrapper script that ensures rmc is in PATH
    (bin/"RemarkableSync").write_env_script libexec/"bin/RemarkableSync", PATH: "#{bin}:$PATH"
  end

  test do
    # Test that the command runs and shows help
    assert_match "RemarkableSync", shell_output("#{bin}/RemarkableSync --help")

    # Test that rmc is available
    assert_match "rmc", shell_output("#{bin}/rmc --version")
  end
end
