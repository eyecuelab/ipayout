require 'spec_helper'

describe EyecueIpayout do
  subject { EyecueIpayout.new }

  it 'should have a version' do
    EyecueIpayout::VERSION.wont_be_nil
  end

end