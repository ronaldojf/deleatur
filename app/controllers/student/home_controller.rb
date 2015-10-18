class Student::HomeController < Student::BaseController
  before_action :set_ranking, only: [:index]
  before_action :set_user_pontuation, only: [:index]

  private

  def set_ranking
    @ranking = Student.top_ranking(10)
  end

  def set_user_pontuation
    @user_ranking = @ranking.select { |student| student.id == current_user.id }.first || current_user.get_ranking
    @user_pontuation = @user_ranking.total_points
  end
end