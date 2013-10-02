class TransactionsController < ApplicationController
  skip_before_filter :authorize_page, only: [:to_pdf]

	add_breadcrumb "Transactions", :index_path
	helper_method :index_path

  def index
  	@title = "Transactions"
    @transactions = Transaction.order_last(params[:page])
  end

  def new
  	add_breadcrumb "Add new", new_transaction_path
  	@title = "Add new"
  	@transaction = Transaction.new 
    @transaction.paxes.build
  end

  def edit
  	@title = "Edit"
  	@transaction = Transaction.find(params[:id])
  	add_breadcrumb "Edit", edit_transaction_path(@transaction)
  end

  def show
    @bank_accounts = BankAccount.order_by_name
  	@title = "Transaction"
  	@transaction = Transaction.show(params[:id])
  	add_breadcrumb "Show", transaction_path(@transaction)
  end

  def create
    @title = "Add new"
  	@transaction = Transaction.new(params[:transaction])
    @transaction.admin_user_id = current_user.id
  	add_breadcrumb "Add new", new_transaction_path
  	if @transaction.save!
  		redirect_to transactions_path, notice: "Successfully create transaction"
  	else
  		render action: "new"
  	end
  end

  def update
  	@transaction = Transaction.find(params[:id])
  	@title = "Edit"
  	add_breadcrumb "Edit", edit_transaction_path(@transaction)
  	if @transaction.update_attributes(params[:transaction])
  		redirect_to transaction_path, notice: "Successfully update transaction"
  	else
  		render action: "new"
  	end
  end

  def destroy
  	@transaction = Transaction.find(params[:id])
  	if @transaction.destroy
  		redirect_to :back, notice: "Successfully delete transaction"
  	else
  		flash[:error] = "Failed to delete transaction"
  		redirect_to :back
  	end
  end

  def send_email
    @transaction = Transaction.find(params[:id])
    InvoiceMailer.invoice_email(@transaction, "admin@tripclouds.com", "gilangmahardhika@gmail.com").deliver
    redirect_to @transaction
  end

  def to_pdf
    @bank_accounts = BankAccount.order_by_name
    @transaction = Transaction.show(params[:id])
    respond_to  do |format|
      format.html { render layout: "invoice" }
      format.pdf do
        render pdf: "invoice_#{@transaction.invoice_number}", layout: "invoice" , disposition: 'attachment',
              footer: {
                center: "<p><strong>PT. TRINOBEL TIGRIS</strong></p><p>Level 5, Suite 501-504, Tower B, Beltway Office Park, Jl. Letjen TB Simatupang No.41 Jakarta - Indonesia 12550</p>",  
              }, save_to_file: Rails.root.join("public/invoices/#{@transaction.id}, #{filename}.pdf"), save_only: false
      end
    end
  end

  private
  def index_path
  	transactions_path
  end
end
