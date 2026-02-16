class GitNativeIssue < Formula
  desc "Distributed issue tracking using Git's native data model"
  homepage "https://github.com/remenoscodes/git-native-issue"
  url "https://github.com/remenoscodes/git-native-issue/releases/download/v1.3.1/git-native-issue-v1.3.1.tar.gz"
  sha256 "8848a70eb146d6f9695a4b78e8d36804026d95ab77658682b3e343c82440a5d1"
  license "GPL-2.0-only"
  version "1.3.1"

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
    assert_match "1.3.1", shell_output("#{bin}/git-issue version")
  end
end
