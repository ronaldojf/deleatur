class Teacher::HomeController < Teacher::BaseController
  def index
    @ranking = Student.top_ranking(10)
  end
end