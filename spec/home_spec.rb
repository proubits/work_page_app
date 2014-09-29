require_relative 'spec_helper'
describe Home do

  describe "#guid" do
    before(:each) do
      @root = Home.new()
    end
    subject { @root.guid }
    it { should == 'index' }
  end

  describe "#to_links" do
    before(:each) do
      @root = Home.new()
      work = Work.new('Make', 'Model', 'thumb.jpg')
      @root.add_work(work)
    end
    it "generates all nav links" do
      links = "<nav><a href='make.html'>Make</a></nav>"
      expect(@root.send('to_links')).to eq links
    end
  end
end