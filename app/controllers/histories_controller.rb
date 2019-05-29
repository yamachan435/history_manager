class HistoriesController < ApplicationController
  before_action :set_history, only: [:show, :edit, :update, :destroy, :link, :unlink]

  def index
    @histories = History.all
  end

  def show
  end

  def new
    @history = History.new
  end

  def edit
  end

  def create
    @history = History.new(history_params)

    respond_to do |format|
      if @history.save
        format.html { redirect_to @history, notice: 'History was successfully created.' }
      else
        format.html { render :new }
      end
    end
  end

  def update
    respond_to do |format|
      if @history.update(history_params)
        format.html { redirect_to @history, notice: 'History was successfully updated.' }
      else
        format.html { render :edit }
      end
    end
  end

  def destroy
    @history.destroy
    respond_to do |format|
      format.html { redirect_to histories_url, notice: 'History was successfully destroyed.' }
    end
  end

  def link
    @history.link
    render :show
  end

  def unlink
    @history.unlink
    render :show
  end

  private
    def set_history
      @history = History.find(params[:id])
    end

    def history_params
      params.require(:history).permit(:console, :process, :date, :in_station, :out_station, :balance, :amount)
    end
end
