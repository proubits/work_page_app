require_relative 'spec_helper'
describe Page do
  it{should respond_to(:page_title)}
  it{should respond_to(:page_link)}

  describe "#guid" do
    let(:page) {Page.new('Index')}
    subject{page.guid}
    it{should == 'index'}
  end

  describe "#page_title" do
    subject{Page.new('page title')}
    its(:page_title){should == 'page title'}
  end

  describe "#page_link" do
    subject{Page.new('page title')}
    its(:page_link){should == 'page_title.html'}
  end

  describe "#add_parent" do
    it "adds a page into parent list" do
      root = Page.new('Index')
      page = Page.new('Canon')
      expect {
        page.add_parent(root)
      }.to change(page.instance_variable_get(:@parents), :count).from(0).to(1)
    end
  end

  describe "#add_work" do
    before(:each) do
      @page
    end
    let(:page) {Page.new('title')}
    it "adds a link and thumb into the page" do
      work = Work.new('make', 'model', 1)
      page.instance_variable_get(:@nav_links).should be_empty
      page.instance_variable_get(:@thumbs).should be_empty
      page.add_work(work, :make, true)
      page.instance_variable_get(:@nav_links).should have(1).item
      page.instance_variable_get(:@thumbs).should have(1).item
      work = Work.new('new_make', 'model', 11)
      page.add_work(work, :make, true)
      page.instance_variable_get(:@nav_links).should have(2).item
      page.instance_variable_get(:@thumbs).should have(2).item
    end
    it "ignores the link if a link is already added" do
      page.instance_variable_get(:@nav_links).should be_empty
      page.instance_variable_get(:@thumbs).should be_empty
      work = Work.new('make', 'model', 1)
      page.add_work(work, :make, true)
      work = Work.new('make', 'model', 2)
      page.add_work(work, :make, true)
      page.instance_variable_get(:@nav_links).should have(1).item
      page.instance_variable_get(:@thumbs).should have(2).item
    end
    it "rejects the thumb if limit is reached" do
      page.instance_variable_get(:@nav_links).should be_empty
      page.instance_variable_get(:@thumbs).should be_empty
      1.upto(20) do |i|
      work = Work.new('make', 'model', i)
      page.add_work(work, :make, true)
      end
      page.instance_variable_get(:@nav_links).should have(1).item
      page.instance_variable_get(:@thumbs).should have(10).item
    end
  end

  describe "#write" do
    before(:each) do
      @urls = %w(thumb1.jpg thumb2.jpg thumb3.jpg)
      @root = Page.new('Index')
    end
    it "should output the page" do
      @page = Page.new('Canon')
      @page.add_parent(@root)
      work = Work.new('Canon', 'Canon EOS 20D', 1)
      @page.add_work(work, :model, true)
      work = Work.new('Canon', 'Canon EOS 20D', 2)
      @page.add_work(work, :model, true)
      filename = './test_out/canon.html'
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

  describe "#to_page" do
    before(:each) do
      @urls = %w(thumb1.jpg thumb2.jpg thumb3.jpg)
      root = Page.new('Index')
      @page = Page.new('Canon')
      @page.add_parent(root)
      work = Work.new('make', 'model', 1)
      @page.add_work(work, :make, true)
      work = Work.new('make', 'model', 2)
      @page.add_work(work, :make, true)
    end
    it "generates the page" do
      expected_page = IO.read("./spec/fixtures/files/page.html")
      expect(@page.send('to_page', @urls).strip).to eq expected_page.strip
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


  describe "#to_thumbs" do
    before(:each) do
      root = Page.new('Index')
      @page = Page.new('Canon')
      @page.add_parent(root)
      @urls = %w(thumb1.jpg thumb2.jpg thumb3.jpg)
      work = Work.new('make', 'model', 0)
      @page.add_work(work, :make, true)
      work = Work.new('make', 'model', 1)
      @page.add_work(work, :make, true)
    end
    it "generates all thumbs" do
      thumbs = ["<img src='thumb1.jpg'/>", "<img src='thumb2.jpg'/>"].join("\n")
      expect(@page.send('to_thumbs',@urls)).to eq thumbs
    end
  end

  describe ".sanitize" do
    let(:page){Page.new}
    it "should replace all non-alphanumeric characters to underscore" do
      text = '@#Name() '
      Page.sanitize(text).should == "__name__"
    end
    it "should strip away leading and trailing spaces" do
      text = ' @#Name() '
      Page.sanitize(text).length.should == text.strip.length
    end
    it "should downcase all letters" do
      text = 'NaMe'
      Page.sanitize(text).should == text.downcase
    end
  end
end