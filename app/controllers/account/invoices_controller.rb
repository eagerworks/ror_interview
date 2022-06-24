class Account::InvoicesController < Account::ApplicationController
  account_load_and_authorize_resource :invoice, through: :team, through_association: :invoices

  # GET /account/teams/:team_id/invoices
  # GET /account/teams/:team_id/invoices.json
  def index
    # if you only want these objects shown on their parent's show page, uncomment this:
    # redirect_to [:account, @team]
  end

  # GET /account/invoices/:id
  # GET /account/invoices/:id.json
  def show
  end

  # GET /account/teams/:team_id/invoices/new
  def new
  end

  # GET /account/invoices/:id/edit
  def edit
  end

  # POST /account/teams/:team_id/invoices
  # POST /account/teams/:team_id/invoices.json
  def create
    respond_to do |format|
      if @invoice.save
        format.html { redirect_to [:account, @team, :invoices], notice: I18n.t("invoices.notifications.created") }
        format.json { render :show, status: :created, location: [:account, @invoice] }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @invoice.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /account/invoices/:id
  # PATCH/PUT /account/invoices/:id.json
  def update
    respond_to do |format|
      if @invoice.update(invoice_params)
        format.html { redirect_to [:account, @invoice], notice: I18n.t("invoices.notifications.updated") }
        format.json { render :show, status: :ok, location: [:account, @invoice] }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @invoice.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /account/invoices/:id
  # DELETE /account/invoices/:id.json
  def destroy
    @invoice.destroy
    respond_to do |format|
      format.html { redirect_to [:account, @team, :invoices], notice: I18n.t("invoices.notifications.destroyed") }
      format.json { head :no_content }
    end
  end

  private

  # Never trust parameters from the scary internet, only allow the white list through.
  def invoice_params
    strong_params = params.require(:invoice).permit(
      :description,
      :total,
      # 🚅 super scaffolding will insert new fields above this line.
      # 🚅 super scaffolding will insert new arrays above this line.
    )

    # 🚅 super scaffolding will insert processing for new fields above this line.

    strong_params
  end
end
