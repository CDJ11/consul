class Communication::BannersController < Communication::BaseController

  has_filters %w{all with_active with_inactive}, only: :index

  before_action :banner_sections, only: [:edit, :new, :create, :update]

  respond_to :html, :js

  load_and_authorize_resource

  def index
    @banners = Banner.send(@current_filter).page(params[:page])
  end

  def create
    @banner = Banner.new(banner_params)
    if @banner.save
      redirect_to action: :index
    else
      render :new
    end
  end

  def update
    if @banner.update(banner_params)
      redirect_to action: :index
    else
      render :edit
    end
  end

  def destroy
    @banner.destroy
    redirect_to action: :index
  end

  private

    def banner_params
      attributes = [:title, :description, :target_url,
                    :post_started_at, :post_ended_at,
                    :background_color, :font_color,
                    web_section_ids: []]
      params.require(:banner).permit(*attributes)
    end

    def banner_styles
      @banner_styles = Setting.all.banner_style.map do |banner_style|
                         [banner_style.value, banner_style.key.split('.')[1]]
                       end
    end

    def banner_imgs
      @banner_imgs = Setting.all.banner_img.map do |banner_img|
                       [banner_img.value, banner_img.key.split('.')[1]]
                     end
    end

    def banner_sections
      @banner_sections = WebSection.all
    end

end