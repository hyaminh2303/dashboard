class CurrenciesController < AuthorizationController
  before_action :set_currency, only: [:show, :edit, :update, :destroy]

  # GET /currencies
  def index
    @title = I18n.translate('views.currencies.index.title')
    @grid = CurrenciesGrid.new(params[:currencies_grid]) do |scope|
      scope.page(params[:page])
    end
  end

  def list
    respond_to do |format|
      format.json{render json: { currencies: Currency.all }}
    end
  end

  # GET /currencies/1
  def show
    @title = I18n.translate('views.currencies.show.title')
  end

  # GET /currencies/new
  def new
    @title = I18n.translate('views.currencies.new.title')
    @currency = Currency.new
  end

  # GET /currencies/1/edit
  def edit
    @title = I18n.translate('views.currencies.edit.title')
  end

  # POST /currencies
  def create
    @currency = Currency.new(currency_params)
    if @currency.save
      redirect_to currencies_url, notice: I18n.t('messages.create.success', :class_name => I18n.t('models.currency.name'))
    else
      render :new
    end
  end

  # PATCH/PUT /currencies/1
  def update
    if @currency.update(currency_params)
      redirect_to currencies_url, notice: I18n.t('messages.update.success', :class_name => I18n.t('models.currency.name'))
    else
      render :edit
    end
  end

  # DELETE /currencies/1
  def destroy
    @currency.destroy
    redirect_to currencies_url, notice: I18n.t('messages.destroy.success', :class_name => I18n.t('models.currency.name'))
  end

  # POST /currencies/usd.json
  def usd
    params[:price] = params[:price].to_d
    params[:target] = params[:target].to_d

    begin
      price = params[:price].to_money(params[:currency]).as_us_dollar
      budget = (price * params[:target])
      exchange_rate = price.bank.get_rate(params[:currency], Money.default_currency)
    rescue Money::Bank::UnknownRate
      exchange_rate = I18n.t('views.currencies.index.unknown_rate')
      price = Money.new(0)
      budget = Money.new(0)
    end
    respond_to do |format|
      format.json {render json: {price: price.to_f, budget: budget.to_f, exchange_rate: exchange_rate.to_f} }
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_currency
    @currency = Currency.find(params[:id])
  end

  # Only allow a trusted parameter "white list" through.
  def currency_params
    params.require(:currency).permit(:name, :code)
  end

  # Only allow trusted parameters through
  def exchange_params
    params.permit(:currency, :price, :target)
  end
end
