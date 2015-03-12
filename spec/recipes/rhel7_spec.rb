require 'spec_helper'

describe 'timezone-ii::rhel7' do
  let(:chef_run) { ChefSpec::SoloRunner.new.converge(described_recipe) }

  specify { expect(chef_run).not_to create_template('/etc/sysconfig/clock') }

  it 'runs the timedatectl utility to change the timezone' do
    expect(chef_run).to run_execute('timedatectl --no-ask-password set-timezone UTC')
  end
end
