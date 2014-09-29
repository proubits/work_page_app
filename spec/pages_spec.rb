require_relative 'spec_helper'
describe Pages do
  before(:all) do
    filename = "./spec/fixtures/files/data.txt"
    text = File.open(filename).read
    @root = Home.new
    @pages = Pages.new(@root)
    @makes = []
    @models = []
    @urls = []
    text.each_line do |line|
      fields = line.split('|')
      make = fields[0].empty? ? nil : fields[0]
      model = fields[1].empty? ? nil : fields[1]
      thumb = fields[2]
      @urls << thumb
      @makes << make unless make.nil? || @makes.include?(make)
      @models << model unless model.nil? || @models.include?(model)
      thumb_index = @urls.count - 1
      work = Work.new(make, model, thumb_index)
      @pages.add_work(work)
    end
    @out_dir = './test_out'
  end
  describe "#add_work" do
    it "should create all pages" do
      @pages.instance_variable_get(:@pages).count.should == (1 + @makes.count + @models.count)
      @root.instance_variable_get(:@thumbs).count.should == Page::MAX_THUMB_COUNT
      leica = @pages.send('get_page', 'leica')
      leica.instance_variable_get(:@thumbs).count.should == 5
      canon = @pages.send('get_page', 'canon')
      canon.instance_variable_get(:@thumbs).count.should == 2
      canon_eos_20d = @pages.send('get_page', 'canon/canon_eos_20d')
      canon_eos_20d.instance_variable_get(:@thumbs).count.should == 1
      canon_eos_400d = @pages.send('get_page', 'canon/canon_eos_400d_digital')
      canon_eos_400d.instance_variable_get(:@thumbs).count.should == 1
    end
  end
  describe "#output" do
    it "should output all pages" do
      @pages.output(@urls, @out_dir)
      Dir.chdir(@out_dir)
      Dir.glob("*.html").count.should == (@makes.count + 1) #index.html
      #make as dir name
      (Dir.glob("*").count - Dir.glob("*.html").count).should == @makes.count
      Dir.glob("leica/*.html").count.should == 1
      Dir.glob("canon/*.html").count.should == 2
      #clean the files
      Dir.chdir('../')
      FileUtils.rm_rf Dir.glob(@out_dir.split('/').last)
    end
  end
end