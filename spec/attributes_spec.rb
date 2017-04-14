require 'spec_helper'

describe 'timezone-ii default attributes' do
  context 'on Debian' do
    let(:chef_run) do
      ChefSpec::SoloRunner.new(platform: 'debian', version: '7.4').converge('timezone-ii')
    end

    specify { expect(chef_run.node['tz']).to eq 'Etc/UTC' }
    specify { expect(chef_run.node['timezone']['tzdata_dir']).to eq '/usr/share/zoneinfo' }
    specify { expect(chef_run.node['timezone']['localtime_path']).to eq '/etc/localtime' }
    specify { expect(chef_run.node['timezone']['use_symlink']).to be_falsey }
  end

  context 'on non-Debian' do
    let(:chef_run) do
      ChefSpec::SoloRunner.new.converge('timezone-ii')
    end

    specify { expect(chef_run.node['tz']).to eq 'UTC' }
    specify { expect(chef_run.node['timezone']['tzdata_dir']).to eq '/usr/share/zoneinfo' }
    specify { expect(chef_run.node['timezone']['localtime_path']).to eq '/etc/localtime' }
    specify { expect(chef_run.node['timezone']['use_symlink']).to be_falsey }
  end
end
