
# This is the index page
class Home < Page
  def initialize()
    super('Index')
  end
  def add_work(work)
    super(work, :make, true)
  end
  def guid
    Page.sanitize(@title)
  end

  protected

  def to_sub_nav_link(nav_title)
    "#{Page.sanitize(nav_title)}.#{PAGE_EXT}"
  end
end