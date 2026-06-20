class Remarkablesync < Formula
  desc "Backup and convert reMarkable tablet notebooks to PDF"
  homepage "https://github.com/JeffSteinbok/RemarkableSync"
  url "https://github.com/JeffSteinbok/reMarkableSync/archive/refs/tags/v2.1.4.tar.gz"
  sha256 "4a6749442d0acfc0f46a97d052dbfece76dd95f30d00306f11ef6066cc43ccb1"
  license "MIT"
  head "https://github.com/JeffSteinbok/RemarkableSync.git", branch: "main"

  depends_on "python@3.13"
  depends_on "cairo"       # Required for reportlab PDF generation
  depends_on "pkg-config"  # Required for building some Python packages

  def install
    # Get the python dependency
    python3 = Formula["python@3.13"].opt_bin/"python3.13"

    # Create virtualenv in libexec
    system python3, "-m", "venv", libexec

    # Install the package using pip in the virtualenv
    system libexec/"bin/pip", "install", "--upgrade", "pip", "setuptools", "wheel"
    system libexec/"bin/pip", "install", buildpath

    # Create bin wrappers
    bin.install_symlink libexec/"bin/RemarkableSync"
  end

  test do
    # Test that the command runs and shows help
    assert_match "RemarkableSync", shell_output("#{bin}/RemarkableSync --help")

    # Test that rmc is available in the virtualenv
    system libexec/"bin/pip", "show", "rmc"
  end
end
