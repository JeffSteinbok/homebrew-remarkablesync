class Remarkablesync < Formula
  desc "Backup and convert reMarkable tablet notebooks to PDF"
  homepage "https://github.com/JeffSteinbok/RemarkableSync"
  url "https://github.com/JeffSteinbok/reMarkableSync/archive/refs/tags/v3.0.0.tar.gz"
  sha256 "c370b81a14c67c7b9857716bce0af275949d59c69584021ad0d91a8e713a8c6b"
  license "MIT"
  revision 1
  head "https://github.com/JeffSteinbok/RemarkableSync.git", branch: "main"

  depends_on "pkgconf" => :build
  depends_on "cairo"
  depends_on "python@3.13"

  def install
    # Get the python dependency
    python3 = formula_opt_bin("python@3.13")/"python3.13"

    # Create virtualenv in libexec
    system python3, "-m", "venv", libexec

    # Install the package using pip in the virtualenv
    system libexec/"bin/pip", "install", "--upgrade", "pip", "setuptools", "wheel"
    system libexec/"bin/pip", "install", buildpath

    # Create bin wrappers
    bin.install_symlink libexec/"bin/reMarkableSync"
  end

  post_install_steps do
    on_macos do
      # Homebrew can rewrite Mach-O load commands during relocation.
      run "/bin/bash", args: ["-o", "pipefail", "-c", <<~SH, "sign-native-extensions", "{{libexec}}"]
        /usr/bin/find "$1" -type f -exec /usr/bin/file -E -0 -0 {} + |
          while IFS= read -r -d '' binary && IFS= read -r -d '' kind; do
            case "$kind" in
              *Mach-O*bundle*|*Mach-O*"shared library"*|*Mach-O*executable*)
                /usr/bin/codesign --force --sign - "$binary" || exit 1
                ;;
            esac
          done
      SH
    end
  end

  test do
    # Test that the command runs and shows help
    assert_match "reMarkableSync", shell_output("#{bin}/reMarkableSync --help")

    # Test that rmc is available in the virtualenv
    system libexec/"bin/pip", "show", "rmc"
  end
end
