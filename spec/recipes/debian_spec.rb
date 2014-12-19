require 'spec_helper'

describe 'timezone-ii::debian' do
  let(:chef_run) { ChefSpec::SoloRunner.new.converge(described_recipe) }

  it 'should be tested ;-)'
end
