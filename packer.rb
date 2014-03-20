require 'formula'

class Packer < Formula
  homepage 'http://www.packer.io'
  version '0.5.2'

  if Hardware.is_64_bit?
    url 'https://dl.bintray.com/mitchellh/packer/0.5.2_darwin_amd64.zip'
    sha256 '1c3c881c4a29cc71617a87503557df684977d86b966f5ed0273298e2f6221594'
  else
    url 'https://dl.bintray.com/mitchellh/packer/0.5.2_darwin_386.zip'
    sha256 '32849dcbbb83b86d0d3f621705224ee580d3215f4060913f0bcbc974035ffd00'
  end

  depends_on :arch => :intel

  def install
    bin.install Dir['*']
  end

  test do
    minimal = testpath/"minimal.json"
    minimal.write <<-EOS.undent
      {
        "builders": [{
          "type": "amazon-ebs",
          "region": "us-east-1",
          "source_ami": "ami-59a4a230",
          "instance_type": "m3.medium",
          "ssh_username": "ubuntu",
          "ami_name": "homebrew packer test - {{timestamp}}"
        }],
        "provisioners": [{
          "type": "shell",
          "inline": [
            "sleep 30",
            "sudo apt-get update"
          ]
        }]
      }
    EOS
    system "#{bin}/packer", "validate", minimal
  end
end
