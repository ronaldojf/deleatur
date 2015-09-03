class Admin::BaseController < ApplicationController
  include IndexTableFilters
  before_action :authenticate_administrator!

  layout 'admin'
end