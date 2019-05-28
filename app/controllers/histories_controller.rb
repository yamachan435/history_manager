class HistoriesController < ApplicationController
  protect_from_forgery :except => [:bulk_create]
  before_action :set_history, only: [:show, :edit, :update, :destroy, :link, :unlink]

  YEAR_PREFIX = '20'
  ZAIM = true

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

  def bulk_create
    req_json = JSON.parse(request.body.read)
    idm = req_json['idm']
    req_json_rev = req_json['histories'].reverse
    
    reg_flg = false
    suc = 0

    last_history = History.last
    req_json_rev.map!.with_index do |json, i|
      json['date'] = YEAR_PREFIX.to_s + json['date'].to_s
      if i == 0
        json['amount'] = last_history.balance - json['balance']
      else
        json['amount'] = req_json_rev[i-1]['balance'] - json['balance']
      end
      json
    end

    Rails.logger.info req_json_rev
    req_json_rev.each_with_index do |json, i|
      new_rec = History.new(json)
      if reg_flg
        new_rec.save!
      elsif new_rec === History.last
        reg_flg = true
        suc = 20 - i - 1
      end
    end

    unless reg_flg
      req_json_rev.each {|json| History.new(json).save!}
      reg_flg = true
      suc = 20
    end

    ZaimLinkJob.perform_later if ZAIM

    respond_to do |f|
      f.json { render json: {status: "suc", num: suc} }
    end
  end

  def create
    @history = History.new(history_params)

    respond_to do |format|
      if @history.save
        format.html { redirect_to @history, notice: 'History was successfully created.' }
        format.json { render :show, status: :created, location: @history }
      else
        format.html { render :new }
        format.json { render json: @history.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @history.update(history_params)
        format.html { redirect_to @history, notice: 'History was successfully updated.' }
        format.json { render :show, status: :ok, location: @history }
      else
        format.html { render :edit }
        format.json { render json: @history.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @history.destroy
    respond_to do |format|
      format.html { redirect_to histories_url, notice: 'History was successfully destroyed.' }
      format.json { head :no_content }
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
    # Use callbacks to share common setup or constraints between actions.
    def set_history
      @history = History.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def history_params
      params.require(:history).permit(:console, :process, :date, :in_station, :out_station, :balance, :amount)
    end
end
