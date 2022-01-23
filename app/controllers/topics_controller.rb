class TopicsController < ApplicationController
  before_action :logged_in_user, only: %i[create new edit update destroy]
  before_action :correct_user,   only: :destroy
end
