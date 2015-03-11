require 'spec_helper'

describe 'timezone-ii::solaris2' do
  TIMEZONE_CHECK_CMD = 'svccfg -s timezone:default listprop ' \
                       'timezone/localtime | grep UTC'

  context 'when existing timezone setting is different or not present' do
    let(:chef_run) do
      stub_command(TIMEZONE_CHECK_CMD).and_return(nil)
      ChefSpec::SoloRunner.new.converge(described_recipe)
    end

    it 'sets the timezone' do
      expect(chef_run).to run_execute('set_timezone')
        .with(command: 'svccfg -s timezone:default setprop timezone/localtime='\
                       ' astring: UTC; svcadm refresh timezone:default')
    end
  end

  context 'when existing timezone setting is already the desired value' do
    let(:chef_run) do
      stub_command(TIMEZONE_CHECK_CMD).and_return('UTC')
      ChefSpec::SoloRunner.new.converge(described_recipe)
    end

    it 'does nothing' do
      expect(chef_run.execute('set_timezone')).to do_nothing
    end
  end
end
