require 'spec_helper'

describe 'timezone-ii::rhel' do
  let(:chef_run) { ChefSpec::SoloRunner.new.converge(described_recipe) }

  specify { expect(chef_run).to create_template('/etc/sysconfig/clock') }

  context 'template[/etc/sysconfig/clock]' do
    let(:template) { chef_run.template('/etc/sysconfig/clock') }

    it 'should notify the update script when it is created' do
      expect(template).to notify('execute[tzdata-update]').to(:run).delayed
    end
  end

  context 'on Amazon Linux' do
    it 'needs tests...'
  end

  context 'on non-Amazon-Linux flavors' do
    specify do
      expect(chef_run.execute('tzdata-update')).to do_nothing
    end
  end
end
