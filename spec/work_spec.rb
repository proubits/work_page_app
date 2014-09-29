require_relative 'spec_helper'
describe Work do
  subject{Work.new('k', 'd', 't')}
  it {should respond_to(:make)}
  it {should respond_to(:model)}
  it {should respond_to(:thumb)}
end