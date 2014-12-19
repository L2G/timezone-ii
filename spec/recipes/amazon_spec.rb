require 'spec_helper'

describe 'timezone-ii::amazon' do
  let(:chef_run) do
    allow(::File).to receive(:symlink?).with('/etc/localtime').and_return(false)
    ChefSpec::SoloRunner.new.converge(described_recipe)
  end

  specify { expect(chef_run).to include_recipe('timezone-ii::linux-generic') }
  specify { expect(chef_run).to include_recipe('timezone-ii::rhel') }
end
