class BillsController < ApplicationController
  before_action :set_bill, only: [:show]
  before_action :fetch_users, only: [:new, :create]

  # GET /bills
  # GET /bills.json
  def index
    @bills = Bill.all
  end

  # GET /bills/1
  # GET /bills/1.json
  def show
    @attendies = @bill.users
    @bill_payments = @bill.bill_payments.includes(:user)
  end

  # GET /bills/new
  def new
    @bill = Bill.new
  end

  # POST /bills
  # POST /bills.json
  def create
    @bill = Bill.new(bill_params)

    respond_to do |format|
      begin
        ActiveRecord::Base.transaction do
          if @bill.save
            @bill.event_attendes.each do |user_id|
              ub = UserBill.new({bill_id: @bill.id, user_id: user_id})
              ub.save
            end
            @bill.bill_contributors.each_with_index do |contributor_id, index|
              bp = BillPayment.new({bill_id: @bill.id, user_id: contributor_id, amount: @bill.contributions[index]})
              bp.save
            end
            (@bill.event_attendes - @bill.bill_contributors).each do |non_contributor|
              bp = BillPayment.new({bill_id: @bill.id, user_id: non_contributor, amount: 0})
              bp.save
            end
            format.html { redirect_to @bill, notice: 'Bill was successfully created.' }
            format.json { render :show, status: :created, location: @bill }
          else
            format.html { render :new }
            format.json { render json: @bill.errors, status: :unprocessable_entity }
          end
        end
      rescue Exception => e
        Rails.logger.info e.message
        flash[:notice] = "Something went wrong, please try again"
        format.html {redirect_to bills_path}
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_bill
      @bill = Bill.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def bill_params
      params.require(:bill).permit( :event, :entry_date, :location, :amount,
                                    :event_attendes => [], :bill_contributors => [],
                                    :contributions => []
                                  )
    end

    def fetch_users
      @users = User.all
    end
end
