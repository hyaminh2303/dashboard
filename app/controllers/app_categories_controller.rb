class AppCategoriesController < ApplicationController
  def index
    @app_categories = AppCategory.all.order(name: :asc)
  end
end
