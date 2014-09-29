# A page for camera model. It's direct parent is the model page
class Model < Page
  def initialize(title)
    super(title)
  end

  def add_work(work)
    super(work, nil, false)
  end

  def guid
    [@parents.last.page_title, @title].map{|text| Page.sanitize(text)}.join('/')
  end

  protected

  def to_up_nav_link(page)
    ['..', page.page_link].join('/')
  end
end