
require 'rexml/document'
require 'fileutils'

require_relative './lib/work.rb'
require_relative './lib/page.rb'
require_relative './lib/model'
require_relative './lib/make'
require_relative './lib/home'
require_relative './lib/pages.rb'

#make sure the require conditions are met
if ARGV.count<2
  puts "Usage : ruby app.rb path_to_xml output_dir"
  exit 0
end
input = ARGV[0]
out_dir = ARGV[1]
unless File.exist?(input)
  puts "input xml does not exist."
  exit 0
end
unless File.exist?(out_dir)
  puts "output dir does not exist."
  exit 0
end

#create the root page
root = Home.new
#create the pages collection
pages = Pages.new(root)
#array to store thumb urls
work_thumb_urls = []
#start parsing xml
doc = REXML::Document.new(File.new(input))
doc.elements.each('works/work') do |node|
  make_ele = node.get_text('exif/make')
  model_ele = node.get_text('exif/model')
  thumb_ele = node.get_text('urls/url[@type="small"]')

  make = make_ele.nil? ? nil : make_ele.value
  model = model_ele.nil? ? nil : model_ele.value
  thumb = thumb_ele.nil? ? '' : thumb_ele.value

  work_thumb_urls << thumb

  work = Work.new(make, model, work_thumb_urls.count - 1)

  pages.add_work(work)
end

#output the pages
pages.output(work_thumb_urls, out_dir)
