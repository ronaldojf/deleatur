class Admin::BaseController < ApplicationController
  include AuthenticatedUsersHelper
  before_action :authenticate_administrator!
  before_action :filters, only: [:index]

  layout 'admin'
end