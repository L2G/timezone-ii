require 'spec_helper'

describe 'timezone-ii::default' do
  shared_examples 'an unsupported OS' do |platform_family, platform_version|
    let(:chef_run) do
      allow(::File).to receive(:symlink?).with('/etc/localtime')
        .and_return(false)
      ChefSpec::SoloRunner
        .new(platform: platform_family, version: platform_version)
        .converge(described_recipe)
    end

    specify do
      pending
      expect(chef_run).not_to install_package('tzdata')
    end

    specify do
      expect(chef_run).not_to include_recipe('timezone-ii::linux-generic')
    end

    specify do
      expect(chef_run)
        .to write_log("Don't know how to configure timezone for "\
                      "'#{platform_family}'!")
        .with(level: :error)
    end
  end

  context 'on Amazon Linux' do
    let(:chef_run) do
      allow(::File).to receive(:symlink?).with('/etc/localtime')
        .and_return(false)
      ChefSpec::SoloRunner.new(platform: 'amazon', version: '2014.03')
        .converge(described_recipe)
    end

    specify { expect(chef_run).to install_package('tzdata') }
    specify { expect(chef_run).to include_recipe('timezone-ii::amazon') }
    specify { expect(chef_run).to include_recipe('timezone-ii::linux-generic') }
    specify { expect(chef_run).to include_recipe('timezone-ii::rhel') }
  end

  context 'on CentOS 6.5' do
    let(:chef_run) do
      allow(::File).to receive(:symlink?).with('/etc/localtime')
        .and_return(false)
      ChefSpec::SoloRunner.new(platform: 'centos', version: '6.5')
        .converge(described_recipe)
    end

    specify { expect(chef_run).to install_package('tzdata') }
    specify { expect(chef_run).to include_recipe('timezone-ii::rhel') }
    specify do
      expect(chef_run).not_to include_recipe('timezone-ii::linux-generic')
    end
  end

  context 'on CentOS 7.0' do
    let(:chef_run) do
      ChefSpec::SoloRunner.new(platform: 'centos', version: '7.0')
        .converge(described_recipe)
    end

    specify { expect(chef_run).to install_package('tzdata') }
    specify { expect(chef_run).to include_recipe('timezone-ii::rhel7') }
    specify do
      expect(chef_run).not_to include_recipe('timezone-ii::linux-generic')
    end
  end

  context 'on Debian' do
    let(:chef_run) do
      allow(::File).to receive(:symlink?).with('/etc/localtime')
        .and_return(false)
      ChefSpec::SoloRunner.new(platform: 'debian', version: '7.0')
        .converge(described_recipe)
    end

    specify { expect(chef_run).to install_package('tzdata') }
    specify { expect(chef_run).to include_recipe('timezone-ii::debian') }
    specify do
      expect(chef_run).not_to include_recipe('timezone-ii::linux-generic')
    end
  end

  context 'on Fedora' do
    let(:chef_run) do
      allow(::File).to receive(:symlink?).with('/etc/localtime')
        .and_return(false)
      ChefSpec::SoloRunner.new(platform: 'fedora', version: '20')
        .converge(described_recipe)
    end

    specify { expect(chef_run).to install_package('tzdata') }
    specify { expect(chef_run).to include_recipe('timezone-ii::fedora') }
  end

  context 'on FreeBSD' do
    it_should_behave_like 'an unsupported OS', 'freebsd', '10.0'
  end

  context 'on Gentoo' do
    let(:chef_run) do
      allow(::File).to receive(:symlink?).with('/etc/localtime')
        .and_return(false)
      ChefSpec::SoloRunner.new(platform: 'gentoo', version: '2.1')
        .converge(described_recipe)
    end

    specify { expect(chef_run).to install_package('timezone-data') }
    specify do
      expect(chef_run).to include_recipe('timezone-ii::linux-generic')
    end
    specify do
      expect(chef_run).not_to write_log(anything)
    end
  end

  context 'on PLD' do
    pending
  end

  context 'on Mac OS' do
    it_should_behave_like 'an unsupported OS', 'mac_os_x', '10.9.2'
  end

  context 'on OmniOS' do
    it_should_behave_like 'an unsupported OS', 'omnios', '151008'
  end

  context 'on OpenBSD' do
    it_should_behave_like 'an unsupported OS', 'openbsd', '5.4'
  end

  context 'on OpenSUSE' do
    pending
  end

  context 'on Oracle Linux' do
    pending
  end

  context 'on RedHat' do
    pending
  end

  context 'on SmartOS' do
    it_should_behave_like 'an unsupported OS', 'smartos', '5.11'
  end

  context 'on Solaris2' do
    it_should_behave_like 'an unsupported OS', 'solaris2', '5.11'
  end

  context 'on SUSE' do
    pending
  end

  context 'on Ubuntu' do
    pending
  end

  context 'on Windows' do
    pending
  end
end
