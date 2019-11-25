class ScansController < ApplicationController
  require "google/cloud/vision"
  require "google/cloud/translate"

  skip_before_action :authenticate_user!

  def new
    @product = Product.new()
    authorize @product
  end

  def create
    @product = Product.find_by(barcode: params[:barcode])
    if user_signed_in?
      history = History.new()
      history.product = @product
      history.user = current_user
      history.save
    end
    if @product
      authorize @product
      redirect_to product_path(@product)
    else
      skip_authorization
      redirect_to new_product_path(barcode: params[:barcode])
    end
  end

  def text_recognition
    @product = Product.find(666)
    authorize @product

    # Credentials
    project_id = "food-decoder-259909"
    credentials = "Food decoder-7338dc37ea95.json"

    # Google Vision
    image_annotator = Google::Cloud::Vision::ImageAnnotator.new(credentials: credentials)

    response = image_annotator.text_detection(
      image: "https://res.cloudinary.com/nst-img/#{@product.label_photo.model[:label_photo]}",
      max_results: 1 # optional, defaults to 10
    )

    # Google Translate
    text          = ""
    language_code = "en"

    response.responses.map do |res|
      label_arr = res.text_annotations.map{ |text| text.description }
      text = label_arr.first.delete "\n"
    end

    Google::Cloud::Translate.configure do |config|
      config.project_id  = project_id
      config.credentials = credentials
    end

    translate   = Google::Cloud::Translate.new version: :v2
    translation = translate.translate text, to: language_code

    @product.label_text = translation.text.inspect
  end

  private

  def scan_params
    params.require(:scan).permit(:barcode)
  end
end
