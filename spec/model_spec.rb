require_relative 'spec_helper'
describe Model do

  describe "#guid" do
    before(:each) do
      @root = Page.new('Index')
      @make_page = Page.new('NIKON CORPORATION')
      @page = Model.new('NIKON D80')
      @page.add_parent(@root)
      @page.add_parent(@make_page)
    end
    subject{@page.guid}
    it{should == 'nikon_corporation/nikon_d80'}
  end


  describe "#write" do
    before(:each) do
      @urls = %w(thumb1.jpg thumb2.jpg thumb3.jpg)
      @root = Page.new('Index')
    end
    it "should output the model page under make directory" do
      @page = Model.new('Canon EOS 20D')
      @page.add_parent(@root)
      @page.add_parent(Make.new('Canon'))
      work = Work.new('Canon', 'Canon EOS 20D', 1)
      @page.add_work(work)
      work = Work.new('Canon', 'Canon EOS 20D', 2)
      @page.add_work(work)
      filename = './test_out/canon/canon_eos_20d.html'
      expect {
        File.new(filename)
      }.to raise_error
      @page.write(@urls, './test_out')
      expect {
        File.new(filename)
      }.not_to raise_error
      # File.delete(File.new(filename))
      FileUtils.rm_rf Dir.glob('test_out')
    end
  end

  describe "#to_links" do
    before(:each) do
      @root = Home.new()
      @make = Make.new('Make')
      @model = Model.new('Model')
      @make.add_parent(@root)
      @model.add_parent(@root)
      @model.add_parent(@make)
      work = Work.new('Make', 'Model', 'thumb.jpg')
      @root.add_work(work)
      @make.add_work(work)
      @model.add_work(work)
    end
    it "generates all nav links" do
      links = "<nav><a href='make.html'>Make</a></nav>"
      expect(@root.send('to_links')).to eq links
      links = ["<nav><a href='index.html'>Index</a></nav>", "<nav><a href='make/model.html'>Model</a></nav>"].join("\n")
      expect(@make.send('to_links')).to eq links
      links = ["<nav><a href='../index.html'>Index</a></nav>", "<nav><a href='../make.html'>Make</a></nav>"].join("\n")
      expect(@model.send('to_links')).to eq links
    end
  end


end