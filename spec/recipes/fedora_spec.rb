require 'spec_helper'

describe 'timezone-ii::fedora' do
  let(:chef_run) { ChefSpec::SoloRunner.new.converge(described_recipe) }

  specify { expect(chef_run).to include_recipe('timezone-ii::rhel7') }
end
