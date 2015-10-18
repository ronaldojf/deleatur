class Admin::HomeController < Admin::BaseController
  def index
    @ranking = Student.top_ranking(10)
  end
end