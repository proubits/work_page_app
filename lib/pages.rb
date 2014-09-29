# Pages are collection of pages. You use this object to create your pages for
# your works
class Pages
  def initialize(root)
    @pages = {}
    @root = root
    add_page(root)
  end
  # Add work to pages
  # Root page will accept works until the limit is reached
  # Add a make page if it's a new camera Make
  # Add a model page if it's a new camera Model
  def add_work(work)
    #add work to index page
    root_page.add_work(work)
    make = work.make
    model = work.model
    #if no make or model, stop here
    return if make.nil? || model.nil?
    #if it's a new make, then create the object
    if is_a_new_make?(work)
      page = Make.new(make)
      page.add_parent(root_page)
      add_page(page)
    end
    #add work to the make page
    make_page(work).add_work(work)
    if is_a_new_model?(work)
      page = Model.new(model)
      page.add_parent(root_page)
      page.add_parent(make_page(work))
      add_page(page)
    end
    #add work to the model page
    model_page(work).add_work(work)
  end

  def output(urls, out_dir)
    @pages.values.each {|p| p.write(urls, out_dir)}
  end

  private
  def is_a_new_make?(work)
    make_page(work).nil?
  end
  def is_a_new_model?(work)
    model_page(work).nil?
  end
  def root_page
    @root
  end
  #find the make page related to a work
  def make_page(work)
    guid = [Page.sanitize(work.make)].join('/')
    get_page(guid)
  end
  #find the model page related to a work
  def model_page(work)
    guid = [Page.sanitize(work.make),Page.sanitize(work.model)].join('/')
    get_page(guid)
  end
  #find a page by a key
  def get_page(guid)
    @pages[guid]
  end
  #add a page to the collection
  #the page will be able to retrieve with a key
  def add_page(page)
    @pages[page.guid] = page
  end
end