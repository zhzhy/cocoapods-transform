require File.expand_path('../../spec_helper', __FILE__)

module Pod
  describe Command::Transform do
    describe 'CLAide' do
      it 'registers it self' do
        Command.parse(%w{ transform }).should.be.instance_of Command::Transform
      end
    end
  end
end

