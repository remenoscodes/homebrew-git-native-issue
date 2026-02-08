class GitNativeIssue < Formula
  desc "Distributed issue tracking using Git's native data model"
  homepage "https://github.com/remenoscodes/git-native-issue"
  url "https://github.com/remenoscodes/git-native-issue/releases/download/v1.1.0/git-native-issue-v1.1.0.tar.gz"
  sha256 "fe66c2eb4894e5bf451f48739a5d83363716498a59e4396d3c281682364cb80f"
  license "GPL-2.0-only"
  version "1.1.0"

  depends_on "git"

  def install
    # Install binaries
    bin.install Dir["bin/*"]

    # Install man pages if present
    man1.install Dir["doc/*.1"] if Dir.exist?("doc")

    # Install documentation
    doc.install "README.md", "LICENSE", "ISSUE-FORMAT.md"
  end

  test do
    system "#{bin}/git-issue", "version"
    assert_match "1.0.2", shell_output("#{bin}/git-issue version")
  end
end
