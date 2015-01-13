require 'spec_helper'

describe 'timezone-ii::debian' do
  let(:chef_run) { ChefSpec::SoloRunner.new.converge(described_recipe) }

  specify { expect(chef_run).to create_template('/etc/timezone') }

  context 'template[/etc/timezone]' do
    let(:template) { chef_run.template('/etc/timezone') }

    it 'should notify the update script when it is created' do
      expect(template).to notify('execute[dpkg-reconfigure-tzdata]').to(:run).delayed
    end
  end
end
