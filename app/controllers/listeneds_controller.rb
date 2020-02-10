# coding: utf-8
class ListenedsController < ApplicationController
  before_action :set_listened, only: [:show, :edit, :update, :destroy]

  # GET /listeneds
  def index
    @search_listened = Listened::Search.new(search_params)
    @listeneds = @search_listened.search(params[:page])
  end

  # GET /listeneds/1
  def show
  end

  # GET /listeneds/new
  def new
    @listened = Listened.new
  end

  # GET /listeneds/1/edit
  def edit
  end

  # POST /listeneds
  def create
    if Listened.insert(listened_params)
      render plain: :success
    else
      render plain: :failure
    end

    #@listened = Listened.new(listened_params)

#    if @listened.save
#      redirect_to @listened, notice: 'Listened was successfully created.'
#    else
#      render :new
#    end
  end

  # PATCH/PUT /listeneds/1
  def update
    if @listened.update(listened_params)
      redirect_to @listened, notice: 'Listened was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /listeneds/1
  def destroy
    @listened.logical_delete!
    redirect_to listeneds_url, notice: 'Listened was successfully destroyed.'
  end

  private
    # Search params
    def search_params
      if params[:listened_search]
        params.require(:listened_search).permit(:listen_words, :listen_origin, :listen_at_from, :listen_at_to, :user_id_from, :user_id_to, :value_from, :value_to)
      else
        {}
      end
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_listened
      @listened = Listened.active.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def listened_params
      params.require(:listened).permit(:listen_at, :user_id, :listen_words, :listen_origin, :value, :lock_version)
    end
end
