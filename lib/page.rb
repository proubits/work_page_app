
# A page is a web page for an image work. It contains 3 main parts :
# * title
# * links to child links
# * thumbnails
#
# === Main Methods
#
# * <tt>*add_parent*(page)</tt>: add this page's parent page
# * <tt>*add_work*(work, nav_target=nil, with_limit=true)</tt>: add the work to this page
# * <tt>*write*(urls=[], out_dir='')</tt>: output page content to a file
# * <tt>*guid*</tt>: used as the unique identifier for the page
# * <tt>*page_title*</tt>: the title of this page
# * <tt>*page_link*</tt>: the link representing the page itself
#
# === Sub classes
#
# Page is a base class which is not directly used. User should use the following sub classes.
# * <b>Home</b>
# * <b>Make</b>
# * <b>Model</b>
#
# === Examples
#
# To create a page, first initiate the correspondent page, then add works into the page, at the
# end, output the page with the "write".
#   cannon = Make.new('Canon')
#   work = Work.new('Canon', 'EOS 2d', 1)
#   cannon.add_work(work, :model, true)
#   canon.write(thumb_urls, 'out_put_dir')
#
class Page
  #limit of thumbnail count
  MAX_THUMB_COUNT = 10
  TEMPLATE = <<eos
<!DOCTYPE html>
<html>
<head>
  <title>{{PAGE_TITLE}}</title>
  <style type="text/css">
    nav {
      margin: 10px;
    }
  </style>
</head>
<body>
  <header>
    <h1>{{PAGE_TITLE}}</h1>

    {{LINK}}
  </header>

    {{THUMB}}
</body>
</html>
eos
  PAGE_EXT = 'html'

  def initialize(page_title='')
    @title = page_title
    @parents = []
    @thumbs = []
    @nav_links = []
  end

  #key for identifying the page
  def guid
    Page.sanitize(@title)
  end

  def page_title
    @title
  end

  #page url
  def page_link
    "#{guid}.#{PAGE_EXT}"
  end

  def add_parent(page)
    @parents << page
  end

  def add_work(work, nav_target=nil, with_limit=true)
    unless nav_target.nil?
      item = work.send(nav_target)
      @nav_links << item unless item.nil? || item.empty? || @nav_links.include?(item)
    end
    @thumbs << work.thumb unless with_limit && @thumbs.count >= MAX_THUMB_COUNT
  end

  #output page content to file
  def write(urls=[], out_dir='')
    page = to_page(urls)
    file_name = to_file_name(@title)
    file = File.join(out_dir, file_name)
    FileUtils.mkdir_p(File.dirname(file))
    File.open(file, 'w'){|f| f.puts page}
  end

  #make the name safe for url and file operation
  def self.sanitize(text)
    text.strip.downcase.gsub(/[^0-9A-Za-z.\-]/, '_')
  end

  protected

  #link to parents
  def to_up_nav_link(page)
    link = @parents.reverse.inject([]) do |result, p|
      result<< '..'
      result << "#{page.page_link}" and break result if p == page
      result
    end.join('/')
    #root page at the same level as make page
    link = link[3..-1] if @parents.first == page
    link
  end

  #link to child links
  def to_sub_nav_link(nav_title)
    "#{Page.sanitize(nav_title)}.#{PAGE_EXT}"
  end

  private

  #generate the page content
  def to_page(urls)
    page = TEMPLATE.dup
    page.gsub!('{{PAGE_TITLE}}', @title)
    page.gsub!('{{LINK}}', to_links)
    page.gsub!('{{THUMB}}', to_thumbs(urls))
    page
  end

  #generate the link section
  def to_links
    [
        to_elements(@parents) {|page| "<nav><a href='#{to_up_nav_link(page)}'>#{page.page_title}</a></nav>"},
        to_elements(@nav_links) {|nav| "<nav><a href='#{to_sub_nav_link(nav)}'>#{nav}</a></nav>"}
    ].join("\n").strip
  end

  #generate the thumbnail section
  def to_thumbs(urls)
    to_elements(@thumbs) do |thumb_index|
      "<img src='#{urls[thumb_index]}'/>"
    end
  end

  #convert a collection of item into page elements
  def to_elements(items, &block)
    items.map(&block).join("\n")
  end

  #generate file name for this page
  def to_file_name(text)
    page_link
  end

end
