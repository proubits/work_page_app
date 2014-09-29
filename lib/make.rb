# A page for camera make. It's parent is the index page
class Make < Page
  def initialize(title)
    super(title)
  end
  def add_work(work)
    super(work, :model, true)
  end

  def guid
    Page.sanitize(@title)
  end

  protected

  def to_up_nav_link(page)
    page.page_link
  end

  def to_sub_nav_link(nav_title)
    sub_guid = Page.sanitize(nav_title)
    guid_for_sub_nav = @parents.empty? ? sub_guid : [guid, sub_guid].join('/')
    "#{guid_for_sub_nav}.#{PAGE_EXT}"
  end
end