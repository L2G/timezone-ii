require 'spec_helper'

describe 'timezone-ii::rhel' do
  context 'on unspecified platforms' do
    let(:chef_run) { ChefSpec::SoloRunner.new.converge(described_recipe) }

    specify { expect(chef_run).to create_template('/etc/sysconfig/clock') }

    context 'template[/etc/sysconfig/clock]' do
      let(:template) { chef_run.template('/etc/sysconfig/clock') }

      it 'should notify the update script when it is created' do
        expect(template).to notify('execute[tzdata-update]').to(:run).delayed
      end
    end

    specify do
      expect(chef_run.execute('tzdata-update')).to do_nothing
    end

    it 'should NOT run the tzdata-update command',
      pending: 'need to find a way to verify behavior of "run" notification'
  end

  context 'on Centos 6.5' do
    let(:chef_run) do
      ChefSpec::SoloRunner.new(platform: 'centos', version: '6.5')
        .converge(described_recipe)
    end

    specify { expect(chef_run).to create_template('/etc/sysconfig/clock') }
    specify { expect(chef_run).not_to include_recipe('timezone-ii::rhel7') }

    context 'template[/etc/sysconfig/clock]' do
      let(:template) { chef_run.template('/etc/sysconfig/clock') }

      it 'should notify the update script when it is created' do
        expect(template).to notify('execute[tzdata-update]').to(:run).delayed
      end
    end

    it 'should run the tzdata-update command',
      pending: 'need to find a way to verify behavior of "run" notification'
  end

  context 'on Centos 7.0' do
    let(:chef_run) do
      ChefSpec::SoloRunner.new(platform: 'centos', version: '7.0')
        .converge(described_recipe)
    end

    specify { expect(chef_run).not_to create_template('/etc/sysconfig/clock') }
    specify { expect(chef_run).to include_recipe('timezone-ii::rhel7') }
  end

  context 'on Amazon Linux' do
    it 'needs tests...'
  end
end
