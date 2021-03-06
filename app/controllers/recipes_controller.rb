class RecipesController < ApplicationController
  load_and_authorize_resource
  def index
    @recipes = current_user.recipes.all
  end

  def show
    @recipe = Recipe.find(params[:id])
  end

  def new
    @recipe = Recipe.new
  end

  def create
    @recipe = current_user.recipes.build(recipe_params)

    respond_to do |format|
      format.html do
        if @recipe.save
          redirect_to recipes_url, notice: 'Recipe created successfully'
        else
          render :new, alert: 'Recipe not created. Please try again!'
        end
      end
    end
  end

  def destroy
    previous_url = request.env['HTTP_REFERER']
    @recipe = Recipe.find(params[:id])

    if @recipe.destroy
      flash[:notice] = 'Recipe Deleted successfully!'
    else
      flash[:alert] = 'Unable to delete Recipe Try again later'
    end
    redirect_to(previous_url)
  end

  private

  def recipe_params
    params.require(:recipe).permit(:name, :description, :public, :preparation_time, :cooking_time)
  end
end
