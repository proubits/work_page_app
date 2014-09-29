require_relative 'spec_helper'
describe Make do

  describe "#guid" do
    before(:each) do
      @root = Page.new('Index')
      @page = Make.new('NIKON CORPORATION')
      @page.add_parent(@root)
    end
    subject { @page.guid }
    it { should == 'nikon_corporation' }
  end

  describe "#to_links" do
    before(:each) do
      @root = Home.new()
      @make = Make.new('Make')
      @make.add_parent(@root)
      work = Work.new('Make', 'Model', 'thumb.jpg')
      @root.add_work(work)
      @make.add_work(work)
    end
    it "generates all nav links" do
      links = ["<nav><a href='index.html'>Index</a></nav>", "<nav><a href='make/model.html'>Model</a></nav>"].join("\n")
      expect(@make.send('to_links')).to eq links
    end
  end
end