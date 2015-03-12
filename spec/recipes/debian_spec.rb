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

  context 'execute[dpkg-reconfigure-tzdata]' do
    let(:execute) { chef_run.execute('dpkg-reconfigure-tzdata') }

    it 'should do nothing by default' do
      expect(execute).to do_nothing
    end
  end

  context 'log[if-unexpected-timezone-change]' do
    it 'is in need of tests'
  end
end
